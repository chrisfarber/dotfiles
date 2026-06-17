directory_with_mode ".ssh" 700

# 2025-01-03 - disabling this, because various tools keep polluting
# the .ssh/config file and I don't have much customization in it anyway.

# symlink "config" ".ssh/config"

symlink "chris_2026.pub" ".ssh/signing_key.pub"
authorize_ssh_key "chris_2026.pub"

deauthorize_ssh_key "chris_2022.pub"
