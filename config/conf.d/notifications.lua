-- =============================================================================
-- conf.d/notifications.lua — desktop notifications / notifier popup
-- =============================================================================

return {
  Settings = {
    -- ---- show/hide ----------------------------------------------------------
    showNotifyOn            = true,   -- enable notifications at all
    screenNotify            = 0,      -- which screen to show on (0 = primary)
    fullscreenModeNotify    = false,  -- suppress when app is fullscreen
    showNotifyInactiveApp   = true,   -- show even when QuiteRSS is focused

    -- ---- position -----------------------------------------------------------
    -- corner: 0=top-right  1=top-left  2=bottom-right  3=bottom-left
    positionNotify          = 0,

    -- ---- content ------------------------------------------------------------
    countShowNewsNotify     = 10,     -- max articles shown per notification
    timeShowNewsNotify      = 10,     -- seconds before auto-dismiss (0 = sticky)
    widthTitleNewsNotify    = 300,    -- pixel width of the notifier popup

    showIconFeedNotify      = true,   -- show feed favicon in notifier
    showTitlesFeedsNotify   = true,   -- show feed name above articles
    closeNotify             = true,   -- show close button on notifier
    showButtonMarkReadNotify  = true, -- "mark read" button in notifier
    showButtonMarkAllNotify   = true, -- "mark all read" button
    showButtonExBrowserNotify = true, -- "open in browser" button
    showButtonDeleteNotify    = false,-- "delete" button

    -- ---- transparency -------------------------------------------------------
    -- 0 = fully opaque  100 = fully transparent
    transparencyNotify      = 0,

    -- ---- sound --------------------------------------------------------------
    soundNewNews            = false,  -- play a sound on new articles
    soundNotifyPath         = "",     -- path to .wav/.ogg, empty = built-in beep
  },
}
