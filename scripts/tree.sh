#!/bin/bash
ignore_list=$(cat .gitignore | grep -vE 'local.vim' | tr '\n' '|')
ignore_list=${ignore_list}".git|vim-startuptime.log"
tree -aF -I $ignore_list
