---
name: init-project
description: 为代码项目初始化确定性静态门禁脚本（gate）、Linter 注释降噪规则、Git pre-commit 钩子与极简环境指针。
disable-model-invocation: true
---

# 初始化代码项目（Init Project）

通过一次探查与一轮问答，将项目的硬性工程要求固化为可执行的**静态门禁脚本（Static Gate）**与 Linter 配置，把一切可静态判定的检查锁死在工具层。

## 探查项目现状

在不向用户提问的前提下，自动检查当前仓库：
* **语言与工具链**：识别配置文件（`Cargo.toml`、`pyproject.toml`、`package.json`、`go.mod`、`deps.edn`、`CMakeLists.txt` 等）、包管理器、现有测试命令与 Linter 配置。
* **本地门禁工具**：检查 `/home/nazze/Studio/oss/unclebob/crapper/crapper` 与 `/home/nazze/Studio/oss/unclebob/dryer/dryer`（或环境变量中的同名命令）是否可用。
* **现有文档与钩子**：检查 `AGENTS.md` / `CLAUDE.md`、`GLOSSARY.md`、`docs/agents/` 及 `.git/hooks/pre-commit`。
* **完成判据**：已掌握当前项目真实的编译、测试、Linter 命令及现有配置状态。

## 一轮问答敲定硬性要求

以 `❓ **<标题>** -> ➡️ <推荐答案>` 的格式一次性向用户展示以下配置方案（用户回复 `yes` 即可全部采纳）：

* **❓ 静态硬门禁脚本（`./scripts/gate`）**：
  列出为该项目定制的单命令检查序列：
  * 语法与类型检查（如 `cargo check`、`tsc --noEmit`、`mypy`/`pyright`、`go vet`）
  * Linter 检查（如 `cargo clippy -- -D warnings`、`ruff check`、`eslint`、`golangci-lint run`）
  * 测试套件运行
  * 纯圈复杂度门禁：`crapper --no-coverage --changed --threshold 10`（不绑架测试覆盖率）
  * 结构重复度门禁：`dryer`（重复度阈值 `0.8`）
  * ➡️ 推荐：生成可执行脚本 `./scripts/gate` 并赋予执行权限。

* **❓ 注释静态降噪与 Linter 配置**：
  * **Linter 级拦截**：关闭当前语言强制要求所有函数/类写文档注释的冗余规则（如 Ruff 忽略 `D100-D107` / `D205`；ESLint 关闭 `jsdoc/require-*`），同时开启死代码注释与空注释拦截（如 Ruff 开启 `ERA001` 拦截被注释掉的代码、开启 `D419` 拦截空 docstring）。
  * **Diff 级静态垃圾注释拦截**：在 `./scripts/gate` 中加入对 `git diff` 新增注释行的静态正则/AST 检查，直接拦截分步解说注释（`Step 1`、`第一步`）、视觉分割线（`====`、`----`）与无编号裸 `TODO`。
  * **极简注释规范**：将本目录下的 [`COMMENT-GUIDELINES.md`](COMMENT-GUIDELINES.md) 复制写入项目的 `docs/agents/comment-guidelines.md`。
  * ➡️ 推荐：开启全部静态注释拦截并更新 Linter 配置。

* **❓ Git Pre-commit 钩子**：
  * 是否在 `.git/hooks/pre-commit`（或项目现有钩子工具）中挂载静态检查？
  * ➡️ 推荐：挂载 `./scripts/gate`（若全量测试较慢，则在 pre-commit 中运行除慢速集成测试外的快速静态门禁）。

* **❓ 极简环境指针（`AGENTS.md` / `CLAUDE.md`）**：
  * 在项目已有的 `AGENTS.md` 或 `CLAUDE.md`（若均不存在则创建 `AGENTS.md`）中，**仅写入环境事实指针**（严禁写入任何工作流编排规则）：
    ```markdown
    ## Environment
    - Static gate: `./scripts/gate`
    - Domain glossary: `GLOSSARY.md`
    - Code taste: `docs/agents/taste.md`
    - Comment rules: `docs/agents/comment-guidelines.md`
    ```
  * ➡️ 推荐：更新环境指针，并按需创建空的 `docs/agents/taste.md`。

* **完成判据**：用户明确确认或调整了上述四项配置。

## 写入配置并验证

按用户确认的方案写入 Linter 配置、`./scripts/gate`、`docs/agents/comment-guidelines.md`（源自 [`COMMENT-GUIDELINES.md`](COMMENT-GUIDELINES.md)）及环境指针：

* **执行冒烟验证**：立即运行 `./scripts/gate`，验证脚本可执行且在当前工作区正常跑通（若已有代码触发阈值警告，向用户报告具体输出）。
* **完成判据**：所有配置文件与脚本已落盘，`./scripts/gate` 实跑验证完成。
