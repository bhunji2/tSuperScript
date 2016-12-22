{
	"menu_id" : "bltcs_options_menu",
	"parent_menu_id" : "lua_mod_options_menu",
	"title" : "bltcs_options_menu_title",
	"description" : "bltcs_options_menu_desc",
	"focus_changed_callback" : "BLT_CarryStacker_Open_Options",
	"back_callback" : "BLT_CarryStacker_Close_Options",
	"items" : [
		{
			"type" : "button",
			"id" : "bltcs_button_help",
			"title" : "bltcs_button_help_title"
			"description" : "bltcs_button_help_desc",
			"callback" : "BLT_CarryStacker_Help",
		},

		{
			"type" : "divider",
			"size" : 20,
		},

		{
			"type" : "slider",
			"id" : "bltcs_light",
			"title" : "bltcs_slider_light_title",
			"description" : "bltcs_slider_light_desc",
			"callback" : "BLT_CarryStacker_setBagPenalty",
			"value" : "light",
			"default_value" : 10,
			"min" : 0,
			"max" : 50,
			"step" : 1,
		},
		{
			"type" : "slider",
			"id" : "bltcs_medium",
			"title" : "bltcs_slider_medium_title",
			"description" : "bltcs_slider_medium_desc",
			"callback" : "BLT_CarryStacker_setBagPenalty",
			"value" : "medium",
			"default_value" : 20,
			"min" : 0,
			"max" : 50,
			"step" : 1,
		},
		{
			"type" : "slider",
			"id" : "bltcs_heavy",
			"title" : "bltcs_slider_heavy_title",
			"description" : "bltcs_slider_heavy_desc",
			"callback" : "BLT_CarryStacker_setBagPenalty",
			"value" : "heavy",
			"default_value" : 30,
			"min" : 0,
			"max" : 50,
			"step" : 1,
		},
		{
			"type" : "slider",
			"id" : "bltcs_very_heavy",
			"title" : "bltcs_slider_veryheavy_title",
			"description" : "bltcs_slider_veryheavy_desc",
			"callback" : "BLT_CarryStacker_setBagPenalty",
			"value" : "very_heavy",
			"default_value" : 40,
			"min" : 0,
			"max" : 50,
			"step" : 1,
		},
		{
			"type" : "slider",
			"id" : "bltcs_mega_heavy",
			"title" : "bltcs_slider_megaheavy_title",
			"description" : "bltcs_slider_megaheavy_desc",
			"callback" : "BLT_CarryStacker_setBagPenalty",
			"value" : "mega_heavy",
			"default_value" : 50,
			"min" : 0,
			"max" : 50,
			"step" : 1,
		},

		{
			"type" : "divider",
			"size" : 20,
		},

		{
			"type" : "toggle",
			"id" : "bltcs_host_sync",
			"title" : "bltcs_toggle_host_sync_title",
			"description" : "bltcs_toggle_host_sync_desc",
			"callback" : "BLT_CarryStacker_toggleHostSync",
			"value" : "toggle_host",
			"default_value" : true,
		},

		{
			"type" : "button",
			"id" : "bltcs_button_reset",
			"title" : "bltcs_button_reset_title",
			"description" : "bltcs_button_reset_desc",
			"callback" : "BLT_CarryStacker_Reset",
		}
	]
}
