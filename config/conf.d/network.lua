-- =============================================================================
-- conf.d/network.lua — proxy, SSL, cookies
-- =============================================================================

return {
  Settings = {
    saveCookies             = 0,  -- 0=session only  1=persistent  2=never
  },

  networkProxy = {
    -- proxy type: matches QNetworkProxy::ProxyType enum
    --   0 = DefaultProxy (system)
    --   1 = Socks5Proxy
    --   3 = HttpProxy
    --   4 = HttpCachingProxy
    --   5 = FtpCachingProxy
    type      = 0,
    hostName  = "",
    port      = 0,
    user      = "",
    password  = "",   -- stored plaintext — leave empty and set via UI
  },

  -- SSL certificate authority paths (colon-separated on Linux)
  ["SSL-Configuration"] = {
    CACertPaths           = {},     -- list of extra CA cert dirs/files
    IgnoreAllSSLWarnings  = false,  -- DANGER: disables cert verification
  },
}
