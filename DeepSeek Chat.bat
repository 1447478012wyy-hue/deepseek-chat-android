@echo off
rem Double-click to open the chat in an Edge app window (no address bar).
rem Requires dist\ from "pnpm build".
set "HERE=%~dp0"
if not exist "%HERE%dist\index.html" (
  echo dist\index.html not found. Run "pnpm build" in this folder first.
  pause
  exit /b 1
)
set "PAGE=%HERE:\=/%dist/index.html"
start "" msedge --app="file:///%PAGE%"
