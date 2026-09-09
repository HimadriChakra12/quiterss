-- =============================================================================
-- conf.d/feeds.lua — feed fetching, update intervals, reading behaviour
-- =============================================================================

return {
  Settings = {
    -- ---- auto-update --------------------------------------------------------
    autoUpdatefeeds         = false,  -- enable periodic background updates
    autoUpdatefeedsInterval = 0,      -- unit: see autoUpdatefeedsTime
    autoUpdatefeedsTime     = 30,     -- minutes between updates (when interval=0)
                                      -- if autoUpdatefeedsInterval=1 → hours

    -- ---- request tunables ---------------------------------------------------
    timeoutRequest          = 15,     -- seconds before a feed request times out
    numberRequest           = 10,     -- max simultaneous feed fetch connections
    numberRepeats           = 2,      -- retry count on failure

    -- ---- reading behaviour --------------------------------------------------
    -- when to mark an article read:
    --   0 = on click  1 = after markNewsReadTime seconds  2 = immediately
    markNewsReadOn          = 0,
    markNewsReadTime        = 5,      -- seconds, used when markNewsReadOn = 1

    markCurNewsRead         = true,   -- mark current item read when switching
    markPrevNewsRead        = false,  -- mark all previous items read on scroll
    markReadSwitchingFeed   = false,  -- mark all read when switching feeds
    markReadClosingTab      = false,  -- mark all read when closing tab
    markReadMinimize        = false,  -- mark all read when minimising window
    markIdenticalNewsRead   = true,   -- auto-mark exact duplicate articles read

    -- ---- old news avoidance -------------------------------------------------
    avoidOldNews            = false,  -- skip importing articles older than:
    avoidedOldNewsDate      = 7,      -- days

    -- ---- opening behaviour --------------------------------------------------
    -- what happens when you click a feed:
    --   0 = show articles  1 = open in new tab  2 = open website
    openingFeedAction       = 0,
    openNewsWebViewOn       = true,   -- show article body pane on selection
    hideFeedsOpenTab        = false,  -- hide feeds panel when opening a tab

    -- ---- misc ---------------------------------------------------------------
    autocollapseFolder      = false,  -- collapse other folders when expanding one
    changeBehaviorActionNUN = false,  -- change action on "mark all unread"
  },

  -- used by feeds tree header
  NewsHeader = {
    columns   = "",   -- serialised column order/widths (auto-managed)
    sortBy    = 7,    -- field index (7 = published date)
    sortOrder = 1,    -- 0=ascending  1=descending
  },
}
