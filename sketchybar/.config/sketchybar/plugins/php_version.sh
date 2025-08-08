#!/bin/bash
# Script to update PHP version in SketchyBar

# Try Herd PHP first, fall back to system PHP if it fails
php_version=$(~/Library/Application\ Support/Herd/bin/php -v 2>/dev/null | head -n 1 | awk '{print $2}' || php -v 2>/dev/null | head -n 1 | awk '{print $2}')

# Check if PHP is installed
if [ -z "$php_version" ]; then
    sketchybar --set $NAME label="PHP: Not Installed" icon="󰌟"
else
    # Truncate version if it's too long
    if [ ${#php_version} -gt 4 ]; then
        php_version="${php_version:0:3}"
    fi

    sketchybar --set $NAME label="v$php_version" icon="󰌟"
fi
