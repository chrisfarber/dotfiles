function config {
  run git config --global $1 $2
}

config gc.auto 0

# config user.email chris@chrisfarber.net
# config user.name "Chris Farber"

config core.quotepath false
config core.excludesFile "$HOME/.gitignore"

config push.default tracking
config pull.rebase true

config init.defaultBranch main

config push.autoSetupRemote true

config gpg.format ssh
config user.signingKey "~/.ssh/signing_key.pub"
config commit.gpgsign true
config tag.gpgsign true

if macos; then
  config gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
fi
