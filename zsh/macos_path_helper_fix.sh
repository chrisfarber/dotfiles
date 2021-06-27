#path_before_user_env
#path_before_path_helper
path_after_path_helper=($path[@])


path=()

# get the user defined paths
for dir in $path_before_path_helper; do
  # skip the path if it exists in path_before_user_env
  if [[ $path_before_user_env[(Ie)$dir] -gt 0 ]] continue
  path+=($dir)
done

for dir in $path_after_path_helper; do
  if [[ $path[(Ie)$dir] -gt 0 ]] continue
  path+=($dir)
done

# path=($new_paths[@])

unset dir
unset path_before_user_env
unset path_before_path_helper
unset path_after_path_helper