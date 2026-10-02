# send-email — 用 himalaya 收发邮件

本机邮件 CLI 是 **himalaya v2**（pacman 安装），账号配置在
`~/.config/himalaya/config.toml`（已配好 QQ 邮箱 nazze@qq.com，权限 600，
含授权码，不要把配置内容贴进日志或仓库）。

## 发送步骤（verify-then-send）

1. **组稿（不发送）**：正文写临时文件，`compose` 输出 eml：

   ```sh
   himalaya message compose \
     -t <收件人> -s '<主题>' \
     --body-file body.txt \
     --attach <附件路径> \
     > message.eml
   ```

   `--attach` 可重复。中文文件名、中文主题会自动 RFC 2047 编码，无需处理。

2. **核验**：`head message.eml` 检查 From/To/Subject 与
   `Content-Disposition: attachment` 的 filename，并把收件人、主题、正文、
   附件清单发给用户过目。

3. **取得明确许可**：用户回复"发"/"发送"才执行下一步。组稿与核验不构成许可。

4. **发送并存档**：

   ```sh
   himalaya message send --save "Sent Messages" -- message.eml
   ```

   完成判据：输出 `Message successfully saved and sent`。

5. **验证存档**：`himalaya attachment list -m "Sent Messages" <ID>` 确认附件
   在已发送副本里完整（列表 SIZE 列不可信，以 attachment list 为准）。

## 查信（盯回信）

```sh
himalaya envelope list -s 2 -m INBOX    # 收件箱
himalaya envelope list -s 2 -m Junk     # 垃圾箱（陌生发件人常被误判，必须查）
himalaya message read -m INBOX <ID>      # 读正文
```

## 配置参考（v2 schema）

v2 在 `[accounts.<name>]` 段内用**点号键**，server 写成 URL（裸域名默认
imaps/smtps 隐式 TLS），SASL 只能选一种机制：

```toml
[accounts.qq]
default = true
email = "nazze@qq.com"
display-name = "王文哲"
imap.server = "imaps://imap.qq.com:993"
imap.id.auto = true                      # QQ/126/163 要求认证后立即发 ID
imap.sasl.plain.username = "nazze@qq.com"
imap.sasl.plain.password.raw = "<授权码>"
smtp.server = "smtps://smtp.qq.com:465"
smtp.sasl.plain.username = "nazze@qq.com"
smtp.sasl.plain.password.raw = "<授权码>"
```

要点与坑：

- **schema 权威来源**：`himalaya manual <dir>` 生成的 man 页 +
  github.com/pimalaya/himalaya 的 `config.sample.toml`。报错信息会列出
  期望字段，可按报错迭代校准。
- `himalaya account check` **只校验语法**，不通网络；真实连接用
  `himalaya envelope list -s 1 -m INBOX` 验证。
- 共享命令需要默认邮箱别名，否则报 `Mailbox is required`：在配置里加
  `mailbox.alias.inbox = "INBOX"`，或每次传 `-m <邮箱名>`。
- QQ 文件夹英文名：INBOX、Sent Messages、Drafts、Deleted Messages、Junk。
- 用户另有 alascup@qq.com 等账号在 aerc 配置里（`~/.config/aerc/accounts.conf`），
  如需多账号可照抄其授权码到 himalaya 配置并去掉 `default`。
