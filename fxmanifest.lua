fx_version "adamant"

author 'PlouffeLuL'
description 'Cayo perico heist'
version '1.0.0'

games { 'gta5'}
lua54 'yes'
use_experimental_fxv2_oal 'yes'

client_scripts {
	'configs/clientConfig.lua',
    'client/*.lua'
}

server_scripts {
	'configs/serverConfig.lua',
    'server/*.lua'
}

dependencies {
    "plouffe_lib"
}