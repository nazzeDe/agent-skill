---
name: handoff
description: 将当前上下文压缩为一份交接文档，以便其他Agent接手
argument-hint: "下一个会话将用于做什么"
disable-model-invocation: true
---

撰写一份总结当前对话的交接文档，使全新的智能体可以继续后续工作。使用 `engineering-workflow` 已选定的本地工件后端；如果尚未确定，读取 `../engineering-workflow/ARTIFACT-BACKENDS.md`。默认保存为 `.scratch/<effort>/handoff.md`，项目 provider 可以声明等价路径。交接文档只能保留在本地，不能进入 Git；下一个会话吸收交接内容或 effort 结束后按 backend 规则删除该文件。

文档必须有“Suggested Skills”模块，用于提示接手的智能体应当激活哪些工具或方法。

如果部分内容已在其他地方写过，必须通过路径或 URL 引用而不是重写一遍。

必须脱敏所有敏感信息

如果用户传递了参数，将其视作对下一次会话聚焦方向的描述，并据此定制交接文档。
