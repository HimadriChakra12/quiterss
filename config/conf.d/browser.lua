-- =============================================================================
-- conf.d/browser.lua — built-in WebKit browser settings
-- =============================================================================

return {
  Settings = {
    -- ---- fonts --------------------------------------------------------------
    -- empty = WebKit default (usually the system sans-serif)
    browserStandardFont     = "",
    browserFixedFont        = "",
    browserSerifFont        = "",
    browserSansSerifFont    = "",
    browserCursiveFont      = "",
    browserFantasyFont      = "",

    browserDefaultFontSize  = 16,
    browserFixedFontSize    = 13,
    browserMinFontSize      = 6,
    browserMinLogFontSize   = 6,

    -- ---- behaviour ----------------------------------------------------------
    javaScriptEnable        = true,   -- run JS in article view
    autoLoadImages          = true,   -- load images automatically
    pluginsEnable           = false,  -- NPAPI plugins (Flash etc.) — leave off

    -- ---- user agent ---------------------------------------------------------
    -- default mimics a neutral Chrome on Windows so feeds don't block scraping
    userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36",

    -- ---- user stylesheet ----------------------------------------------------
    -- path to a .css file injected into every article page, or empty
    userStyleBrowser        = "",

    -- ---- cache --------------------------------------------------------------
    useDiskCache            = true,
    dirDiskCache            = "",     -- empty = default (~/.cache/QuiteRSS)
    cleanDiskCache          = true,   -- wipe cache on startup
    maxDiskCache            = 50,     -- MiB
    maxPagesInCache         = 3,      -- WebKit page cache (back/forward)

    -- ---- link opening -------------------------------------------------------
    -- open links in the built-in browser pane (false = always external)
    externalBrowserOn       = false,
    -- command for external browser, e.g. "firefox %1" or "xdg-open %1"
    externalBrowser         = "",
    openLinkInBackground    = false,          -- open in bg tab (built-in)
    openLinkInBackgroundEmbedded = false,     -- open embedded, bg
    openingLinkTimeout      = 1000,           -- ms before link is considered loaded

    -- ---- download -----------------------------------------------------------
    askDownloadLocation     = true,
    downloadLocation        = "",     -- empty = ~/Downloads
    curDownloadLocation     = "",
  },

  -- ClickToFlash whitelist — domains where plugins always run
  ClickToFlash = {
    enabled   = true,
    whitelist = {},   -- e.g. { "youtube.com", "vimeo.com" }
  },
}
