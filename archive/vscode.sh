#!/bin/bash

USER_NAME=$(ls /home)
USER_HOME="/home/$USER_NAME"
code_settings="$USER_HOME/.config/Code/User/settings.json"

# Import signing key and create repository file
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Update and install pylint for extension
dnf check-update
dnf install code pylint -y

# Install extensions
su "$USER_NAME" -c "code --install-extension ms-python.python"
su "$USER_NAME" -c "code --install-extension timonwong.shellcheck"
su "$USER_NAME" -c "code --install-extension yzhang.markdown-all-in-one"
su "$USER_NAME" -c "code --install-extension vscodevim.vim"

# Settings
su "$USER_NAME" -c "touch $code_settings"
su "$USER_NAME" -c 'echo "{
    \"telemetry.enableTelemetry\": false,
    \"telemetry.enableCrashReporter\": false,
    \"file.autoSave\": \"afterDelay\",
    \"python.linting.pylintEnabled\": true,
    \"python.linting.enabled\": true
}
"' > "$code_settings"