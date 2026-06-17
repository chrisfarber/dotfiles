directory ".config/jj"
directory ".config/jj/conf.d"

symlink "config.toml" ".config/jj/config.toml"
copy_once "local.toml" ".config/jj/conf.d/local.toml"

if macos; then
  symlink "macos.toml" ".config/jj/conf.d/macos.toml"
fi
