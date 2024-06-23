zellij ls -ns | sort | gum choose | xargs -n1 zellij delete-session --force
