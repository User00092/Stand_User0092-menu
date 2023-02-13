if User0092_menu_VERSION
then
    return
end

util.require_natives("1663599433")

local language = lang.get_current()
User0092_menu_VERSION = "1.0.0"
local bmb_checked_nativies = false
local STAND_RESOURCE_DIR <const> = filesystem.resources_dir()
local RESOUCES_DIR <const> = STAND_RESOURCE_DIR .. "user0092-menu/"
local TRANSLATIONS_DIR <const> = RESOUCES_DIR .. "translations/"
local SETTINGS_FILE <const> = RESOUCES_DIR .. "req/settings.txt"
local prefix <const> = "[User0092 Menu] "

local main_musiness_banager_path = "Stand>Lua Scripts>MusinessBanager"

local notify = function (text, flag) assert(text ~= nil, "Cannot send a blank message") if flag ~= nil then util.toast(prefix .. tostring(text), flag) else util.toast(prefix .. tostring(text)) end end

local log = function (text) util.log(prefix .. tostring(text)) end

local MENU_LABELS = {
    THOUSHAD = "thousand",
    MILLION = "million",
    BILLION = "billion",
    TRILLION = "trillion",

    DEBUG = "Debug",

    ROOT_VEHICLES = "Vehicles",
    ROOT_CREDITS = "Credits",
    ROOT_SELF = "Local (you)",
    ROOT_BETTER_MUSINESS_BANAGER = "Better Musiness Banager",
    ROOT_SETTINGS = "Settings",

    WAIT_FOR_MUSINESS_BANAGER_LOAD = "Waiting for MusinessBanager to load",
    MUSINESS_BANAGER_LOADED = "Loaded MusinessBanager!",
    INSTALL_MUSINESS_BANAGER = "Install MusinessBanager before using this.",

    NOT_ONLINE_ERROR = "Please join an online session to use this feature.",
    INFINITE = "Infinite",

    RECLAIM_VEHICLES_NAME = "Reclaim Vehicles",
    RECLAIM_VEHICLES_DESC = "Reclaims all of your vehicles.",
    RECLAIM_VEHICLES_COMMAND = "reclaimAllVehicles",
    RECLAIM_VEHICLES_CRED_NAME = "Reclaim Vehicles - Corxl#5755",
    RECLAIM_VEHICLES_CRED_DESC = "Thanks to Corxl#5755 for a part of this script.",

    BETTER_MUSINESS_BANAGER_DIVIDER_1 = "Values",
    BETTER_MUSINESS_BANAGER_DIVIDER_2 = "Toggles",
    BETTER_MUSINESS_BANAGER_DIVIDER_3 = "Main",
    BETTER_MUSINESS_BANAGER_AMOUNT_NAME = "Amount:",
    BETTER_MUSINESS_BANAGER_AMOUNT_COMMAND = "setBMBamount",
    BETTER_MUSINESS_BANAGER_DESC = "1. Sets the amount to earn per run.\n2. Set this to 0 for no limit.\n3. Default value is 1 billion.",
    BETTER_MUSINESS_BANAGER_TOTAL_AMOUNT_MAKE = "Going to earn:",
    BETTER_MUSINESS_BANAGER_RUNS_NAME = "Runs:",
    BETTER_MUSINESS_BANAGER_RUNS_DESC = "1. Runs the loop x times.\n2. Set this to zero for no limit.\n3. Default is 1 run.",
    BETTER_MUSINESS_BANAGER_RUNS_COMMAND = "setBMBruns",
    BETTER_MUSINESS_BANAGER_REFILL_PERCENT_NAME = "Auto-refill warehouse percent:",
    BETTER_MUSINESS_BANAGER_REFILL_PERCENT_COMMAND = "autorefillpercent",
    BETTER_MUSINESS_BANAGER_REFILL_PERCENT_DESC = "1. Refills the warehouse at x percent.\n2. Set this to 100 to keep the warehouse full.\n3. Default value is 20%",
    BETTER_MUSINESS_BANAGER_DELAY_MS_NAME = "Delay (ms)",
    BETTER_MUSINESS_BANAGER_DELAY_MS_COMMAND = "setBMBselldelay",
    BETTER_MUSINESS_BANAGER_DELAY_MS_DESC = "1. Adds delay to each sell\n2. There is an added 3 second (3000 ms) delay to allow proper rendering of the sell.\n\n3. Setting this too low can freeze your game.\n\n 4. This has no \"good\" value, it depends on your session and network connection.\n5. Seconds to milliseconds = seconds * 1000.",
    BETTER_MUSINESS_BANAGER_PERFORMANCE_MODE_NAME = "Enable performance mode",
    BETTER_MUSINESS_BANAGER_PERFORMANCE_MODE_COMMAND = "enablebmbperformancemode",
    BETTER_MUSINESS_BANAGER_PERFORMANCE_MODE_DESC = "1. This disables most rendering, therefore, in theory, increases the performance of your game.\n2. I recommend keeping this enabled.",
    BETTER_MUSINESS_BANAGER_ENABLE_NAME = "Enable",
    BETTER_MUSINESS_BANAGER_ENABLE_COMMAND = "enablebmb",
    BETTER_MUSINESS_BANAGER_ENABLE_DESC = "1. Turns on Better Musiness Banager.\n2. Check that your settings are accurate.\n3. Some settings may require you to restart this loop.",
    BETTER_MUSINESS_BANAGER_FINISED_LOOP = "Finished loop. Made",
    BETTER_MUSINESS_BANAGER_ESTIMATED_TIME_NAME = "Estimated time",
    BETTER_MUSINESS_BANAGER_MONEY_EARNED = "Money earned this loop",
    BETTER_MUSINESS_BANAGER_TIME_IN_LOOP = "Time in loop",
    BETTER_MUSINESS_BANAGER_CURRENT_MONEY = "Current money",
    BETTER_MUSINESS_BANAGER_MANUAL_UNSTUCK_NAME = "Unstuck",
    BETTER_MUSINESS_BANAGER_MANUAL_UNSTUCK_COMMAND = "bmbunstuck",
    BETTER_MUSINESS_BANAGER_MANUAL_UNSTUCK_DESC = "For when your game gets stuck",

    SETTINGS_SAVE_NAME = "Save Settings",
    SETTINGS_SAVE_COMMAND = "bmbsavesettings",
    SETTINGS_LOAD_NAME = "Load Settings",
    SETTINGS_LOAD_COMMAND = "bmbloadsettings"
}

local SETTINGS = {
    LANGUAGE = language,

    BMB_EARN_AMOUNT = 1000000000,
    BMB_RUNS = 1,
    BMB_REFILL_PERCENT = 20,
    BMB_SELL_DELAY_MS = 2000,
    BMB_PERFORMANCE_MODE = true
}

local function GetCharacterFromString(str, charpos)
    return str:sub(charpos, charpos)
    --return str[charpos] -- pluto only
end

local function GetKeyValueFromLine(line, size)
    local find = string.find(line, "=")
    if not find then return nil, nil end
    size = size or 2
    local key = string.sub(line, 0, find-size)
    local value = string.sub(line, find+size, -1)
    return key, value
end

local function translate_labels(path)
    local lvalue, rvalue
    for line in io.lines(path) do
        local first_char = GetCharacterFromString(line, 1)
        if first_char == "!" or first_char == "#" or first_char == "@" then

        else
            lvalue, rvalue = GetKeyValueFromLine(line, 1)
            if lvalue then
                if MENU_LABELS[lvalue] ~= nil then
                    MENU_LABELS[lvalue] = rvalue
                else
                    notify("An error occurred while reading the translation file. The translation file may be corrupt or out of date.")
                end
            end
        end
    end
end

local function file_has_menu_item (item, path)
    local lvalue, rvalue, find
    for line in io.lines(path) do
        local first_char = GetCharacterFromString(line, 1)
        if first_char == "!" or first_char == "#" or first_char == "@" then

        else
            lvalue, rvalue = GetKeyValueFromLine(line, 1)
            if not lvalue then else
                if lvalue == item then
                    return true
                end
            end
        end
    end
    return false
end

-- Translating labels

-- es, de
-- language = "es" -- For development only
local find = string.find(SETTINGS.LANGUAGE, "-")
if find then
    SETTINGS.LANGUAGE = string.sub(SETTINGS.LANGUAGE, 0, find-1)
end
if SETTINGS.LANGUAGE ~= "en" then
    local path = TRANSLATIONS_DIR .. SETTINGS.LANGUAGE .. ".txt"
    -- Varifying that every item is valid
    for item, value in MENU_LABELS do
        if not file_has_menu_item(item, path)
        then
            log("[ERROR] Failed to find " .. item .. " in the language " .. SETTINGS.LANGUAGE)
            notify("[ERROR] Failed to translate menu. Please contact the developer")
            util.stop_script()
        end
    end
    if filesystem.exists(path)
    then
        translate_labels(path)
    end
end

local require_online = function (alert)
    if (alert == nil) then alert = true end
    if ((not util.is_session_started()) or (util.is_session_transition_active()))
    then
        if (alert) then
            notify(MENU_LABELS.NOT_ONLINE_ERROR)
        end
        return false
    end
    return true
end

local reclaimVehicles = function ()
    if not require_online() then return end
    for k, v in menu.get_children(menu.ref_by_path("Vehicle>Personal Vehicles")) do
        for k1, v1 in v.command_names do
            if (v1 ~= "findpv")
            then
                menu.trigger_commands(v1.."request")
            end
        end
    end
end

local function convert_number_to_formatted_string(number, formatter)
    local formatter = formatter or ","
    local formatted = string.reverse(tostring(number))
    local result = ""
    for i=1, string.len(formatted) do
        result = result .. string.sub(formatted, i, i)
        if i % 3 == 0 and i ~= string.len(formatted) then
            result = result .. formatter
        end
    end
    return string.reverse(result)
end

local function convert_number_to_string_representation(number)
    local fraction
    if (number < 1000) then
        return tostring(number)
    elseif (number / 1000 < 1000) then -- thousand
        fraction = number % 1000
        if fraction == 0 then
            return string.format("%.0f", number / 1000) .. " " .. MENU_LABELS.THOUSHAD
        else
            return string.format("%.2f", number / 1000) .. " " .. MENU_LABELS.THOUSHAD
        end
    elseif (number / 1000000 < 1000) then -- million
        fraction = number % 1000000
        if fraction == 0 then
            return string.format("%.0f", number / 1000000) .. " " .. MENU_LABELS.MILLION
        else
            return string.format("%.2f", number / 1000000) .. " " .. MENU_LABELS.MILLION
        end
    elseif (number / 1000000000 < 1000) then -- billion
        fraction = number % 1000000000
        if fraction == 0 then
            return string.format("%.0f", number / 1000000000) .. " " .. MENU_LABELS.BILLION
        else
            return string.format("%.2f", number / 1000000000) .. " " .. MENU_LABELS.BILLION
        end
    else -- trillion
        fraction = number % 1000000000000
        if fraction == 0 then
            return string.format("%.0f", number / 1000000000000) .. " " .. MENU_LABELS.TRILLION
        else
            return string.format("%.2f", number / 1000000000000) .. " " .. MENU_LABELS.TRILLION
        end
    end
end

local function menu_path_exists(path)
    return menu.is_ref_valid(menu.ref_by_path(path))
end

local function load_depend(path)
    while true do
        if menu_path_exists(path) then
            break
        end
        util.yield(10)
    end
end

local function kill_appsecuroserv()
    util.spoof_script("appsecuroserv", SCRIPT.TERMINATE_THIS_THREAD)
    PLAYER.SET_PLAYER_CONTROL(players.user(), true, 0)
    PAD.ENABLE_ALL_CONTROL_ACTIONS(0)
    PAD.ENABLE_CONTROL_ACTION(2, 1, true)
    PAD.ENABLE_CONTROL_ACTION(2, 2, true)
    PAD.ENABLE_CONTROL_ACTION(2, 187, true)
    PAD.ENABLE_CONTROL_ACTION(2, 188, true)
    PAD.ENABLE_CONTROL_ACTION(2, 189, true)
    PAD.ENABLE_CONTROL_ACTION(2, 190, true)
    PAD.ENABLE_CONTROL_ACTION(2, 199, true)
    PAD.ENABLE_CONTROL_ACTION(2, 200, true)
    ENTITY.FREEZE_ENTITY_POSITION(players.user_ped(), false)
end

local function convert_seconds_to_time(seconds, decimal_places)
    decimal_places = decimal_places or 2
    if (seconds <= 0) then
        return {hours = 0, minutes = 0, seconds = 0}
    end
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remaining_seconds = string.format("%." .. tostring(decimal_places) .. "f", seconds % 60)
    return {hours = hours, minutes = minutes, seconds = remaining_seconds}
end

local function write_to_file(file_path, content)
    if (not file_path or not content) then
        return
    end
    local file = io.open(file_path, "w")
    file:write(content)
    io.close(file)
end

-- local function _load_settings(path)
--     local lvalue, rvalue
--     for line in io.lines(path) do
--         local first_char = GetCharacterFromString(line, 1)
--         if first_char == "!" or first_char == "#" or first_char == "@" then

--         else
--             lvalue, rvalue = GetKeyValueFromLine(line, 1)
--             if lvalue then
--                 if SETTINGS[lvalue] ~= nil then
--                     SETTINGS[lvalue] = rvalue
--                 else
--                     notify("An error occurred while reading the translation file. The translation file may be corrupt or out of date.")
--                 end
--             end
--         end
--     end
-- end

-- local load_settings = function ()
--     for item, value in SETTINGS do
--         if not file_has_menu_item(item, SETTINGS_FILE)
--         then
--             log("[ERROR] Failed to find " .. item .. " in settings file")
--             notify("[ERROR] Failed to get setting. Please contact the developer")
--             util.stop_script()
--         end
--         _load_settings()
--     end
-- end

-- load_settings()

local get_int_player_money = function ()
    if (not require_online(false)) then return 0 end
    local game_money = MONEY.NETWORK_GET_STRING_BANK_BALANCE():gsub('%$', '')
    return tonumber(game_money)
end

local get_formatted_player_money = function ()
    local game_money = get_int_player_money()
    return convert_number_to_string_representation(game_money)
end

-- Visuals --
local main_menu_root = menu.my_root()
local main_self_root = menu.list(main_menu_root, MENU_LABELS.ROOT_SELF)
local main_vehicle_root = menu.list(main_menu_root, MENU_LABELS.ROOT_VEHICLES)

local main_better_musiness_banager_root = menu.list(main_menu_root, MENU_LABELS.ROOT_BETTER_MUSINESS_BANAGER, {}, "", function ()
    -- Getting natives and packages
    -- Getting natives and packages
    if (bmb_checked_nativies ~= true) then
        util.ensure_package_is_installed("lua/MusinessBanager")
        util.ensure_package_is_installed("lua/ScaleformLib")
        -- Getting the warehouse form Scalefrom
        local warehouse_scaleform = require("lib.ScaleformLib")("IMPORT_EXPORT_WAREHOUSE")
        bmb_checked_nativies = true
    end
    local musiness_banager_dir = filesystem.scripts_dir() .. 'MusinessBanager.lua'
    if not filesystem.exists(musiness_banager_dir) then
        notify(MENU_LABELS.INSTALL_MUSINESS_BANAGER)
        return false
    end

    -- Checking if Musiness Banager is initialized
    if not menu_path_exists(main_musiness_banager_path .. ">Special Cargo") then
        menu.trigger_commands("luamusinessbanager")
        notify(MENU_LABELS.WAIT_FOR_MUSINESS_BANAGER_LOAD)
        load_depend(main_musiness_banager_path .. ">Special Cargo")
        notify(MENU_LABELS.MUSINESS_BANAGER_LOADED)
    end
end)

-- local main_better_musiness_banager_debug_root = menu.list(main_better_musiness_banager_root, MENU_LABELS.DEBUG)

local main_settings_root = menu.list(main_menu_root, MENU_LABELS.ROOT_SETTINGS)

local main_credit_root =  menu.list(main_menu_root, MENU_LABELS.ROOT_CREDITS)


-- VEHICLES --
menu.action(main_vehicle_root, MENU_LABELS.RECLAIM_VEHICLES_NAME, {MENU_LABELS.RECLAIM_VEHICLES_COMMAND}, MENU_LABELS.RECLAIM_VEHICLES_DESC,function()
    reclaimVehicles()
end)


-- Better Mussiness Banager --
local bmb_initial_money_earned = 0
local bmb_total_earned_this_session = 0
local appsecuroserv = util.joaat("appsecuroserv")
local bmb_time_started = 0

-- ["minimize_delivery_time"] = {ref=menu.ref_by_path(main_mb_path .. relative_paths.minimize_delivery_time),   state=true},
    
local bmb_apply_settings = {
    NO_PHONE = {ref=menu.ref_by_command_name("nophonespam"), state="on"},
    ANTI_AFK = {ref=menu.ref_by_path("Online>Enhancements>Disable Idle/AFK Kick", 38), state=true},
    NO_IDLE_CAM = {ref=menu.ref_by_path("Game>Disables>Disable Idle Camera", 38), state=true},
    MB_MONITOR_WAREHOUSE = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Monitor"), state=true},
    MB_MAX_SELL_PRICE = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Max Sell Price"), state=true},
    MB_NO_BUY_COOLDOWN = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Bypass Buy Mission Cooldown"), state=true},
    MB_NO_SELL_COOLDOWN = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Bypass Sell Mission Cooldown"), state=true},
    MB_AUTOCOMPLETE_BUY = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Autocomplete Buy Mission"), state=true},
    MB_AUTOCOMPLETE_SELL = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Autocomplete Sell Mission"), state=true},
    MB_MAX_CREATE_SOURCE_amount = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Max Crate Sourcing Amount"), state=true},
    MB_MINIMIZE_DELIVERY_TIME = {ref=menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Minimize Delivery Time"), state=true}
}

local get_warehouse_ref = menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Warehouse")

local function GetOnlineWorkOffset()
    return (1853910 + 1 + (players.user() * 862) + 267)
end

local function GetWarehouseOffset()
    return (GetOnlineWorkOffset() + 116) + 1
end

local function GetGlobalInt(address)
    return memory.read_int(memory.script_global(address))
end

local function GetWarehousePropertyFromSlot(slot)
    return GetGlobalInt(GetWarehouseOffset() + (slot * 3))
end

local WarehousePropertyInfo = {
    [1]  = {name = "Pacific Bait Storage",      capacity = 16,      coords = {x = 54.191,    y = -2569.248,  z = 6.0046 }}, -- "MP_WHOUSE_0",
    [2]  = {name = "White Widow Garage",        capacity = 16,      coords = {x = -1083.054, y = -1261.893,  z = 5.534  }}, -- "MP_WHOUSE_1",
    [3]  = {name = "Celltowa Unit",             capacity = 16,      coords = {x = 896.3665,  y = -1035.749,  z = 35.1096}}, -- "MP_WHOUSE_2",
    [4]  = {name = "Convenience Store Lockup",  capacity = 16,      coords = {x = 247.473,   y = -1956.943,  z = 23.1908}}, -- "MP_WHOUSE_3",
    [5]  = {name = "Foreclosed Garage",         capacity = 16,      coords = {x = -424.828,  y = 185.825,    z = 80.775 }}, -- "MP_WHOUSE_4",
    [6]  = {name = "Xero Gas Factory",          capacity = 111,     coords = {x = -1042.482, y = -2023.516,  z = 13.1616}}, -- "MP_WHOUSE_5",
    [7]  = {name = "Derriere Lingerie Backlot", capacity = 42,      coords = {x = -1268.119, y = -812.2741,  z = 17.1075}}, -- "MP_WHOUSE_6",
    [8]  = {name = "Bilgeco Warehouse",         capacity = 111,     coords = {x = -873.65,   y = -2735.948,  z = 13.9438}}, -- "MP_WHOUSE_7",
    [9]  = {name = "Pier 400 Utility Building", capacity = 16,      coords = {x = 274.5224,  y = -3015.413,  z = 5.6993 }}, -- "MP_WHOUSE_8",
    [10] = {name = "GEE Warehouse",             capacity = 42,      coords = {x = 1569.69,   y = -2129.792,  z = 78.3351}}, -- "MP_WHOUSE_9",
    [11] = {name = "LS Marine Building 3",      capacity = 42,      coords = {x = -315.551,  y = -2698.654,  z = 7.5495 }}, -- "MP_WHOUSE_10",
    [12] = {name = "Railyard Warehouse",        capacity = 42,      coords = {x = 499.81,    y = -651.982,   z = 24.909 }}, -- "MP_WHOUSE_11",
    [13] = {name = "Fridgit Annexe",            capacity = 42,      coords = {x = -528.5296, y = -1784.573,  z = 21.5853}}, -- "MP_WHOUSE_12",
    [14] = {name = "Disused Factory Outlet",    capacity = 42,      coords = {x = -295.8596, y = -1353.238,  z = 31.3138}}, -- "MP_WHOUSE_13",
    [15] = {name = "Discount Retail Unit",      capacity = 42,      coords = {x = 349.839,   y = 328.889,    z = 104.272}}, -- "MP_WHOUSE_14",
    [16] = {name = "Logistics Depot",           capacity = 111,     coords = {x = 926.2818,  y = -1560.311,  z = 30.7404}}, -- "MP_WHOUSE_15",
    [17] = {name = "Darnell Bros Warehouse",    capacity = 111,     coords = {x = 759.566,   y = -909.466,   z = 25.244 }}, -- "MP_WHOUSE_16",
    [18] = {name = "Wholesale Furniture",       capacity = 111,     coords = {x = 1037.813,  y = -2173.062,  z = 31.5334}}, -- "MP_WHOUSE_17",
    [19] = {name = "Cypress Warehouses",        capacity = 111,     coords = {x = 1019.116,  y = -2511.69,   z = 28.302 }}, -- "MP_WHOUSE_18",
    [20] = {name = "West Vinewood Backlot",     capacity = 111,     coords = {x = -245.3405, y = 203.3286,   z = 83.818 }}, -- "MP_WHOUSE_19",
    [21] = {name = "Old Power Station",         capacity = 42,      coords = {x = 539.346,   y = -1945.682,  z = 24.984 }}, -- "MP_WHOUSE_20",
    [22] = {name = "Walker & Sons Warehouse",   capacity = 111,     coords = {x = 96.1538,   y = -2216.4,    z = 6.1712 }}, -- "MP_WHOUSE_21",
}

local MenuCurrentWarehouses = {
    [0] = {"Name", {}, ""},
    [1] = {"Name", {}, ""},
    [2] = {"Name", {}, ""},
    [3] = {"Name", {}, ""},
    [4] = {"Name", {}, ""},
}

local update_warehouses = function ()
    if not require_online(false) then return end
    for slot = 0, 4 do
        local property_id = GetWarehousePropertyFromSlot(slot)
        if property_id ~= 0 then
            local property_name = WarehousePropertyInfo[property_id].name
            MenuCurrentWarehouses[slot] = {property_name, {"warehouse"..property_name}, property_id}
        else
            MenuCurrentWarehouses[slot] = {"No Warehouse", {}, -1}
        end
    end
end
update_warehouses()

local function get_current_warehouse()
    update_warehouses()
    return menu.get_value(get_warehouse_ref)
end

local function get_current_warehouse_id()
    update_warehouses()
    return MenuCurrentWarehouses[get_current_warehouse()][3]
end

local get_current_warehouse_name = function ()
    if not require_online(false) then return end
    return MenuCurrentWarehouses[get_current_warehouse()][1]
end


local function get_current_warehouse_type()
    if not require_online(false) then return end
    local warehouse = get_current_warehouse_id()
    if warehouse == -1 then return -1 end
    if (warehouse == 1 or warehouse == 2 or warehouse == 3 or warehouse == 4 or warehouse == 5 or warehouse == 9) then
        return 0
    elseif (warehouse == 7 or warehouse == 10 or warehouse == 11 or warehouse == 12 or warehouse == 13 or warehouse == 14 or warehouse == 15 or warehouse == 21) then
        return 1
    elseif (warehouse == 6 or warehouse == 8 or warehouse == 16 or warehouse == 17 or warehouse == 18 or warehouse == 19 or warehouse == 20 or warehouse == 22) then
        return 2
    else
        return 3
    end
end

local function get_current_warehouse_capacity()
    if not require_online(false) then return end
    local warehouse_type = get_current_warehouse_type()
    if warehouse_type == -1 then return 0 end
    if (warehouse_type == 0) then
        return 16
    elseif (warehouse_type == 1) then
        return 42
    else
        return 111
    end
end

local cargo_amount_alloc = memory.alloc_int()
local function get_warehouse_cargo_amount()
    STATS.STAT_GET_INT(util.joaat("MP" .. util.get_char_slot() .. "_CONTOTALFORWHOUSE" .. get_current_warehouse()), cargo_amount_alloc, -1)
    return memory.read_int(cargo_amount_alloc)
end

local function enable_better_performance()
    menu.set_value(menu.ref_by_command_name("anticrashcam"), true) -- Stops rendering buildings, peds, etc.
    menu.set_value(menu.ref_by_command_name("nosky"), true) -- Stops rendering the sky
    menu.set_value(menu.ref_by_command_name("weather"), 0) -- Stops rendering weather
    menu.set_value(menu.ref_by_command_name("time"), 0) -- My poor eyes
end

local function disable_better_performance()
    menu.set_value(menu.ref_by_command_name("anticrashcam"), false)
    menu.set_value(menu.ref_by_command_name("nosky"), false)
end

menu.divider(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_DIVIDER_1)

menu.slider(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_AMOUNT_NAME, {MENU_LABELS.BETTER_MUSINESS_BANAGER_AMOUNT_COMMAND}, MENU_LABELS.BETTER_MUSINESS_BANAGER_DESC, 0, 2000000000, SETTINGS.BMB_EARN_AMOUNT, 6000000, function (x)
    SETTINGS.BMB_EARN_AMOUNT = x
end)

menu.slider(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_RUNS_NAME, {MENU_LABELS.BETTER_MUSINESS_BANAGER_RUNS_COMMAND}, MENU_LABELS.BETTER_MUSINESS_BANAGER_RUNS_DESC, 0, 1000, SETTINGS.BMB_RUNS, 1, function (x)
    SETTINGS.BMB_RUNS = x
end)


menu.slider(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_REFILL_PERCENT_NAME, {MENU_LABELS.BETTER_MUSINESS_BANAGER_REFILL_PERCENT_COMMAND}, MENU_LABELS.BETTER_MUSINESS_BANAGER_REFILL_PERCENT_DESC, 10, 100, SETTINGS.BMB_REFILL_PERCENT, 1, function(x)
    SETTINGS.BMB_REFILL_PERCENT = x
end)

menu.slider(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_DELAY_MS_NAME, {MENU_LABELS.BETTER_MUSINESS_BANAGER_DELAY_MS_COMMAND}, MENU_LABELS.BETTER_MUSINESS_BANAGER_DELAY_MS_DESC, 500, 10000, SETTINGS.BMB_SELL_DELAY_MS, 100, function (x)
    SETTINGS.BMB_SELL_DELAY_MS = x
end)

menu.divider(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_DIVIDER_2)

menu.toggle(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_PERFORMANCE_MODE_NAME, {MENU_LABELS.BETTER_MUSINESS_BANAGER_PERFORMANCE_MODE_COMMAND}, MENU_LABELS.BETTER_MUSINESS_BANAGER_PERFORMANCE_MODE_DESC, function(x)
    SETTINGS.BMB_PERFORMANCE_MODE = x
end, SETTINGS.BMB_PERFORMANCE_MODE)

menu.divider(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_DIVIDER_3)

local bmb_total_amount_make_readonly = menu.readonly(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_TOTAL_AMOUNT_MAKE, convert_number_to_string_representation(SETTINGS.BMB_RUNS * SETTINGS.BMB_EARN_AMOUNT))

local bmb_estimated_time_taken_readonly = menu.readonly(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_ESTIMATED_TIME_NAME, "0 hours 0 minutes 0 seconds")

local bmb_money_earned_readonly = menu.readonly(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_MONEY_EARNED, tostring(0))

local bmb_user_money_readonly = menu.readonly(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_CURRENT_MONEY, get_formatted_player_money())

local bmb_time_in_loop_readonly = menu.readonly(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_TIME_IN_LOOP, "0 hours 0 minutes 0 seconds")

local bmb_loop_enabled = false
menu.toggle(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_ENABLE_NAME, {MENU_LABELS.BETTER_MUSINESS_BANAGER_ENABLE_COMMAND}, MENU_LABELS.BETTER_MUSINESS_BANAGER_ENABLE_DESC, function (enabled)
    if (enabled) then
        bmb_loop_enabled = true
        -- Online check
        if not require_online() then
            menu.trigger_commands(MENU_LABELS.BETTER_MUSINESS_BANAGER_ENABLE_COMMAND .. " off")
            return
        end
        
        -- Toggling settings
        for _, i in pairs(bmb_apply_settings) do
            if menu.get_value(i.ref) ~= i.state then
                menu.set_value(i.ref, i.state)
            end
        end

        -- Loop specific variables
        local loop_bmb_performance_enabled
        
        -- Initial performance mode
        if (SETTINGS.BMB_PERFORMANCE_MODE) then
            enable_better_performance()
            loop_bmb_performance_enabled = true
        end
        
        bmb_initial_money_earned = get_int_player_money()
        bmb_time_started = os.time()

        -- main loop
        while (bmb_loop_enabled) do
            -- Extra check
            if (bmb_loop_enabled ~= true) then break end

            if (get_current_warehouse_name() == "No Warehouse" or get_current_warehouse_type() == -1) then
                break
            end

            -- Online check
            if not require_online() then
                menu.trigger_commands(MENU_LABELS.BETTER_MUSINESS_BANAGER_ENABLE_COMMAND .. " off")
                break
            end

            -- Remove wanted level
            util.set_local_player_wanted_level(0)

            -- Watch performance mode
            if (SETTINGS.BMB_PERFORMANCE_MODE ~= true and loop_bmb_performance_enabled) then
                disable_better_performance()
                loop_bmb_performance_enabled = false
            elseif (SETTINGS.BMB_PERFORMANCE_MODE and not loop_bmb_performance_enabled) then
                enable_better_performance()
                loop_bmb_performance_enabled = true
            end
            
            -- Get the warehouse capacity
            local bmb_current_cargo_percentage = (get_warehouse_cargo_amount() / get_current_warehouse_capacity() * 100)
            -- log("Warehouse cargo amount: " .. get_warehouse_cargo_amount() .. " | Warehouse capacity: " .. get_current_warehouse_capacity() .. " | Percent: " .. bmb_current_cargo_percentage)
            -- refill
            if (bmb_current_cargo_percentage < SETTINGS.BMB_REFILL_PERCENT or bmb_current_cargo_percentage < 10) then
                -- STATS.SET_PACKED_STAT_BOOL_CODE(32359 + get_current_warehouse(), true, -1)
                menu.trigger_command(menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Trigger Technician Source"))
            end
            
            -- Sell the create
            menu.trigger_command(menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Press To Sell A Crate"))

            util.yield(900) -- Allows the game to register sell. Prevents CPU from dying
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 238, 1.0)
            local end_time = os.time() + 2
            while SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(appsecuroserv) > 0 and os.time() < end_time do
                util.yield()
            end
            if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(appsecuroserv) > 0 and SETTINGS.BMB_SELL_DELAY_MS < 1000 then
                kill_appsecuroserv()
            end
            end_time = os.time() + 5
            while NETSHOPPING.NET_GAMESERVER_TRANSACTION_IN_PROGRESS() and os.time() < end_time do
                util.yield()
            end
            
            -- Getting the amount earned
            bmb_total_earned_this_session = get_int_player_money() - bmb_initial_money_earned

            -- Comparing amount earned to requested amount earned
            if (SETTINGS.BMB_EARN_AMOUNT == 0 or SETTINGS.BMB_RUNS == 0) then
            elseif (bmb_total_earned_this_session >= SETTINGS.BMB_EARN_AMOUNT * SETTINGS.BMB_RUNS) then
                break
            end

            -- Delay
            util.yield(SETTINGS.BMB_SELL_DELAY_MS) -- Also used to stop cpu from killing itself. (game go bye bye)
        end
        bmb_loop_enabled = false
        disable_better_performance()
        if (bmb_total_earned_this_session ~= 0) then
            local time_running_ = convert_seconds_to_time(os.time() - bmb_time_started)
            local time_running_formatted_ = tostring(time_running_.hours .. " Hours " .. time_running_.minutes .. " minutes " .. time_running_.seconds .. " seconds")
            notify(MENU_LABELS.BETTER_MUSINESS_BANAGER_FINISED_LOOP .. " " .. convert_number_to_string_representation(bmb_total_earned_this_session))
            log(MENU_LABELS.BETTER_MUSINESS_BANAGER_FINISED_LOOP .. " " .. convert_number_to_string_representation(bmb_total_earned_this_session) .. " (" .. time_running_formatted_ .. ")")
            menu.set_value(bmb_apply_settings.NO_PHONE.ref, "off")
        end
        menu.trigger_commands(MENU_LABELS.BETTER_MUSINESS_BANAGER_ENABLE_COMMAND .. " off")
        menu.trigger_command(menu.ref_by_command_name("removeloader"))
        bmb_time_started = 0
        menu.set_value(bmb_time_in_loop_readonly, "0 hours 0 minutes 0 seconds")
    end
    bmb_loop_enabled = false
    disable_better_performance()
    menu.trigger_commands(MENU_LABELS.BETTER_MUSINESS_BANAGER_ENABLE_COMMAND .. " off")
    menu.trigger_command(menu.ref_by_command_name("removeloader"))
    menu.set_value(bmb_time_in_loop_readonly, "0 hours 0 minutes 0 seconds")
    menu.set_value(bmb_apply_settings.NO_PHONE.ref, "off")
end, false)


menu.action(main_better_musiness_banager_root, MENU_LABELS.BETTER_MUSINESS_BANAGER_MANUAL_UNSTUCK_NAME, {MENU_LABELS.BETTER_MUSINESS_BANAGER_MANUAL_UNSTUCK_COMMAND}, MENU_LABELS.BETTER_MUSINESS_BANAGER_MANUAL_UNSTUCK_DESC, function ()
    kill_appsecuroserv()
end)


util.create_tick_handler(function()
    if (require_online(false)) then
        -- Better Musiness Banager --
        update_warehouses()
        -- bmb total amount make
        local bmb_total_amount_make_readonly_display = convert_number_to_string_representation(SETTINGS.BMB_RUNS * SETTINGS.BMB_EARN_AMOUNT)
        if (bmb_total_amount_make_readonly_display == "0") then  bmb_total_amount_make_readonly_display = MENU_LABELS.INFINITE end
        menu.set_value(bmb_total_amount_make_readonly, bmb_total_amount_make_readonly_display)
        -- bmb estimated time
        if (SETTINGS.BMB_EARN_AMOUNT == 0 or SETTINGS.BMB_RUNS == 0) then
            menu.set_value(bmb_estimated_time_taken_readonly, MENU_LABELS.INFINITE)
        else
            local estimated_time = convert_seconds_to_time((SETTINGS.BMB_EARN_AMOUNT * SETTINGS.BMB_RUNS / 6000000) * (SETTINGS.BMB_SELL_DELAY_MS / 1000 + 1))
            local estimated_time_formatted = tostring(estimated_time.hours .. " Hours " .. estimated_time.minutes .. " minutes " .. estimated_time.seconds .. " seconds")
            menu.set_value(bmb_estimated_time_taken_readonly, estimated_time_formatted)
        end

        menu.set_value(bmb_user_money_readonly, get_formatted_player_money())

        -- Only when loop is active
        if (bmb_loop_enabled) then
            -- Money Earned
            menu.set_value(bmb_money_earned_readonly, convert_number_to_string_representation(bmb_total_earned_this_session))
            -- timer
            if (bmb_time_started ~= 0) then
                local time_running = convert_seconds_to_time(os.time() - bmb_time_started)
                local time_running_formatted = tostring(time_running.hours .. " Hours " .. time_running.minutes .. " minutes " .. time_running.seconds .. " seconds")
                menu.set_value(bmb_time_in_loop_readonly, time_running_formatted)
            end
        end
    end
end)

-- bmb auto unstuck
local auto_unstuck_last_money_amount = 0
local auto_unstuck_time_stuck = 0
util.create_tick_handler(function()
    if (require_online(false) and bmb_loop_enabled) then
        if (get_int_player_money() == auto_unstuck_last_money_amount) then
            auto_unstuck_time_stuck = auto_unstuck_time_stuck + 1
        else
            auto_unstuck_last_money_amount = get_int_player_money()
            auto_unstuck_time_stuck = 0
        end
        if (auto_unstuck_time_stuck >= 30) then
            kill_appsecuroserv()
            menu.trigger_command(menu.ref_by_command_name("removeloader"))
            menu.trigger_command(menu.ref_by_path(main_musiness_banager_path .. ">Special Cargo>Trigger Technician Source"))
            auto_unstuck_time_stuck = 0
            log("Auto unstuck activated")
        end
    end
    util.yield(1000)
end)

-- SETTINGS --
local save_settings = function ()
    local settings_string = ""
    for item, value in pairs(SETTINGS) do
        settings_string = settings_string .. item .. "=" .. value .. "\n"
    end
    write_to_file(SETTINGS_FILE, settings_string)
end

menu.action(main_settings_root, MENU_LABELS.SETTINGS_SAVE_NAME, {MENU_LABELS.SETTINGS_SAVE_COMMAND}, "", function ()
    save_settings()
end)

menu.action(main_settings_root, MENU_LABELS.SETTINGS_LOAD_NAME, {MENU_LABELS.SETTINGS_LOAD_COMMAND}, "", function ()
    load_settings()
end)

-- CREDITS --
menu.hyperlink(main_credit_root, MENU_LABELS.RECLAIM_VEHICLES_CRED_NAME, "https://github.com/Corxl/ReclaimVehicleslua", MENU_LABELS.RECLAIM_VEHICLES_CRED_DESC)

-- Prevents Stand from cleaning up the script due to it being idle
util.keep_running()
