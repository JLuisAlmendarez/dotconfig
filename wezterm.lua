local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.window_padding = {
	top = 0,
	right = 0,
	left = 0,
	bottom = 0,
}

config.background = {
	{
	source = { File = wezterm.config_dir .. "/misc/ImagenWindows.png" },
	},
	{
	source = { Color = "#000000" },
	width = "100%",
	height = "100%",
	opacity = 0.85,
	},
}

config.window_decorations = "RESIZE"
config.enable_tab_bar = false -- Deprecado
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	return ""
end)
-- ajustar estos
config.colors = {
foreground = "#a9b7c6",
background = "#2b2b2b",
cursor_bg = "#a9b7c6", 
cursor_fg = "#2b2b2b",
cursor_border = "#a9b7c6",
selection_fg = "#2b2b2b",
selection_bg = "#214283",
scrollbar_thumb = "#5a5a5a",
split = "#5a5a5a", 
ansi = {
"#2b2b2b", "#cc7832", "#6a8759", "#007000", "#6897bb", "#9876aa", "#629755", "#a9b7c6"
},
brights = {
"#5a5a5a", "#f75464", "#a5c261", "#e0e04d", "#589df6", "#c17edb", "#6cbbb3", "#ffffff",
}

}



config.keys = {
	{ --Cambiar Ventana a Pantalla Completa
	key = "Enter",
	mods = "ALT",
	action = wezterm.action.ToggleFullScreen,
	},
	{ --Cerrar Panel
	key = "e",
	mods = "CMD",
	action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{ --Busqueda en Terminal
	key = "f",
	mods = "CTRL|SHIFT",
	action = wezterm.action.DisableDefaultAssignment,
	},
	{
	key = "f",
	mods = "CTRL",
	action = wezterm.action.Search({ CaseSensitiveString = "" }),
	},
-- 	Deprecado, analogo de uso en .conf de tmux
--	{ --Split Horizontal del Panel
--	key = "o",
--	mods = "CTRL",
--	action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
--	},
--	{ --Split Vertical del Panel
--	key = "l",
--	mods = "CTRL",
--	action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
--	},
--	{ --Moverse entre subpaneles: Direccion Izquierda
--	key = "LeftArrow",
--	mods = "CTRL|SHIFT",
--	action = wezterm.action.ActivatePaneDirection("Left"),
--	},
--	{ --Moverse entre subpaneles: Direccion Abajo
--	key = "DownArrow",
--	mods = "CTRL|SHIFT",
--	action = wezterm.action.ActivatePaneDirection("Down"),
--	},
--	{ --Moverse entre subpaneles: Direccion arriba
--	key = "UpArrow",
--	mods = "CTRL|SHIFT",
--	action = wezterm.action.ActivatePaneDirection("Up"),
--	},
--	{ --Moverse entre subpaneles: Direccion derecha
--	key = "RightArrow",
--	mods = "CTRL|SHIFT",
--	action = wezterm.action.ActivatePaneDirection("Right"),
--	},
	{ --Liberar Ctrl+Shift+Flechas para que las use tmux
	key = "LeftArrow",
	mods = "CTRL|SHIFT",
	action = wezterm.action.DisableDefaultAssignment,
	},
	{
	key = "DownArrow",
	mods = "CTRL|SHIFT",
	action = wezterm.action.DisableDefaultAssignment,
	},
	{
	key = "UpArrow",
	mods = "CTRL|SHIFT",
	action = wezterm.action.DisableDefaultAssignment,
	},
	{
	key = "RightArrow",
	mods = "CTRL|SHIFT",
	action = wezterm.action.DisableDefaultAssignment,
	},
}

-- Barra de Estado / Deprecado, cambiado a barra de estado en tmux
local meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre","Octubre", "Noviembre", "Diciembre"}
local function get_datetime()
	local mes = meses[tonumber(wezterm.strftime("%m"))]
	return wezterm.strftime("%d de ") .. mes .. wezterm.strftime(" del %Y, Hora: %H:%M")
end
local function run_command(cmd)
	local success, stdout, stderr = wezterm.run_child_process({ "bash", "-c", cmd })
	if success then
		return (stdout:gsub("%s+$", "")) -- quita espacios/saltos de línea al final
	end
	return "N/A"
end
local function get_cpu()
	local cmd = "top -bn1 | grep 'Cpu(s)' | awk '{printf \"%.0f%%\", 100 - $8}'"
	return run_command(cmd)
end
local function get_ram()
	local cmd = "free | awk '/Mem/{printf \"%.0f%%\", $3/$2 * 100}'"
	return run_command(cmd)
end
local function get_gpu()
	local cmd = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits"
	local result = run_command(cmd)
	if result ~= "N/A" then
		return result .. "%"
	end
	return "N/A"
end

--Deprecado
wezterm.on("update-status", function(window, pane)
	window:set_right_status(wezterm.format({
	{ Foreground = { Color = "#89dceb" } },
	{ Text = "CPU " .. get_cpu() .. "  " },
	{ Foreground = { Color = "#a6e3a1" } },
	{ Text = "RAM " .. get_ram() .. "  " },
	{ Foreground = { Color = "#f9e2af" } },
	{ Text = "GPU " .. get_gpu() .. "  " },
	{ Foreground = { Color = "#cba6f7" } },
	{ Text = get_datetime() .. "  " },
	}))
end)

config.status_update_interval = 2000

return config
