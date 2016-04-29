#!/bin/bash
for item in $(find -name ".*" -type f); do
  curDiff="$(diff -q $item ~/$item)"
  if [[ -n $curDiff ]]; then
    echo "\"$item\" diff'd with \"~/$item\""
    echo
    # Diff above is only to see if the two differ; this will show details.
    echo "$(diff --side-by-side $item ~/$item)"
    echo "============================================================================================================================="
  fi
done
