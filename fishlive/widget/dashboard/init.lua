local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local naughty = require("naughty")

local config = require("config")
local drawBox = require("fishlive.widget.dashboard.drawBox")

local function dashboard()
    -- dashboard signals
    local sig_volume = require("fishlive.signal.volume")
    local sig_brightness = require("fishlive.signal.brightness")
    local sig_battery = require("fishlive.signal.battery")
    local sig_playerctl = require("fishlive.signal.playerctl")

    -- dashboard widgets
    local leftdock = require("fishlive.widget.dashboard.docks.left")
    local rightdock = require("fishlive.widget.dashboard.docks.right")
    local avatar = require("fishlive.widget.dashboard.avatar")
    local calendar = require("fishlive.widget.dashboard.calendar")
    local time = require("fishlive.widget.dashboard.time")
    local storage = require("fishlive.widget.dashboard.storage")
    local volume = require("fishlive.widget.dashboard.volume")
    local brightness = require("fishlive.widget.dashboard.brightness")
    local battery = require("fishlive.widget.dashboard.battery")
    local settings = require("fishlive.widget.dashboard.settings")
    local weather = require("fishlive.widget.dashboard.weather")
    local playerctl = require("fishlive.widget.dashboard.playerctl")

    local dashboard = wibox({
        visible = false,
        ontop = true,
        type = "dock",
        screen = screen.primary,
        x = 0,
        y = beautiful.bar_height,
        width = awful.screen.focused().geometry.width,
        height = awful.screen.focused().geometry.height - beautiful.bar_height,
        bg = beautiful.base01 .. "cf"
    })

    local exitKey = "Escape"
    local keygrabber
    local function getKeygrabber()
        return awful.keygrabber {
            keypressed_callback = function(_, mod, key)
                if key == exitKey then
                    awesome.emit_signal("dashboard::close")
                    return
                end
                -- don't do anything for non-alphanumeric characters or stuff like F1, Backspace, etc
                if key:match("%W") or string.len(key) > 1 and key ~= exitKey then
                    return
                end
                -- spawn launcher with input arguments
                awful.spawn(config.apps.launcher..key)
                awesome.emit_signal("dashboard::close")
            end,
        }
    end

    keygrabber = getKeygrabber()

    dashboard.signals_on = function()
        sig_volume:start()
        sig_brightness:start()
        sig_battery:start()
        sig_playerctl:start()
    end

    dashboard.signals_off = function()
        sig_volume:stop()
        sig_brightness:stop()
        sig_battery:stop()
        sig_playerctl:stop()
    end

    dashboard.close = function()
        calendar.reset()
        dashboard.visible = false
        keygrabber:stop()
        dashboard.signals_off()
    end

    dashboard.toggle = function()
        calendar.reset()
        dashboard.visible = not dashboard.visible
        keygrabber:stop()

        if dashboard.visible then
            keygrabber = getKeygrabber()
            keygrabber:start()
            dashboard.signals_on()
        else
            dashboard.signals_off()
        end
    end

    -- listen to signal emitted by other widgets
    awesome.connect_signal("dashboard::toggle", dashboard.toggle)
    awesome.connect_signal("dashboard::close", dashboard.close)

    -- switch off signals after start, just read once only!
    dashboard.signals_off()

    -- Main Template of Dashboard Component
    dashboard:setup {
        {
            leftdock,
            {
                nil, {
                    nil,
                    {
                        {
                            playerctl(dpi(184), dpi(270)),
                            settings(168, 32),
                            layout = wibox.layout.fixed.vertical
                        },
                        {
                            drawBox({
                                volume,
                                brightness,
                                battery,
                                spacing = dpi(16),
                                widget = wibox.layout.fixed.vertical
                            }, dpi(200), dpi(114)),
                            drawBox(storage(config.dashboard_monitor_storage), dpi(200), dpi(114)),
                            layout = wibox.layout.fixed.vertical
                        },
                        {
                            drawBox(time, dpi(260), dpi(48)),
                            drawBox(calendar, dpi(260), dpi(180)),
                            layout = wibox.layout.fixed.vertical
                        },
                        layout = wibox.layout.fixed.horizontal
                    },
                    expand = "none",
                    layout = wibox.layout.align.vertical
                },
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            rightdock,
            layout = wibox.layout.align.horizontal
        },
        {
            nil,
            nil,
            {
                {
                    weather,
                    right = dpi(32),
                    widget = wibox.container.margin
                },
                expand = "none",
                layout = wibox.layout.align.vertical
            },
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        {
            nil,
            nil,
            {
                nil,
                nil,
                drawBox(avatar, dpi(180), dpi(230)),
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            expand = "none",
            layout = wibox.layout.align.vertical
        },
        layout = wibox.layout.stack
    }

    return dashboard
end

return dashboard