#!/usr/bin/env python3
from __future__ import annotations

import importlib.machinery
import importlib.util
from pathlib import Path
import tempfile
import unittest

SCRIPT = Path.home() / ".pi" / "agent" / "bin" / "trellis-local"
loader = importlib.machinery.SourceFileLoader("trellis_local", str(SCRIPT))
spec = importlib.util.spec_from_loader(loader.name, loader)
assert spec is not None
module = importlib.util.module_from_spec(spec)
loader.exec_module(module)


class TrellisLocalUnitTests(unittest.TestCase):
    def test_gitattributes_owned_block_is_removed_without_touching_neighbors(self) -> None:
        content = "before text\n# Trellis: append-only developer journals should merge cleanly\n# detail\n.trellis/workspace/*/journal-*.md merge=union\nafter text\n"
        updated, changed = module.strip_trellis_gitattributes(content)
        self.assertTrue(changed)
        self.assertEqual(updated, "before text\nafter text\n")

    def test_incomplete_gitattributes_block_fails_without_output(self) -> None:
        content = "before\n# Trellis: append-only developer journals should merge cleanly\nafter\n"
        with self.assertRaises(module.LocalModeError):
            module.strip_trellis_gitattributes(content)

    def test_duplicate_session_auto_commit_keys_collapse_to_one_false(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            path = Path(temp_dir) / "config.yaml"
            path.write_text(
                "# session_auto_commit: true\nsession_auto_commit: true\nother: value\nsession_auto_commit: yes\n",
                encoding="utf-8",
            )
            self.assertTrue(module.patch_session_auto_commit(path))
            content = path.read_text(encoding="utf-8")
            self.assertEqual(content.count("session_auto_commit:"), 1)
            self.assertIn("session_auto_commit: false", content)
            self.assertTrue(module.active_session_auto_commit_false(path))

    def test_quarantine_preserves_different_versions(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            source = root / ".agents/skills/trellis-future"
            source.mkdir(parents=True)
            (source / "SKILL.md").write_text("v1\n", encoding="utf-8")
            self.assertTrue(
                module.disable_path(
                    root,
                    Path(".agents/skills/trellis-future"),
                    "skills",
                )
            )

            source.mkdir(parents=True)
            (source / "SKILL.md").write_text("v2\n", encoding="utf-8")
            self.assertTrue(
                module.disable_path(
                    root,
                    Path(".agents/skills/trellis-future"),
                    "skills",
                )
            )

            copies = sorted((root / ".trellis/local-disabled/skills").glob("trellis-future*"))
            self.assertEqual(len(copies), 2)
            self.assertEqual(
                {copy.joinpath("SKILL.md").read_text(encoding="utf-8") for copy in copies},
                {"v1\n", "v2\n"},
            )

    def test_known_agents_blocks_are_replaced_but_unknown_native_text_fails(self) -> None:
        known = "prefix\n<!-- TRELLIS:START -->\n# Trellis Instructions\n<!-- TRELLIS:END -->\nsuffix\n"
        self.assertEqual(module.sanitized_agents_content(known), "prefix\nsuffix")
        with self.assertRaises(module.LocalModeError):
            module.sanitized_agents_content("prefix\n# Trellis Instructions\nsuffix\n")


if __name__ == "__main__":
    unittest.main()
