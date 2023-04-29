fx_version 'adamant'

game 'gta5'

author 'Vrality x Hwan'


ui_page 'ui/index.html'

files {
    'ui/**',
}


shared_script {
    'share/*',
}
-- What to run
client_scripts {
    'client/*'
}


server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*'
}
