---
name: taste
description: 把代码改动沉淀成口味条目
disable-model-invocation: true
---

把一次代码优化改动沉淀为代码品味

## 捕获流程

1. **定位改动。** 如果用户没有显式的提供，则从最近上下文找出用户反复改到满意的那一处：`before` 是改动前的版本，`after` 是最终满意的版本。两段取真实代码，来自 diff、编辑记录或会话里的代码块。完成判据：两段代码就位，且来自同一处改动。

2. **按原因拆。** 一处改动含多个原因时，每个原因写一条 `why`，共用同一份实例。完成判据：删掉任意一条 `why`，其余条目仍然完整成立。

3. **定类型。** 目标代码有多种合理写法、你要其中一种 → 形状条目，带 `when` / `instead` 代码块。动作唯一（删、加、改名）、触发条件一句话说得清 → 原则条目，写成一行。完成判据：能用一句话说出这条要改的动作。

4. **起草并展示。** 按下方「格式」写出整块，交给用户看，等明确答复。完成判据：用户同意

5. **查重、裁决、落盘。** 读 （没有则创建）`docs/agents/taste.md`，找同一主题的既有条目。冲突时给出三选一：新取代旧 / 旧取代新 / 两条并存并各补适用条件；同时写出两条 `why` 的差异和推荐理由，由用户裁决。新条目追加到相关内容后面方便对比。

## 格式

形状条目，一个口味一块，按此顺序：
    ### 标题
    **when**
    ```lang
    <原样代码>
    ```
    **instead**
    ```lang
    <原样代码>
    ```
    **why:** ...

原则条目：

    ### 标题
    **why:** <第一句写触发条件，第二句写依据或边界>

实例用原样真实代码，只剪掉无关上下文，不改标识符。

`why` 写事实与成本：这段代码在做什么、改成什么、为什么值得改。短句，一句一件事。减法条目写出依据

写的时候避开：用否定衬托肯定的句子（「判据是 A，不是 B」），向读者解释的句子（「所以」「等于」「读的人要」）。生造的词增加理解成本。

## 例子

一次改动，两条原因，共用同一份实例。

    ### 手写步进实现具名集合操作

    **when**
    ```rust
    let mut crate_name = None;
    let mut crate_type = None;

    let mut i = 0;
    while i < args.len() {
        if args[i] == "--crate-name" && i + 1 < args.len() {
            crate_name = Some(args[i + 1].to_string());
            i += 2;
        } else if args[i] == "--crate-type" && i + 1 < args.len() {
            crate_type = Some(args[i + 1].to_string());
            i += 2;
        } else {
            i += 1;
        }
    }
    ```

    **instead**
    ```rust
    let crate_name = args
        .iter()
        .position(|a| *a == "--crate-name")
        .map(|i| args[i + 1]);
    let crate_type = args
        .iter()
        .position(|a| *a == "--crate-type")
        .map(|i| args[i + 1]);
    ```

    **why:** 这是在手动执行 find：定位，取下一个值。标准库已有这个操作。手写版把一次操作摊成三处协作，改动要三处一起看。`position().map()` 之后操作只在一处。

    **why:** `--crate-*` 只由 CI 脚本传入，必带值，`i + 1 < args.len()` 永不触发。删除没有价值的条件判断

第二条是减法，依据写成一句事实（调用点契约）。

## AGENTS.md 段落

没有则插入：

    ## review 规范

    审查代码前读 `docs/agents/taste.md`。
