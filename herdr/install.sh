directory_with_mode ".config" 700
directory ".config/herdr-app"
directory ".config/herdr-app/themes"
directory ".config/herdr-app/mods"

symlink "settings.json" ".config/herdr-app/settings.json"
symlink "keys.json" ".config/herdr-app/keys.json"
symlink "themes/monokai-pro.json" ".config/herdr-app/themes/monokai-pro.json"
symlink "themes/monokai-pro-light.json" ".config/herdr-app/themes/monokai-pro-light.json"
symlink "mods/leader" ".config/herdr-app/mods/leader"

# A theme picked in Herdr's settings is saved per layout and beats settings.json.
# If Monokai Pro doesn't show, with Herdr running:
#   herdr-app do app.theme --name monokai-pro
#   herdr-app do app.theme --name monokai-pro-light
