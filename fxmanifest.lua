fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_scripts { '@ox_lib/init.lua' }
client_scripts { 'configs/client.lua', 'bridge/client/**/*.lua', 'client/*.lua' }
server_scripts { 'configs/server.lua', 'bridge/server/**/*.lua', 'server/*.lua' }