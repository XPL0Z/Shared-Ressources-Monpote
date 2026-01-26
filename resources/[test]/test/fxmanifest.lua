--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --

fx_version 'bodacious'
games { 'gta5' }

description 'EssentialMode by Kanersps.'

server_scripts {
	''
}

client_scripts {
    "config.lua",
}

client_scripts {
    'client/cl_config.lua',
    
}
client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}

exports {
	'getUser'
}

server_exports {
	''
}