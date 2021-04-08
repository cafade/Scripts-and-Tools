#!/bin/bash

inotifywait -e close_write -m /home/learnin/Documents |
while read -r directory events filename; do
  if [ "$filename" = "School-Todos.md" ]; then
      pandoc -o '/home/learnin/Documents/School-Todos.pdf' '/home/learnin/Documents/School-Todos.md'
  fi
done
