-- =============================================================================
-- conf.d/state.lua — window geometry and splitter positions
--
-- These are saved automatically by the application on exit.
-- You CAN edit them, but it's easier to just resize windows normally.
-- All byte arrays are base64-encoded Qt geometry blobs.
-- =============================================================================

return {
  -- main window
  GeometryState           = "",   -- base64: main window geometry
  ToolBarsState           = "",   -- base64: toolbar positions
  MainSplitterState       = "",   -- base64: feeds|news splitter
  FeedsWidgetSplitterState = "",  -- base64: feeds panel internal splitter

  -- panel visibility (true/false toggled from View menu)
  FeedsWidgetVisible      = true,
  WebWidgetVisible        = true,
  NewsCategoriesTreeVisible = true,

  -- per-tab news/article splitter (auto-managed)
  NewsTabSplitterState    = "",

  -- dialogs
  ["options/geometry"]          = "",
  ["addFeedWizard/geometry"]    = "",
  ["customizeToolbarDlg/geometry"] = "",
  ["newsFiltersDlg/geometry"]   = "",
  ["filterRulesDlg/geometry"]   = "",
  ["updateAppDlg/geometry"]     = "",
  ["CleanUpWizard/geometry"]    = "",

  -- database version (do not touch)
  VersionDB               = 1,
  ["Flags/updatingFeeds"] = false,
}
