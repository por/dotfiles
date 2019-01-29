export NVM_DIR="$HOME/.nvm"
nvm_load () {
  . $NVM_DIR/nvm.sh
  . $NVM_DIR/bash_completion
}
alias node='unalias nvm; unalias node; unalias npm; nvm_load; node $@'
alias npm='unalias nvm; unalias node; unalias npm; nvm_load; npm $@'
alias nvm='unalias nvm; unalias node; unalias npm; nvm_load; nvm $@'
