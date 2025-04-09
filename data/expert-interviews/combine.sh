#!/bin/bash

output="combined-expert-interviews.md"
> "$output"  # Empty the output file first

# Use find, exclude the output file itself
find . -type f -name "*.md" ! -name "$output" | sort | while read -r file; do
    echo "## $(basename "$file")" >> "$output"
    echo "" >> "$output"
    cat "$file" >> "$output"
    echo -e "\n\n" >> "$output"
done

echo "✅ Combined all .md files (excluding $output) into $output"
