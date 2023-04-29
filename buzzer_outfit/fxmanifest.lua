fx_version 'cerulean'
games { 'gta5' }

author "Vrality"

client_scripts {
    'shared/*.lua',
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'shared/*.lua',
    'server/*.lua'
}


provide {
    'skinchanger',
    'esx_skin'
}