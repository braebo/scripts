#!/bin/bash

#? last screen-recording -> optimized mp4

function hb() {
	local desktop_path="$HOME/Desktop"
	local input_file="$1"
	local output_file=""

	# If input file path is not provided, find the most recent .mov file in the desktop directory
	if [[ -z $input_file ]]; then
		input_file=$(ls -t "$desktop_path"/*.mov 2>/dev/null | head -n 1)
	fi

	# If no .mov file is found, display an error message and exit
	if [[ -z $input_file ]]; then
		echo "No .mov file found in $desktop_path. Exiting."
		return 1
	else
		echo "Encoding $input_file"
	fi

	# Generate output file path with the .mp4 extension in the same directory as the input file
	output_file="${input_file%.*}.mp4"

	# Perform the encoding using HandBrakeCLI
	HandBrakeCLI -i "$input_file" -o "$output_file" \
		--encoder x264 --quality 22 --cfr --aencoder copy:aac \
		--audio-copy-mask aac,ac3,eac3,truehd,dts,dtshd,mp3,flac \
		--audio-fallback ffac3 --loose-anamorphic --modulus 2 \
		--encoder-preset faster --encoder-profile high --encoder-level 4.2 \
		>/dev/null 2>&1

	# Check if HandBrakeCLI succeeded
	if [ $? -eq 0 ]; then
		echo "Encoding completed successfully: $output_file"
	else
		echo "There was an error during the encoding process." >&2
	fi
}
