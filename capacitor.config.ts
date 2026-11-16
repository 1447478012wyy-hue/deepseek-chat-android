import type { CapacitorConfig } from '@capacitor/cli'

/** Android 壳：直接加载 dist/ 里的静态页面，页面在 https://localhost 下运行，直连 API 地址 */
const config: CapacitorConfig = {
  appId: 'app.deepseekchat.client',
  appName: 'DeepSeek Chat',
  webDir: 'dist',
  android: {
    backgroundColor: '#ffffff',
  },
}

// eslint-disable-next-line import/no-default-export
export default config
