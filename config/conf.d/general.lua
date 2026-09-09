-- =============================================================================
-- conf.d/general.lua — startup, tray, language, database, update behaviour
-- =============================================================================

return {
  Settings = {
    -- ---- startup ------------------------------------------------------------
    showSplashScreen        = true,   -- show splash on launch
    reopenFeedStartup       = true,   -- reopen last active feed on startup
    autoUpdatefeedsStartUp  = false,  -- fetch all feeds immediately on launch

    -- ---- language -----------------------------------------------------------
    -- filename stem from the lang/ directory, e.g. "en", "de", "ru"
    -- empty string = follow system locale
    langFileName            = "",

    -- ---- tray ---------------------------------------------------------------
    showTrayIcon            = true,
    startingTray            = false,  -- start minimised to tray
    minimizingTray          = true,   -- minimise to tray instead of taskbar
    closingTray             = false,  -- close button sends to tray
    singleClickTray         = false,  -- single click restores (vs double click)
    behaviorIconTray        = 1,      -- 0=always, 1=new count, 2=unread count

    -- ---- tabs ---------------------------------------------------------------
    openNewTabNextToActive  = false,  -- new tab opens next to current (vs end)
    showCloseButtonTab      = true,   -- show × on each tab

    -- ---- database -----------------------------------------------------------
    storeDBMemory           = true,   -- keep DB in RAM (faster, writes on exit)
    saveDBMemFileInterval   = 30,     -- minutes between RAM→disk flushes
    synchronousDB           = "FULL", -- SQLite sync: FULL / NORMAL / OFF
    createLastFeed          = false,  -- remember last selected feed across sessions

    -- ---- toolbar / UI -------------------------------------------------------
    toolBarIconSize         = "toolBarIconNormal_",  -- toolBarIconSmall_ / toolBarIconNormal_ / toolBarIconLarge_
    toolBarStyle            = "toolBarStyleTuI_",    -- text+icon / icon / text
    feedsToolBarIconSize    = "toolBarIconSmall_",
    newsToolBarIconSize     = "toolBarIconSmall_",
    mainToolBar             = "",   -- serialised toolbar layout (auto-managed)
    feedsToolBar2           = "",
    newsToolBar             = "",

    -- ---- misc ---------------------------------------------------------------
    clearStatusNew          = true,   -- mark as read when switching away
    emptyWorking            = true,   -- clear working set on idle
    noDebugOutput           = true,   -- suppress debug console output

    -- ---- update checker -----------------------------------------------------
    updateCheckEnabled      = true,
    remindAboutVersion      = false,
    currentVersionApp       = "",

    -- ---- statistics (Google Analytics ping — set false to disable) ----------
    statisticsEnabled2      = false,

    -- ---- backup -------------------------------------------------------------
    backupDir               = "",     -- empty = default (~/.local/share/QuiteRSS/backup)
  },

  -- feed/news filter state (persisted across sessions)
  feedSettings = {
    filterName  = "filterFeedsAll_",
    currentId   = 0,
  },
  newsSettings = {
    filterName  = "filterNewsAll_",
  },
}
