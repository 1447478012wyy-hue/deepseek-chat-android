# DeepSeek Chat 安卓版

在手机上填自己的 DeepSeek API Key 就能聊天的 App。**非 DeepSeek 官方应用。**

- 下载 APK：[Releases](../../releases/latest)（Android 7.0 及以上）
- 使用教程：[B站 BV1AisN6nEwF](https://www.bilibili.com/video/BV1AisN6nEwF)
- 交流群：QQ 1136485264

## 基于什么开发

- **上游项目**：[deepseek-ai/chat-demo](https://github.com/deepseek-ai/chat-demo)，DeepSeek 官方开源的聊天示例，MIT 许可证（原版权声明保留在 [LICENSE](LICENSE)）。聊天界面、多会话、深度思考、智能搜索、附件、语音输入与朗读、Markdown 和公式渲染都来自上游。
- **网页部分**：React 18 + TypeScript，用 rspack 打包，浏览器直接连 API，没有后端。对话存在本机 IndexedDB，API Key 存在本机 localStorage。
- **安卓外壳**：[Capacitor 8](https://capacitorjs.com/)，把打包好的网页装进 Android WebView，最低支持 Android 7.0。

## 相对上游的改动

- 设置 → 数据管理 新增「API 地址」，默认 `https://api.deepseek.com`，可改成兼容 DeepSeek 接口的中转地址，保存后立即生效。
- 新增 Android 工程（`android/`）、录音权限、应用图标（源文件在 `resources/`，改完运行 `resources\make-icons.ps1` 重新生成）。
- 应用名改为 DeepSeek Chat；`pnpm build` 改成跨平台写法，Windows 下也能构建。

## 构建 APK

需要 Node.js 22.12+、pnpm、JDK 21，以及带 android-36 平台的 Android SDK。

```sh
pnpm install
pnpm android:apk
```

APK 输出在 `android/app/build/outputs/apk/debug/app-debug.apk`。只改了网页时，运行 `pnpm android:sync` 把 `dist/` 同步进安卓工程。

---

以下是上游项目的原始说明。

# chat-demo

English | [简体中文](README.zh-CN.md)

A static chat demo powered by the DeepSeek API. No application backend is required: the browser connects directly to the configured API service.

You can [try the app online](https://deepseek-ai.github.io/chat-demo/) or download the archive from [Releases](https://github.com/deepseek-ai/deepseek-chat-demo/releases), extract it, and double-click `index.html` to use it locally without installation or a build. Enter your API key in Settings before your first chat.

## Getting started

Install Node.js 22.12+ and pnpm, then run:

```sh
git clone https://github.com/deepseek-ai/chat-demo.git
cd chat-demo
pnpm install
pnpm dev
```

Open http://localhost:8090.

To build the static site:

```sh
pnpm build
```

The output is written to `dist/`. Deploy it to a static web server or open `dist/index.html` directly. Opening the file directly requires browser support for storage on `file://` pages and an API service that permits their cross-origin requests.

## Features

- Multiple conversations with automatic titles, renaming, and deletion; edit prompts, regenerate replies, and switch between message branches.
- Streaming replies, deep thinking, smart search, link reading, and source citations; stop generation or continue eligible replies.
- Upload, paste, or drag and drop attachments; use voice input and read replies aloud. A live audio spectrum appears in the first row of the input area while recording on mobile.
- Markdown, syntax highlighting, KaTeX math, and Mermaid diagrams.
- Simplified Chinese and English, light and dark themes, mobile layouts, location settings, and chat history import and export.

## Data and storage

Your API key and settings are stored in the browser's localStorage. Conversations and original attachments are stored in IndexedDB. Local data is isolated by browser profile and site origin. Sending messages, uploading attachments, and using speech features sends the relevant content to the configured API service.

History import and export in Settings use ZIP archives. After confirmation and successful validation, importing replaces all local conversations and attachments. Exports include conversations and locally available original images, but exclude API keys, settings, and original non-image attachments. See the [history import/export documentation (Chinese)](src/services/chat/history/README.md) for the archive format and preservation details.

Settings → Data → Delete all chats clears all local conversations, original attachments, and unsent drafts after confirmation. It stops ongoing replies and returns to a new chat. Your API key and settings are preserved; files already uploaded to the API service are not deleted.

## Development

| Command       | Description                  |
| ------------- | ---------------------------- |
| `pnpm dev`    | Start the development server |
| `pnpm build`  | Build into `dist/`           |
| `pnpm type`   | Run TypeScript type checks   |
| `pnpm lint`   | Lint with oxlint             |
| `pnpm format` | Format with oxfmt            |

[rspack.config.ts](rspack.config.ts) uses `https://api.deepseek.com` by default. Use `createConfig({ apiOrigin, devServer })` to customize the API origin and development server proxy.

Chat uses `deepseek-flash` by default through Anthropic-compatible Messages / Files APIs. Speech features use ASR / TTS endpoints. Requests include extensions for search, link reading, titles, and `latest_reminder`, so the configured service must support the corresponding capabilities. Supported attachment formats are determined by server-side validation.

```text
src/
  app/                 Application layout, themes, and global styles
  components/          Chat, settings, Markdown, and other UI components
  i18n/                English and Chinese translations
  services/
    api/               API requests, SSE, and protocol types
    chat/              Conversations, message branches, storage, and history import/export
    markdown/          Markdown parsing, syntax highlighting, and diagrams
    speech/            Audio recording and read-aloud playback
  utils/               Shared utilities
```

## License

[MIT](LICENSE). The build copies the license to `dist/LICENSE`; include it when distributing the app. Third-party dependencies are subject to their own licenses.
