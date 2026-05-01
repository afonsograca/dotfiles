# Function to source a file if a utility is missing
#
# This function checks if a given utility is available in the system. If the utility is not found,
# it sources a file specified by the file path. This is useful for sourcing environment variables
# or functions from a file only if the required utility is missing.
#
# Arguments:
#   $1: The name of the utility to check for
#   $2: The file path to source if the utility is missing
#
# Example usage:
#   source_if_missing "jq" "/path/to/file.sh"
#
source_if_missing() {
  local util=$1
  local file_path=$2
  if ! command -v $util >/dev/null 2>&1; then
    source $file_path
  fi
}