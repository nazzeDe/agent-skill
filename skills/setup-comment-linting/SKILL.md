---
name: setup-comment-linting
description: 初始化项目的注释规范体系：配置 linter 以关闭冗余注释检查、生成精简的规范文档供 code-review 时参考、可选配置 pre-commit hook。适用于用户想设置注释规范、配置注释 linting、让 review 时检查注释质量时。
---

# 设置注释规范

## 这会配置什么

1. **Linter 配置**：为项目中的每种语言（Python、TypeScript、Go、Rust、C/C++）写入或更新 linter 配置，关闭强制冗余注释的规则
2. **规范文档**：生成 `docs/agents/comment-guidelines.md`，包含通用三问、linter 配置说明、反例库
3. **AGENTS.md 引用**：追加一行，让 code-review skill 在审查时检查注释
4. **Pre-commit hook**（可选）：配置 linter 自动检查 staged 文件的注释格式

## 原理

注释的价值由"代码能否推出"定义。好注释必须：
1. 删掉它，读者会因此做错事（承载约束）
2. 引入代码里没有的词（外部系统名、错误码、单位、边界值、bug 编号）
3. 能压成一行（不能则属于文档，不属于源码）

Linter 只能检测形式问题（格式、结构），占总问题的 10-20%；语义冗余（复述代码、辩护设计、解释常识）需要在 code review 时由 AI agent 参考规范文档检查。

## 步骤

### 1. 检测项目语言

通过配置文件判断项目使用的语言：
- Python: `pyproject.toml`、`setup.py`、`setup.cfg`
- TypeScript/JavaScript: `package.json`、`tsconfig.json`
- Go: `go.mod`
- Rust: `Cargo.toml`
- C/C++: `CMakeLists.txt`、`Makefile`、`configure.ac`

记录所有检测到的语言，后续步骤为每种语言生成对应配置。

### 2. 生成规范文档

创建 `docs/agents/comment-guidelines.md`，内容包括：

#### 结构
```markdown
# 注释规范

本项目检测到的语言：[列出所有语言]

## 通用三问

写任何注释前，三个问题全过才写：

1. **删掉它，读者会不会因此做错事？** 否 → 复述，删掉
2. **引入了代码里没有的词？** 没有 → 可被代码推出，删掉
3. **能否压成一行？** 不能 → 属于文档，不属于源码

值得写的三类内容：
- 约束：不变量、前置条件、单位、取值范围、线程假设
- 外部理由：上游 bug 编号、协议条款、性能数据、兼容性要求
- 反直觉的取舍：代码看起来更笨但有意为之

## Linter 配置

[为每种检测到的语言生成对应章节，包含：]
- 权威口径引用（PEP 8/257、Google Style Guide、Go Doc Comments 等）
- 本项目的配置（关闭哪些规则、为什么）
- 配置示例代码块

## 反例库

[只包含本项目语言的反例]
```

#### 各语言配置内容

**Python**
```markdown
### Python

**权威口径**: [PEP 8 §Comments](https://peps.python.org/pep-0008/#comments), [PEP 257](https://peps.python.org/pep-0257/), [Google Python Style Guide §3.8](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)

**关键规则**:
- Docstring 用祈使句：`"""Return the path."""`
- 不复述参数：`@param` 不应只重复参数名和类型
- 没有新信息就不写：docstring 只对公共 API、非平凡实现、非显而易见逻辑强制

**本项目配置**（`pyproject.toml`）:
```toml
[tool.ruff.lint]
select = ["D200", "D404"]
ignore = [
  "D205",  # 强制摘要行后空行 - 即强制多段式
  "D101",  # 强制每个类都有 docstring
  "D102",  # 强制每个方法都有 docstring
  "D107",  # 强制 __init__ 有 docstring
  "D401",  # 人称检查（只在单语言项目需要时启用）
]
```

**TypeScript/JavaScript**
```markdown
### TypeScript / JavaScript

**权威口径**: [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html#comments-documentation)

**关键规则**:
- `@param` 和 `@return` 是选填的，只在添加新信息时写
- 不要只重复参数名和类型

**本项目配置**（`package.json` 或 `.eslintrc`）:
```json
{
  "rules": {
    "jsdoc/require-param": "off",
    "jsdoc/require-returns": "off"
  }
}
```

**Go**
```markdown
### Go

**权威口径**: [Go Doc Comments](https://go.dev/doc/comment), [Code Review Comments](https://go.dev/wiki/CodeReviewComments#doc-comments)

**关键规则**:
- Doc comment 是完整句子，以符号名开头
- 所有导出的顶层名字都要有 doc comment
- 使用固定前缀：`Deprecated:`、`BUG(uid):`、`TODO(uid):`

**本项目配置**: 使用 `golangci-lint` 的 `godot`（句末标点）、`revive` 的 `exported`（注释须以符号名开头）
```

**Rust**
```markdown
### Rust

**权威口径**: [RFC 1574](https://rust-lang.github.io/rfcs/1574-more-api-documentation-conventions.html)

**关键规则**:
- 摘要行用第三人称单数现在时：`/// Returns the path.`
- 公共 API 需要文档

**本项目配置**: 对公共 API 开启 `#![warn(missing_docs)]`
```

**C/C++**
```markdown
### C / C++

**权威口径**: [Linux kernel CodingStyle §8](https://docs.kernel.org/process/coding-style.html#commenting)

**关键规则**:
- 不要解释 HOW，把代码写到不需要解释 HOW
- 注释写在函数头部，说明做什么、为什么
- 不写只重复函数签名的样板
```

#### 反例库

为每种语言包含对应反例：

**Python 反例**:
- `# 遍历所有包` 在 `for pkg in packages:` 上方 → 违反 PEP 8 "state the obvious"
- `@param region Region 代码` → 只重复参数名
- 模块 docstring 论证分层是否合理 → Google §3.8 "not implementation details"

**TypeScript 反例**:
- `/** @param fooBarService The Bar service for the Foo application. */` → Google TS Guide "restate the parameter name and type"

如果文件已存在，询问用户：
- 覆盖（替换为新生成的版本）
- 跳过（保留现有文件）
- 备份后覆盖（将现有文件重命名为 `.bak`）

### 3. 配置 Linter

为每种检测到的语言配置 linter：

#### Python (ruff)

检查 `pyproject.toml` 是否存在 `[tool.ruff.lint]`：
- **不存在**：直接写入推荐配置
- **存在**：检查冲突（现有 `ignore` 列表是否包含 `D101`/`D102`/`D107`/`D205`，`select` 是否包含我们要关掉的规则）
  - 有冲突：生成合并预览，附简洁解释，询问用户（覆盖 / 合并 / 跳过）
  - 无冲突：自动合并

#### TypeScript/JavaScript (eslint-plugin-jsdoc)

检查 `package.json` 的 `eslintConfig` 或独立的 `.eslintrc*` 文件：
- **不存在**：写入推荐配置到 `package.json` 或创建 `.eslintrc.json`
- **存在**：同上冲突检查逻辑

#### Go (golangci-lint)

检查 `.golangci.yml` 或 `.golangci.yaml`：
- **不存在**：创建配置，启用 `godot`、`revive` 的 `exported` 规则
- **存在**：检查并合并

#### Rust

检查 `Cargo.toml` 或 `src/lib.rs`/`src/main.rs`：
- 建议在公共库的入口文件添加 `#![warn(missing_docs)]`
- 不强制修改，给出建议即可

#### C/C++

提示：C/C++ 的注释规范主要依赖人工 review，linter（clang-tidy、cppcheck）不覆盖语义层面的检查。

### 4. 更新 AGENTS.md

在 `AGENTS.md` 末尾追加一行：

```markdown
代码审查时检查注释是否符合 docs/agents/comment-guidelines.md
```

如果 `AGENTS.md` 不存在，创建它并写入上述内容。

### 5. 配置 Pre-commit Hook（可选）

检测项目 pre-commit 状态：

#### 如果项目没有 pre-commit：
询问用户："是否要安装 pre-commit 并配置注释检查？"
- **同意**：
  1. 安装 pre-commit：`pip install pre-commit`（Python 项目）或 `npm install -g pre-commit`
  2. 创建 `.pre-commit-config.yaml`
  3. 运行 `pre-commit install`
- **拒绝**：跳过此步骤，不生成配置文件

#### 如果项目已有 `.pre-commit-config.yaml`：
询问用户："是否要将注释检查添加到现有 pre-commit 配置？"
- **同意**：追加对应语言的 hook
- **拒绝**：跳过

#### Pre-commit 配置内容

根据检测到的语言，添加对应 hook：

**Python**:
```yaml
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.0
    hooks:
      - id: ruff
        args: [--fix]
        types: [python]
```

**TypeScript/JavaScript**:
```yaml
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.50.0
    hooks:
      - id: eslint
        args: [--fix]
        types: [javascript, typescript]
```

**Go**:
```yaml
  - repo: https://github.com/golangci/golangci-lint
    rev: v1.54.0
    hooks:
      - id: golangci-lint
```

**注意**：
- 只检查 staged 文件（pre-commit 框架默认行为）
- 使用框架的自动 re-stage（修改后自动更新 staging 区）
- Hook 只运行 linter，不包含 AI 评估

### 6. 验证

- [ ] `docs/agents/comment-guidelines.md` 存在且包含所有检测到的语言
- [ ] 各语言的 linter 配置文件已更新
- [ ] `AGENTS.md` 包含规范文档引用
- [ ] （如果配置了）`.pre-commit-config.yaml` 存在且包含注释检查 hook
- [ ] （如果配置了）运行 `pre-commit run --all-files` 验证可用

### 7. 完成提示

输出总结：
```
✓ 注释规范已配置完成

检测到的语言：[列表]
生成的文档：docs/agents/comment-guidelines.md
配置的 linter：[列表]
Pre-commit hook：[已配置 / 未配置]

后续使用：
- 日常开发：linter 会自动检查注释格式（形式层面）
- Code review：code-review skill 会参考规范文档检查语义冗余

运行 code review 时，AI 会自动检查注释是否符合规范。
```

## 注意事项

### Linter 覆盖范围
Linter 只能检测形式问题（10-20%）：
- ✅ 格式、结构、缺失标点
- ❌ 复述代码、辩护设计、解释常识

语义冗余需要在 code review 阶段由 AI agent 检查。

### 语法人称差异
不同语言的注释人称约定相反：
- Python: 祈使句（`Return`）
- Rust/Go/TypeScript: 第三人称（`Returns`）

本 skill 不强制人称规则（已关闭 Python 的 `D401`），因为多语言项目无法统一。

### 与 code-review skill 集成
生成的规范文档会被 code-review skill 自动读取。review 时 AI 会：
1. 检查代码是否符合 Standards（包括注释规范）
2. 应用"通用三问"判断注释是否冗余
3. 引用反例库标记问题注释

### 幂等性
Skill 可以重复运行：
- 文档冲突时询问用户
- Linter 配置冲突时生成合并预览
- 不会破坏已有配置
