#!/bin/bash

#? last screen-recording -> gif

function gif() {
	desktop_path="$HOME/Desktop"
	input_file="$1"
	output_file=""

	# If input file path is not provided, find the most recent .mov file in the desktop directory
	if [[ -z $input_file ]]; then
		input_file=$(ls -t "$desktop_path"/*.mov 2>/dev/null | head -n 1)
	fi

	# If no .mov file is found, display an error message and exit
	if [[ -z $input_file ]]; then
		echo "No .mov file found in $desktop_path. Exiting."
		exit 1
	else
		echo "Encoding $input_file"
	fi

	# Generate a reduced color palette with scaled resolution
	ffmpeg -i "$input_file" -vf "fps=20,scale=500:-1:flags=lanczos,palettegen" -loglevel error -y palette.png

	# Create the GIF using the palette, scaled resolution, and adjusted FPS
	# ffmpeg -y -i "$input_file" -i palette.png -filter_complex "fps=20,scale=500:-1:flags=lanczos[x];[x][1:v]paletteuse" -loglevel error "${input_file%.*}.gif"
	ffmpeg -y -i "$input_file" -i palette.png -filter_complex "fps=20,scale=750:-1:flags=lanczos[x];[x][1:v]paletteuse" -loglevel error "${input_file%.*}.gif"


	# Print the clickable output file path
	output_path="${input_file%.*}.gif"
	output_url="file://${output_path}"
	printf "✅ \033]8;;%s\a%s\033]8;;\a\n" "$output_url" "$output_path"

	# Open the output file in Finder
	open -R "$output_path" --args -R "$parent_folder"
}
