function config {
  run git config --global $1 $2
}

config gc.auto 0

config user.email chris@chrisfarber.net
config user.name "Chris Farber"

config core.quotepath false
config core.excludesFile "$HOME/.gitignore"

config push.default tracking
config pull.rebase true

config init.defaultBranch main

config --type=bool push.autoSetupRemote true