-- =============================================================================
-- conf.d/appearance.lua — fonts, colours, layout, style sheet
-- =============================================================================

return {
  Settings = {
    -- ---- application style --------------------------------------------------
    -- built-in themes: "greenStyle_" / "defaultStyle_" / "orangeStyle_"
    -- or path to a custom QSS file
    styleApplication        = "greenStyle_",

    -- ---- feeds panel fonts --------------------------------------------------
    feedsFontFamily         = "",   -- empty = inherit application font
    feedsFontSize           = 0,    -- 0 = inherit application font size

    -- ---- news list fonts ----------------------------------------------------
    newsFontFamily          = "",
    newsFontSize            = 0,

    -- ---- news title (headline) fonts ----------------------------------------
    newsTitleFontFamily     = "",
    newsTitleFontSize       = 0,    -- typically app font size + 2

    -- ---- news body fonts ----------------------------------------------------
    newsTextFontFamily      = "",
    newsTextFontSize        = 0,

    -- ---- notification fonts -------------------------------------------------
    notificationFontFamily  = "",
    notificationFontSize    = 0,

    -- ---- news view style sheet (injected into WebKit) -----------------------
    -- path to a .css file, or empty for the built-in default
    styleSheetNews          = "",

    -- ---- layout -------------------------------------------------------------
    -- browser pane position: 0=right 1=bottom 2=auto(wide=right, narrow=bottom)
    browserPosition         = 0,

    -- news item layout: 0=classic list  1=newspaper (full article inline)
    newsLayout              = 0,

    -- show description snippet under headline in news list
    showDescriptionNews     = true,

    -- alternating row colours in feeds/news lists
    alternatingColorsNews   = false,
    alternatingRowColors    = false,

    -- show indentation arrows in feeds tree
    indentationFeedsTree    = true,

    -- show/hide panels
    showMenuBar             = true,
    statusBarShow           = true,
    feedsToolbarShow2       = true,
    newsToolbarShow         = true,
    browserToolbarShow      = true,
    mainToolbarShow2        = true,
    mainToolbarLock         = false,
    categoriesPanelShow     = true,
    categoriesTreeExpanded  = true,
    showToggleFeedsTree     = true,
    showLastUpdated         = true,
    showUnreadCount         = true,
    showUndeleteCount       = false,

    -- date/time format (strftime-style)
    formatData              = "dd.MM.yy",
    formatTime              = "hh:mm",
    simplifiedDateTime      = false,

    -- default zoom level for article web view (percentage, 100 = normal)
    defaultZoomPages        = 100,

    -- use built-in media player for audio/video enclosures
    useMediaPlayer          = true,

    -- show feed icon in feeds tree (vs generic RSS icon)
    defaultIconFeeds        = false,
  },

  -- ---- colours --------------------------------------------------------------
  -- All values are CSS hex strings.  Edit freely.
  Color = {
    -- feeds panel
    feedWithNewNewsColor    = "#0066CC",
    feedDisabledUpdateColor = "#999999",
    countNewsUnreadColor    = "#0066CC",
    focusedFeedBGColor      = "#FFFFFF",
    focusedFeedTextColor    = "#000000",
    feedsListBackgroundColor = "#FFFFFF",
    feedsListTextColor      = "#000000",

    -- news list
    newNewsTextColor        = "#0066CC",
    unreadNewsTextColor     = "#000000",
    focusedNewsBGColor      = "#FFFFFF",
    focusedNewsTextColor    = "#000000",
    newsListBackgroundColor = "#FFFFFF",
    newsListTextColor       = "#000000",
    newsBackgroundColor     = "#FFFFFF",

    -- article view
    titleColor              = "#000000",
    linkColor               = "#0066CC",
    authorColor             = "#666666",
    dateColor               = "#999999",
    newsTextColor           = "#000000",
    newsTitleBackgroundColor = "#FFFFFF",

    -- notifier
    notifierBackgroundColor = "#FFFFFF",
    notifierTextColor       = "#000000",
  },
}
