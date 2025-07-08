#!/bin/sh

num_pokemon=6

temp_files=""
for i in $(seq 1 $num_pokemon); do
    pokemon_art=$(pokemon-colorscripts --no-title -n pikachu)
    temp_file=$(mktemp)
    echo "$pokemon_art" | sed '/^$/d' > "$temp_file"
    temp_files="$temp_files $temp_file"
done

max_lines=0
for temp_file in $temp_files; do
    num_lines=$(wc -l < "$temp_file")
    if [ "$num_lines" -gt "$max_lines" ]; then
        max_lines=$num_lines
    fi
done

for line_number in $(seq 1 $max_lines); do
    for temp_file in $temp_files; do
        pokemon_line=$(sed -n "${line_number}p" "$temp_file")
        printf "%-40s" "${pokemon_line:-}"
    done
    echo
done

for temp_file in $temp_files; do
    rm "$temp_file"
done
