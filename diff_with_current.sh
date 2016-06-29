#!/bin/bash

diffTool="$(which colordiff)"
if [[ "$diffTool" == "" ]]; then
  diffTool="$(which diff)"
fi

for item in $(find -name ".*" -type f | grep -v ".git"); do
  curDiff="$("$diffTool" -q "$item" "$HOME/$item")"
  if [[ -n $curDiff ]]; then
    echo "[REPO] \"$item\" diff'd with [CURRENT_HOME] \"~/$item\""
    echo
    # Diff above is only to see if the two differ; this will show details.
    echo "$("$diffTool" --side-by-side --suppress-common-lines "$item" "$HOME/$item")"
    echo "============================================================================================================================="
  fi
done
