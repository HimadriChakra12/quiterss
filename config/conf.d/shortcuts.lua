-- =============================================================================
-- conf.d/shortcuts.lua — keyboard shortcuts
--
-- Keys are action names from mainwindow.cpp.
-- Values are Qt key sequence strings: "Ctrl+R", "F5", "Ctrl+Shift+A" etc.
-- Empty string = disabled.  Leave a key out entirely to use the built-in default.
-- =============================================================================

return {
  Shortcuts = {
    -- ---- feeds --------------------------------------------------------------
    ["feed/Add"]                    = "Ctrl++",
    ["feed/AddFolder"]              = "",
    ["feed/Delete"]                 = "Delete",
    ["feed/Properties"]             = "",
    ["feed/UpdateFeed"]             = "F5",
    ["feed/UpdateAllFeeds"]         = "Ctrl+F5",
    ["feed/MarkAllFeedsRead"]       = "",
    ["feed/MarkFeedRead"]           = "",
    ["feed/OpenHomePage"]           = "",
    ["feed/SortByName"]             = "",
    ["feed/Import"]                 = "",
    ["feed/Export"]                 = "",

    -- ---- news ---------------------------------------------------------------
    ["news/Open"]                   = "Return",
    ["news/OpenInBrowserTab"]       = "Ctrl+Return",
    ["news/OpenInExternalBrowser"]  = "Ctrl+Shift+Return",
    ["news/OpenNewsNewTab"]         = "",
    ["news/MarkRead"]               = "M",
    ["news/MarkAllRead"]            = "Ctrl+M",
    ["news/MarkStar"]               = "S",
    ["news/NextNews"]               = "J",
    ["news/PrevNews"]               = "K",
    ["news/NextUnreadNews"]         = "N",
    ["news/PrevUnreadNews"]         = "B",
    ["news/PrevFeed"]               = "P",
    ["news/NextFeed"]               = "Ctrl+Tab",
    ["news/PrevUnreadFeed"]         = "",
    ["news/NextUnreadFeed"]         = "",
    ["news/Delete"]                 = "Delete",
    ["news/DeleteAll"]              = "",
    ["news/Restore"]                = "",
    ["news/CopyLink"]               = "",
    ["news/Share"]                  = "",

    -- ---- browser ------------------------------------------------------------
    ["browser/ZoomIn"]              = "Ctrl++",
    ["browser/ZoomOut"]             = "Ctrl+-",
    ["browser/ZoomReset"]           = "Ctrl+0",
    ["browser/Back"]                = "Alt+Left",
    ["browser/Forward"]             = "Alt+Right",
    ["browser/Stop"]                = "Escape",
    ["browser/Reload"]              = "Ctrl+R",
    ["browser/CopyLinkToClipboard"] = "",
    ["browser/Find"]                = "Ctrl+F",

    -- ---- application --------------------------------------------------------
    ["app/ShowHideMainWindow"]      = "",
    ["app/FullScreen"]              = "F11",
    ["app/Minimize"]                = "",
    ["app/Settings"]                = "Ctrl+,",
    ["app/Exit"]                    = "Ctrl+Q",
    ["app/About"]                   = "",
  },
}
