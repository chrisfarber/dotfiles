directory ".ssh"

# 2025-01-03 - disabling this, because various tools keep polluting
# the .ssh/config file and I don't have much customization in it anyway.

# symlink "config" ".ssh/config"

# TODO: make a patch function to ensure it exists?
copy_once "id_ed25519.pub" ".ssh/authorized_keys"
