#!/bin/sh
echo -ne '\033c\033]0;MHSDEV02 - First project\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/MHSDEV02 - First project.x86_64" "$@"
