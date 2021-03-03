#!/bin/bash

# Post VSCode (Flatpak) installation setup

USER_NAME=$(ls /home)
code_settings="/home/$USER_NAME/.var/app/com.visualstudio.code/config/Code/User/settings.json"

# Extensions
su "$USER_NAME" -c "flatpak run com.visualstudio.code --install-extension ms-python.python"
su "$USER_NAME" -c "flatpak run com.visualstudio.code --install-extension timonwong.shellcheck"
su "$USER_NAME" -c "flatpak run com.visualstudio.code --install-extension yzhang.markdown-all-in-one"
su "$USER_NAME" -c "flatpak run com.visualstudio.code --install-extension vscodevim.vim"

# Settings
su "$USER_NAME" -c 'echo "{
    \"telemetry.enableTelemetry\": false,
    \"telemetry.enableCrashReporter\": false,
    \"file.autoSave\": \"afterDelay\",
    \"python.linting.pylintEnabled\": true,
    \"python.linting.enabled\": true
}
"' > "$code_settings"

