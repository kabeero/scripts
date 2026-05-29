ok() { printf "  \033[32m✓\033[0m %s\n" "$1"; }
warn() { printf "  \033[33m!\033[0m %s\n" "$1"; }
miss() { printf "  \033[31m✗\033[0m %s\n" "$1"; }
