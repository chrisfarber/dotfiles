directory_with_mode ".config" 700
directory_with_mode ".config/helix" 700
directory_with_mode ".config/helix/themes" 700

symlink "config.toml" ".config/helix/config.toml"
symlink "languages.toml" ".config/helix/languages.toml"
symlink "snippets" ".config/helix/snippets"
symlink "monokai_pro_light.toml" ".config/helix/themes/monokai_pro_light.toml"
