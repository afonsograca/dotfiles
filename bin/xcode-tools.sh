## 
## Helper method to check for Xcode Command Line tools
##

# based on https://github.com/timsutton/osx-vm-templates/blob/master/scripts/xcode-cli-tools.sh
install_xcode_tools() {
  if xcode-select -p &>/dev/null; then
    echo "\nAll good, we have Xcode Command Line tools already installed.\n"
  else
    # create the placeholder file that's checked by CLI updates' .dist code
    # in Apple's SUS catalog
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    # find the CLI Tools update
    PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
    
    echo "\nInstalling Xcode Command Line tools...\n"
    softwareupdate -i "$PROD" --verbose

    return_value=$?
    if [ $return_value -ne 0 ]; then
      echo "\nOops, something went wrong while installing Xcode Command Line tools.\n"
    else
      echo "\nYay, Xcode Command Line tools was successfully installed.\n"
    fi 
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    return $return_value
  fi
}
