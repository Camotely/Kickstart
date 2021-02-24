#!/bin/bash

USER_NAME=$(ls /home)
USER_HOME="/home/$USER_NAME"

# Remove folders
rm -rf "$USER_HOME"/Desktop "$USER_HOME"/Pictures "$USER_HOME"/Templates "$USER_HOME"/Videos "$USER_HOME"/Public "$USER_HOME"/Music