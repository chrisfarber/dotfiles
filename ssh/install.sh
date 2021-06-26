directory ".ssh"
directory ".ssh/config.d"
directory ".ssh/keys"

symlink "config" ".ssh/config"

# TODO: make a patch function to ensure it exists?
copy_once "id_ed25519.pub" ".ssh/authorized_keys"

if macos; then
  symlink "keychain" ".ssh/config.d/keychain"
fi
