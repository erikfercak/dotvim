" Don't stop on first line but continue to first breakpoint.
if has("python")
    let g:vdebug_options['break_on_open'] = 0
    let g:vdebug_options['ide_key'] = 'PHPSTORM'
    let g:vdebug_options['server'] = 'vagrant.dev'
    let g:vdebug_options['path_maps'] = {'/vagrant-src': '/Users/erik/projects/forge/vagrant/src'}
endif
