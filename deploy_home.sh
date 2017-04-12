#!/bin/bash

# Link everything in the linkins directory into ~
# Record the links created so they can be deleted
# if a file is ever removed from the repo. Delete
# recorded links before creating new ones.

# Wherever a directory structure is encountered, create
# the same structure and link in only the regular files.

# As we might symlink to this script, the location needs
# to be explicitly resolved in order to find linkins
scriptdir=$(dirname $(readlink -f "$0"))

# Ensure ~/bin exists
mkdir -p ~/bin

# Remove any symlinks created previously
pushd "$scriptdir" > /dev/null
dir=$(pwd -P)
linkfile="$dir"/.links
if [ -e "$linkfile" ] ; then
    while read link; do
        if [ -h ~/$link ]; then
            echo "Unlinking: ~/$link"
            rm ~/"$link"
        fi
    done < "$linkfile"
fi

> "$linkfile".new

# Create new links
cd "$scriptdir"/linkins
dir=$(pwd -P)
while IFS= read -r -d '' file; do
    if [ -e ~/$file ]; then
        echo "Skipping ~/$file - file exists!" >&2
        continue
    fi
    echo "Relinking: ~/$file"
    mkdir -p ~/"$(dirname $file)"
    dest=~/"$(dirname $file)" # Where the link will be
    targ="$dir"/"$file"       # Where the link will point
    ln -sf "$targ" "$dest" && echo "$file" >> "$linkfile".new
done < <(find . -type f -printf '%P\0')

# Remove any directories which are empty due to deleted links
if [ -e "$linkfile" ] ; then
    while read line; do
        dir=$(dirname "$line")
        while [ ! "$dir" = "." ] ; do
            # If directory no longer exists, continue to ..
            if [ ! -e ~/"$dir" ] ; then
                dir=$(dirname "$dir")
                continue
            fi
            # If directory is not empty, stop
            if [ "$(ls -A ~/"$dir")" ]; then
                break
            fi
            echo "rmdir: ~/$dir"
            rmdir ~/"$dir"
            dir=$(dirname "$dir")
        done
    done < "$linkfile"
fi

# Overwrite old linkfile with new
mv "$linkfile.new" "$linkfile"

# Add link to this script in ~/bin
cd "$scriptdir"
dir=$(pwd -P)
ln -sf "$dir"/"$(basename $0)" ~/bin/"$(basename $0)"

popd > /dev/null
