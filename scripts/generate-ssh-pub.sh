#!/usr/bin/env sh

search_dir=~/.ssh
for entry in "$search_dir"/*
do
  if file "$entry" | grep -q "private"; then
    echo "Changing $entry permissions to 600 . . ."
    chmod 600 "$entry"
    echo "Generating public key for $entry: "
    ssh-keygen -f "$entry" -y > "$entry.pub"
    echo "Running ssh-agent . . ."
    eval "$(ssh-agent -s)"
    echo "Adding key to ssh-agent . . ."
    ssh-add "$entry"
  fi
done
