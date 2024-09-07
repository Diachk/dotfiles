#!/bin/sh

# Function to remove files and directories from source_dir (to delete) if they exist in target_dir (original)
remove_common_files_and_folders() {
	local source_dir=$1
	local target_dir=$2

	# Loop through all files and directories in the source directory
	for item in "$source_dir"/*; do
		# Get the base name of the item
		baseitem=$(basename "$item")

		# Check if the item is a file and exists in the target directory
		if [ -e "$target_dir/$baseitem" ]; then
			# If it's a directory, remove recursively
			if [ -d "$item" ]; then
				echo "Removing directory $baseitem from $source_dir because it exists in $target_dir"
				rm -r "$item"
				echo "Removed directory $baseitem"
			# If it's a file, just remove the file
			elif [ -f "$item" ]; then
				echo "Removing file $baseitem from $source_dir because it exists in $target_dir"
				rm "$item"
				echo "Removed file $baseitem"
			fi
		fi
	done

	echo "File and directory removal complete!"
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
