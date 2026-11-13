---
name: skeleton
description: 从全局视角进行架构设计，规划类型结构与接口签名，为实现阶段提供清晰的技术方案。
disable-model-invocation: true
---

# 静态类型与接口签名定义（Skeleton）

从架构与类型系统的全局视角，规划**数据结构与接口签名**，为下游实现阶段提供清晰的技术方案。

**核心定位**：skeleton 是架构设计阶段，**不写任何文件**——产物是**返回给主控的设计摘要**，由主控原样转发给 `work`；结束时 `git status --porcelain` 必须为空。目标是从全局视角给出正确的设计方向，避免下游 agent 盲目写大量补丁代码或产生结构退化。

**适用场景**：
- **新功能开发**：从零设计模块结构、数据模型、接口边界
- **现有代码修改**：定位上游修改点、规划类型演化、重构接口签名
- **缺陷修复**：分析根因、确定最小修改范围、避免下游打补丁

## 第一步：架构分析与设计决策

根据场景选择对应的分析路径：

### 场景 A：新功能开发（Green Field）

从业务需求出发，自顶向下设计：
* **领域建模（Domain Modeling）**：识别核心领域概念、实体、值对象，对齐 `GLOSSARY.md` 中的 canonical terms。
* **模块边界划分（Module Boundaries）**：确定功能归属哪个模块、与现有模块的交互界面（Seams）在哪里。
* **数据流向分析（Data Flow）**：明确数据从哪里来（入口/Boundary）、经过哪些转换、最终去哪里（存储/输出）。
* **接口抽象层次（Abstraction Level）**：确定公共接口（Public API）、模块内接口（Internal Seams）、实现细节（Private）的边界。
* **完成判据**：已明确模块归属、核心数据结构、关键接口的抽象层次。

### 场景 B：现有代码修改（Brown Field）

向上游回溯，定位最小修改点：
* **区分生产端与消费端**：问题或需求源于数据产生的入口（Boundary / Parser / Constructor），还是下游消费处？优先在数据入口做归一化或类型收紧，避免在多个下游消费点重复添加防御性 `if/else` 分支。
* **核对调用方不变量（Caller Invariants）**：检查所有真实调用点已经保证的前置条件与不变量。凡是上游契约已保证不会发生的状态，严禁在签名或数据结构中为其预留防御性分支。
* **第一性原理审视（First-Principles Design）**：假设项目今天刚创建、原本就包含此需求，最直接的数据结构与接口应当如何定义？若现有结构阻碍了简洁表达，直接重构该数据结构，而非在旧结构外层叠加适配代码。
* **对齐领域词汇**：若仓库存在 `GLOSSARY.md` 或相关 `docs/adr/`，类型名、字段名与函数名必须严格使用其中的 canonical terms。
* **完成判据**：已用一两句话明确说明"选定哪个上游位置作为修改点，以及为什么它比在下游修改产生更少的代码"。

## 第二步：规划类型与签名（Type & Signature Plan）

**输出形式**：返回给主控的结构化设计摘要（含关键签名定义），**不写文件、不要求代码能编译**。

### 1. 设计声明（Design Declaration）

**新功能场景**：
- **功能定位**：这个功能在系统中的角色（数据处理层/业务逻辑层/API 层等）
- **模块归属**：归属哪个现有模块，或需要新建哪个模块
- **依赖关系**：依赖哪些现有模块、暴露哪些接口给其他模块

**修改场景**：
- **修改位置**：哪个函数/类型/模块作为根因修改点
- **修改依据**：为什么选这里而不是下游（基于调用方不变量、数据流分析）
- **影响半径**：这个修改会波及哪些调用点、数据结构、模块边界

**示例（新功能）**：
> 新增用户认证模块 `auth`，负责处理登录/登出/会话管理。位于业务逻辑层，依赖 `database` 模块进行用户查询，向 `api` 模块暴露 `AuthService` 接口。

**示例（修改）**：
> 将 `runtime_generation::assets::prepare_owner_ipc_directory` 的参数从 `&AuthenticatedOwner` 收窄为 `&OwnerIdentity` 并提升为 `pub(crate)` 导出。修改依据：函数内部仅访问 `owner.identity`，并不依赖已认证会话的其余字段。

### 2. 数据结构设计（Data Structure Design）

对于涉及的数据结构与类型定义：
- **新增类型**：完整定义（struct/enum/type/interface），说明每个字段的职责与约束
- **修改现有类型**：展示 before/after 对比，说明字段新增/删除/重命名的理由
- **类型关系**：说明类型间的依赖、组合、继承关系，利用类型系统使非法状态在编译期不可表示（Make illegal states unrepresentable）

**不需要**：内部实现方法、辅助函数、私有字段的具体逻辑。

**示例（新功能）**：
```rust
// 核心数据结构
pub struct UserSession {
    pub user_id: UserId,           // 用户唯一标识
    pub token: SessionToken,        // 会话令牌
    pub expires_at: Timestamp,      // 过期时间
    pub permissions: Vec<Permission>, // 权限列表
}

pub enum AuthError {
    InvalidCredentials,
    SessionExpired,
    InsufficientPermissions,
}
```

**示例（修改）**：
```rust
// Before: 
pub struct Config {
    pub timeout: u64,  // 歧义：单位不明
}

// After:
pub struct Config {
    pub timeout_ms: u64,  // 明确单位为毫秒
}
```

### 3. 接口签名清单（Signature Manifest）

列出所有关键函数签名，每个函数包含：
- **函数路径**：完整模块路径
- **签名定义**：完整类型签名（参数、返回值、错误类型）
- **职责说明**：这个函数做什么、关键前置条件与后置条件
- **实现提示**（仅关键点）：
  - 若是**全新函数**：标注 `[新增函数，需完整实现]` + 关键实现步骤提示
  - 若是**签名变更的现有函数**：标注函数体内需要同步调整的关键点（如参数引用变化），但**不要求写出完整函数体**
  - 若是**仅逻辑变更、签名不变**：标注 `[签名不变，需重写逻辑]` + 变更要点

**示例（新功能）**：
```rust
// 函数路径：src/auth/service.rs::authenticate
// 签名：pub async fn authenticate(credentials: &Credentials) -> Result<UserSession, AuthError>
// 职责：验证用户凭证，成功则创建会话并返回
// 实现提示：
//   1. 从 database 查询用户
//   2. 验证密码哈希
//   3. 生成会话令牌
//   4. 写入会话存储
//   [新增函数，需完整实现]
```

**示例（修改）**：
```rust
// 函数路径：src/core/runtime_generation/assets.rs::prepare_owner_ipc_directory
// 签名变更：
// Before: async fn prepare_owner_ipc_directory(owner: &AuthenticatedOwner) -> Result<(), ServiceError>
// After:  pub(crate) async fn prepare_owner_ipc_directory(owner: &OwnerIdentity) -> Result<(), ServiceError>
// 职责：为指定 owner 准备 IPC 目录并设置权限
// 实现提示：将函数体内所有 `owner.identity` 引用改为直接使用 `owner` 参数
```

### 4. 模块交互与调用关系（Module Interaction）

**新功能场景**：
- **对外暴露接口**：哪些函数/类型作为公共 API
- **依赖现有模块**：调用哪些现有模块的接口
- **数据流转**：数据如何在模块间流动

**修改场景**：
- **受影响的调用点**：列出所有需要调整的调用位置 + 调整说明
- **接口兼容性**：是否影响公共 API、是否需要版本迁移

**示例（新功能）**：
```
auth 模块对外接口：
  - AuthService::authenticate()
  - AuthService::logout()
  
依赖关系：
  - auth → database (查询用户)
  - api → auth (处理认证请求)
  
数据流向：
  HTTP Request → api layer → auth.authenticate() → database.query_user() → UserSession
```

**示例（修改）**：
```rust
// 调用点：src/core/runtime_generation/assets.rs::prepare_runtime
// 调整说明：将 prepare_owner_ipc_directory(owner) 改为 prepare_owner_ipc_directory(&owner.identity)

// 调用点：src/core/desired.rs::restore_desired_state (新增调用)
// 调整说明：添加 prepare_owner_ipc_directory(&active_owner.identity).await?
```

## 返回给主控的交接摘要（不落盘）

向下游 work 阶段交付：
* **设计声明**：模块定位/修改点选择 + 依据
* **数据结构设计**：新增/修改的类型定义 + 设计理由
* **接口签名清单**：所有关键函数签名 + 职责说明 + 实现提示
* **模块交互关系**：对外接口/依赖关系/调用点影响分析
* **并行切分判定**：明确哪些变更属于**单一内聚模块**（单个 work Worker 执行），哪些属于**彼此无状态共享的正交模块**（可由多个并行 Worker 独立执行 work 流程）

## 完成判据

* ✅ 已明确设计方向（新功能的模块定位 或 修改的上游根因）
* ✅ 已设计核心数据结构（新增/修改的类型定义 + 设计理由）
* ✅ 已列出接口签名清单（函数签名 + 职责说明 + 实现提示）
* ✅ 已分析模块交互关系（对外接口/依赖/调用点影响）
* ✅ 已判定并行切分方案
* ✅ 仓库无任何改动：本阶段只返回设计摘要、不写文件，结束时 `git status --porcelain` 为空
* ❌ **不要求**：代码能编译通过、所有函数体实现完整、类型检查无错误

## 反模式警示

* ❌ **过度实现**：skeleton 阶段编写完整的函数体逻辑、业务实现细节
* ❌ **落盘签名**：为了让"签名先存在"而修改源码、写 stub 文件或 `todo!()` 占位。签名只存在于返回给主控的设计摘要，由 `work` 阶段落盘
* ❌ **局部修补**：在下游消费点添加类型适配层，而未回溯到数据生产端做根因修改（修改场景）
* ❌ **过度抽象**：添加未经需求要求的通用接口、配置项、扩展点
* ❌ **缺乏全局视角**：只关注单个函数修改，未考虑对模块边界、调用链的影响
