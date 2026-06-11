trap 'echo "Error at ${BASH_SOURCE[0]}:$LINENO command: $BASH_COMMAND"' ERR

# or:

error_handler() {
    echo "Error in ${BASH_SOURCE[0]}:$LINENO" >&2
    echo "Command: $BASH_COMMAND" >&2
    exit 1
}
trap 'error_handler' ERR
