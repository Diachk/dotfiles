#!/bin/sh

# Function to remove files from the source if they exist in the target directory's relative structure
remove_common_files_and_folders() {
	local source_dir=$1
	local target_dir=$2

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
		fi
	done

	echo "File removal complete!"
}

# Function to create symlinks from source_dir (original) to target_dir (symlinks)
create_symlinks() {
	local source_dir=$1
	local target_dir=$2

	# Loop through all files in the source directory
	for file in "$source_dir"/*; do
		# Get the base name of the file
		basefile=$(basename "$file")

		# Create a symbolic link in the target directory
		ln -s "$file" "$target_dir/$basefile"

		# Output message
		echo "Created symlink for $basefile in $target_dir"
	done

	echo "Symlinking complete!"
}

DOTFILES_HOME=$(dirname $(dirname $(realpath $0)))/home
echo "dotfiles home at $DOTFILES_HOME"
echo "user home at $HOME"
remove_common_files_and_folders $HOME $DOTFILES_HOME
create_symlinks $DOTFILES_HOME $HOME
