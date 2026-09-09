-- =============================================================================
-- conf.d/adblock.lua — built-in ad blocker
-- =============================================================================

return {
  AdBlock = {
    enabled             = true,
    useLimitedEasyList  = true,   -- use the bundled EasyList subset
                                  -- (false = download full EasyList)

    -- manually disabled rule strings (managed by the AdBlock UI)
    disabledRules       = {},

    -- ISO 8601 timestamp of last EasyList update (auto-managed)
    lastUpdate          = "",
  },
}
