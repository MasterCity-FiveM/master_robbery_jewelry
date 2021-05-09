fx_version 'adamant'

game 'gta5'

description 'ESX Jewelry Robbery'

version '2.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua'
}

dependencies {
	'es_extended'
}
