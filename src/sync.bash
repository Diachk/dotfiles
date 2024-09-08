#!/bin/bash

# Function to remove files from the source if they exist in the target directory's relative structure
remove_common_files_and_folders() {
	local source_dir=$1
	local target_dir=$2
	local file_count=0

	# Recursively walk through the target directory
	find "$target_dir" -type f | while read -r target_file; do
		# Get the relative path of the file from the target directory
		relative_path="${target_file#$target_dir/}"

		# Create the equivalent path in the source directory
		source_file="$source_dir/$relative_path"

		# Check if the file exists in the source directory
		if [ -e "$source_file" ]; then
			echo "Removing file $source_file from source directory because it exists in target directory"
			rm "$source_file"
			echo "Removed file $source_file"
			file_count=$((file_count + 1))
		fi
	done

	echo "Total files removed: $file_count"
}

# Function to create symlinks recursively
create_symlinks_recursively() {
	local source_dir=$1
	local target_dir=$2

	# Loop through all items in the source directory
	for item in "$source_dir"/*; do
		# Get the base name of the item
		baseitem=$(basename "$item")

		# If item is a directory, apply the same logic recursively
		if [ -d "$item" ]; then
			# Create the directory in the target directory if it doesn't exist
			if [ ! -d "$target_dir/$baseitem" ]; then
				mkdir -p "$target_dir/$baseitem"
				echo "Created directory $target_dir/$baseitem"
			fi
			# Recursively process the directory
			create_symlinks_recursively "$item" "$target_dir/$baseitem"
		# If item is a file, create a symlink in the target directory
		elif [ -f "$item" ]; then
			ln -s "$item" "$target_dir/$baseitem"
			echo "Created symlink for $baseitem in $target_dir"
		fi
	done
}

DOTFILES_HOME=$(dirname $(dirname $(realpath $0)))/home
echo "dotfiles home at $DOTFILES_HOME"
echo "user home at $HOME"
# remove_common_files_and_folders $HOME $DOTFILES_HOME
# create_symlinks $DOTFILES_HOME $HOME
