let g:cmake_jump_on_error = 0 " We do not want to focus the console
let g:cmake_link_compile_commands = 1
let g:cmake_build_dir_location = 'build'

augroup vim-cmake-group
autocmd User CMakeBuildFailed :cfirst
autocmd! User CMakeBuildSucceeded CMakeClose
augroup END
