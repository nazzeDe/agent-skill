---
name: to-issue
description: 在开发过程中快速记录遇到的问题，保持独立性以便后续处理。适用于遇到需要独立修复的 bug、enhancement、refactor 或 tech-debt，但不想打断当前工作流时。
---

# To-Issue：快速问题记录

## 核心原则

* **一问题一记录（One Issue, One Problem）**：每个 issue 只关注单一问题。若发现多个不相关问题，分别记录。
* **最小必要信息（Minimal Viable Info）**：只记录定位和复现问题所需的核心信息，避免冗余描述。
* **即记即走（Quick Capture）**：记录过程不超过 2 分钟，不打断当前主线工作。
* **独立可执行（Self-Contained）**：记录的信息足够让未来的自己或其他人独立理解和解决问题。

## 使用场景

* **主线开发中遇到边界问题**：解决 A 时发现 B 也有问题，但 B 不在当前 commit 范围内
* **技术债务累积**：发现代码异味、重复逻辑或结构问题，但当前任务不包含重构
* **依赖阻塞**：需要等待外部依赖、API 或第三方库修复
* **性能瓶颈**：发现性能问题但不影响当前功能交付
* **文档缺失**：发现缺少关键文档或注释，但不在当前任务范围

## 工作流

1. **确定问题类型**：bug / enhancement / refactor / tech-debt / docs
2. **选择对应模板**：从 `templates/` 目录读取相应模板
3. **填写核心字段**：仅填写必需字段，可选字段留空
4. **写入本地或远端**：
   * 本地草稿：写入 `.scratch/issues/<type>-<slug>.md`
   * GitHub Issue：使用 `gh issue create --template <type>` 直接创建
   * 项目看板：若使用其他工具（Jira/Linear），按工具格式写入

## 模板类型与字段

### Bug（缺陷）
```markdown
## [Bug] <简短标题>

**位置**：`path/to/file.ts:123` 或 `功能模块名`
**触发条件**：简要描述触发场景（不超过 3 行）
**预期**：应该发生什么
**实际**：发生了什么
**频率**：Always / Intermittent / Once

[可选] **临时绕过**：如有 workaround 简述
[可选] **相关**：#123（关联的 issue/PR）
```

### Enhancement（功能增强）
```markdown
## [Enhancement] <简短标题>

**动机**：为什么需要（用户价值或技术收益，1-2 句）
**目标**：要实现什么（描述结果，非实现细节）
**验收**：怎样算完成（2-3 条可验证的标准）

[可选] **参考**：相关文档/API/竞品链接
```

### Refactor（重构）
```markdown
## [Refactor] <简短标题>

**位置**：`path/to/module` 或模块名
**当前问题**：代码异味或结构问题（具体指出）
**改进目标**：重构后达到什么状态
**影响范围**：哪些模块会受影响

[可选] **优先级理由**：为什么值得优先处理
```

### Tech Debt（技术债）
```markdown
## [Tech Debt] <简短标题>

**债务类型**：重复代码 / 过时依赖 / 缺失测试 / 硬编码配置 / ...
**位置**：具体位置或模块
**影响**：对开发效率或维护性的影响
**建议方案**：简述理想状态（1-2 句）

[可选] **累积时间**：何时引入的
```

### Docs（文档）
```markdown
## [Docs] <简短标题>

**缺失内容**：需要补充什么文档
**目标读者**：新人 / 维护者 / API 用户
**位置**：应该写在哪里

[可选] **背景**：为什么需要这个文档
```

## 命名与组织规范

### 本地草稿命名
```
.scratch/issues/
  ├── bug-user-auth-race-condition.md
  ├── enhance-add-batch-export.md
  ├── refactor-extract-validation-logic.md
  ├── debt-remove-deprecated-api-v1.md
  └── docs-api-error-codes.md
```

* **格式**：`<type>-<kebab-case-slug>.md`
* **slug 原则**：简短、描述性、唯一（3-5 个词）
* **避免**：日期前缀、序号、无意义的 `fix-bug-1`

### GitHub Issue 标签
```
类型标签（必选一个）：
  bug, enhancement, refactor, tech-debt, docs

优先级标签（按需添加）：
  P0-critical    - 阻塞主线，立即处理
  P1-high        - 重要但不阻塞，本周期内
  P2-medium      - 下个周期
  P3-low         - 有空处理

范围标签（按需添加）：
  frontend, backend, api, infra, test, perf
```

## 独立性检查清单

记录前自问：
- [ ] 这个问题可以独立修复吗？（不依赖其他未完成工作）
- [ ] 这个问题只包含一个核心修改点吗？（非复合问题）
- [ ] 记录的信息足够未来独立理解吗？（无隐式依赖对话上下文）
- [ ] 这个问题不与当前 commit 混淆吗？（非当前任务的一部分）

若任一答案为"否"，重新拆分或补充信息。

## Agent 执行指令

当用户说"记录这个问题"、"to-issue"、"file an issue"时：

1. **识别问题类型**：通过对话上下文或询问确定类型（bug/enhancement/refactor/debt/docs）
2. **提取核心信息**：
   * 从对话中提取：位置、触发条件、预期/实际行为
   * 缺失信息：询问用户（仅必需字段）
3. **生成 issue 内容**：
   * 读取 `templates/<type>.md`
   * 填充模板，保持简洁（删除未填充的可选字段）
4. **确认写入方式**：
   * 默认：写入 `.scratch/issues/<type>-<slug>.md`
   * 若用户明确要求或项目已配置 GitHub/GitLab：使用 CLI 工具直接创建远端 issue
5. **确认并写入**：
   * 向用户展示生成的 issue 内容
   * 确认后写入，返回文件路径或 issue URL
   * 输出一句话总结：`已记录 [Bug] 用户认证竞态条件 → .scratch/issues/bug-user-auth-race-condition.md`

## 批量处理

当累积多个本地 issue 时，用户可以说"review issues"或"sync issues"：

1. **列出所有本地 issue**：`ls .scratch/issues/`
2. **按类型和优先级分组展示**
3. **询问处理方式**：
   * 逐个 review 并决定：处理 / 推送到远端 / 删除（已解决或无效）
   * 批量推送到 GitHub/GitLab
   * 生成本周工作清单

## 反模式（应避免）

* ❌ **复合问题**："修复登录 bug 并优化性能" → 拆分为两个 issue
* ❌ **过于宽泛**："重构用户模块" → 具体到哪个结构问题
* ❌ **缺乏上下文**："这里有个 bug" → 必须包含位置和复现条件
* ❌ **实现细节**："使用 Redis 缓存替换内存缓存" → 聚焦目标而非方案
* ❌ **重复记录**：记录前搜索 `.scratch/issues/` 和远端，避免重复

## 集成建议

### 与主工作流集成
* **在 `skeleton` 阶段发现边界问题**：立即 to-issue，继续当前签名设计
* **在 `work` 阶段遇到依赖阻塞**：to-issue 记录依赖问题，在当前实现中添加 TODO 占位
* **在 `refine` 审查时发现技术债**：to-issue 记录债务，不在当前 PR 中处理

### 与版本控制集成
* 本地 `.scratch/issues/` 加入 `.gitignore`（个人草稿）
* 或纳入版本控制（团队共享的待办池）
* 使用 `gh issue` CLI 同步到 GitHub 时自动应用标签和 milestone

### 定期清理
* 每周 review 一次 `.scratch/issues/`
* 已解决的删除或归档到 `.scratch/archive/issues-<YYYY-MM>.md`
* 过期的（3 个月未触碰）重新评估优先级或关闭
