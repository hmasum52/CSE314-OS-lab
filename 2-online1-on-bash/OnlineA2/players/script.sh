#!/bin/bash

for dir in *; do
    if [[ -d "$dir" ]]; then
        # echo "$dir"
        cd "$dir"
        for sub_dir in *; do
            if [[ -d "$sub_dir" ]]; then
                # echo "$sub_dir"
                cd "$sub_dir"
                for file in *; do
                    if [[ -f "$file" ]]; then
                        echo "$dir/$sub_dir/$file"
                        name=$(cat "$file" | head -n1)
                        # echo "palyer name: $name"
                        country=$(cat "$file" | head -n2| tail -n1)
                        # echo "country: $country"
                        role=$(cat "$file" | head -n4| tail -n1)
                        # echo "role: $role"
                        mkdir -p "../../$country/$role"
                        mv -f "$file" "../../$country/$role/$name.txt"
                    fi
                done
                cd ..
            fi
        done
        find . -type d -empty -delete
        cd ..
    fi
done
find . -type d -empty -delete

exit 0