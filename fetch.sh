# Make the HTTP request and retrieve the JSON data
response=$(curl -s "https://packagist.org/packages/phpunit/phpunit.json")

# Extract the versions from the JSON data
versions=$(echo "$response" | jq -r '.package.versions | keys[] | select(test("^((?!dev).)*$"))' | sort -V | tail -n 1)

# Output the versions

# Get the list of all tags
tags=$(git tag)

# Find the versions not included in tags
not_in_tags=()
for version in $versions; do
    if [[ ! "$tags" =~ (^|[[:space:]])"$version"($|[[:space:]]) ]]; then
        not_in_tags+=("$version")
    fi
done


echo $(jq -c -n '$ARGS.positional' --args "${not_in_tags[@]}")
