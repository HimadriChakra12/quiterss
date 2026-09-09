-- =============================================================================
-- conf.d/cleanup.lua — automatic database cleanup / old article removal
-- =============================================================================

return {
  Settings = {
    -- ---- scheduled cleanup --------------------------------------------------
    cleanupOnShutdown       = true,   -- run cleanup when closing the app
    optimizeDB              = false,  -- VACUUM database after cleanup (slow)

    -- ---- what to delete -----------------------------------------------------
    fullCleanUp             = false,  -- ignore per-feed settings, apply globally
    readCleanUp             = false,  -- delete read articles
    readClearUp             = false,  -- (alias used in some paths)

    -- ---- age limits ---------------------------------------------------------
    dayClearUpOn            = true,   -- enable age-based cleanup
    maxDayClearUp           = 30,     -- delete articles older than N days

    -- ---- count limits -------------------------------------------------------
    newsClearUpOn           = true,   -- enable count-based cleanup
    maxNewsClearUp          = 200,    -- keep at most N articles per feed

    -- ---- exceptions — never delete these ------------------------------------
    neverUnreadClearUp      = true,   -- keep unread articles
    neverStarClearUp        = true,   -- keep starred articles
    neverLabelClearUp       = true,   -- keep labelled articles
    notDeleteStarred        = true,
    notDeleteLabeled        = true,
    cleanUpDeleted          = true,   -- also purge soft-deleted items
  },

  -- CleanUpWizard last-run state (auto-managed)
  CleanUpWizard = {
    feedsIdList = {},   -- list of feed IDs processed last time
  },
}
