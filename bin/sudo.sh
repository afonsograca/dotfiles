##
## Helper to keep sudo alive
##

activate_sudo() {
  ## Make sure you have admin privileges
  if ! sudo -n -v 2>/dev/null; then
    printf "\nProvide me some admin rights, pretty please:\n"
    sudo -v
    if [ $? -ne 0 ]; then
      return 1
    fi
    printf "\nAll set and ready to start!\n"
  fi

  ## Keep admin privileges alive in the background
  while true; do
    sudo -v               # keep sudo alive
    sleep 60              # wait for a minute
    kill -0 "$$" || exit  # check if process is still running, otherwise exit
  done 2>/dev/null &
}