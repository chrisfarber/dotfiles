profile_d="/opt/homebrew/etc/profile.d/*"
if [[ -d $profile_d ]]; then
    for file in $profile_d; do
	source $file
    done
fi
