import { useState } from 'react'
import {
  DEFAULT_API_ORIGIN,
  normalizeApiOrigin,
  setApiOrigin,
  useSettings,
} from '../../services/settings.js'
import { useTranslate } from '../../i18n/index.js'
import { showToast } from '../base/toastState.js'
import styles from './Settings.module.css'

/** API 地址：默认官方接口，可改成兼容的中转地址；回车、失焦或点确定保存 */
export const ApiOriginField = () => {
  const t = useTranslate()
  const saved = useSettings((state) => state.apiOrigin)
  const [value, setValue] = useState(saved)
  const [error, setError] = useState(false)
  const dirty = value.trim().replace(/\/+$/, '') !== saved

  const save = () => {
    if (!dirty) {
      setError(false)
      return
    }
    const next = normalizeApiOrigin(value)
    if (!next) {
      setError(true)
      return
    }
    setError(false)
    setValue(next)
    setApiOrigin(next)
    showToast({ key: 'apiOriginSaved' })
  }

  const reset = () => {
    setError(false)
    setValue(DEFAULT_API_ORIGIN)
    setApiOrigin(DEFAULT_API_ORIGIN)
  }

  return (
    <div className={styles.cell}>
      <div className={styles.apiKey}>
        <div className={styles.label}>{t('apiOriginLabel')}</div>
        <div className={styles.apiKeyInput}>
          <input
            type="url"
            placeholder={DEFAULT_API_ORIGIN}
            autoComplete="off"
            spellCheck={false}
            value={value}
            onChange={(event) => setValue(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === 'Enter' && !event.nativeEvent.isComposing) {
                save()
              }
            }}
            onBlur={save}
          />
          {dirty || saved !== DEFAULT_API_ORIGIN ? (
            <>
              <span className={styles.divider} />
              <button
                type="button"
                className={styles.confirm}
                onMouseDown={(event) => event.preventDefault()}
                onClick={dirty ? save : reset}
              >
                {dirty ? t('confirm') : t('apiOriginReset')}
              </button>
            </>
          ) : null}
        </div>
        {error ? (
          <div className={styles.error}>{t('apiOriginInvalid')}</div>
        ) : (
          <div className={styles.description}>{t('apiOriginDescription')}</div>
        )}
      </div>
    </div>
  )
}
