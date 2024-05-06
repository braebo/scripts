#!/bin/zsh

#? simple video processing

function quish() {
	# ...
	printHelp() {
		e "                           $(b "            _     _      ")"
		e "                           $(b "           |_|   | |     ")"
		e "                           $(b "    ___ _ _______| |_    ")"
		e "                           $(b "   | . | | | |_ -|   |   ")"
		e "                           $(b "   |_  |___|_|___|_|_|   ")"
		e "                           $(b "     |_|                 ")"
		e "                           $(b "                         ")"
		e "                          ⌜$(dim "-------------------------")⌝"
		e "                          $(dim "|") simple video processing $(dim "|")"
		e "                          ⌞$(dim "-------------------------")⌟"

		e ""
		bb Usage
		e "  $(b quish) [FILE|DIRECTORY] [OPTIONS]"
		e ""
		bb Options
		e "  -r, --resolution $(dim "width:height")  Set the output resolution.  $(dim default) $(b "1280:1280")"
		e "  -b, --bitrate $(dim "kbps")             Set the output bitrate.     $(dim default) $(b 3000)"
		e "  -f, --fps $(dim "fps")                  Set the output framerate.   $(dim default) $(b 24)"
		e "  -t, --type $(dim "type")                Set the output file type.   $(dim default) $(b webm)"
		e "  -s, --formats $(dim "ext1,ext2,... ")   Set the input formats.      $(dim default) $(b \"mp4,mov\")"
		e "  -d, --depth $(dim "n")                  Set the search depth.       $(dim default) $(b 1)"
		e "  -h, --help                     Print this help message."
		e ""
		bb Examples
		e "  Process all videos in the current directory:"
		b "    quish ."
		e ""
		e "  Process all videos in a subfolder called 'media':"
		b "    quish ./my/media/"
		e ""
		e "  Process a single video called 'input.mov':"
		b "    quish input.mov $(bb '')$(bb '-r') $(b '1920:1080') $(bb '-b') $(b '3000') $(bb '-f') $(b '20')"
	}

	# Print help if no arguments are provided or if --help or -h flag is provided.
	if [[ $# -eq 0 ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
		printHelp
		return 1
	fi

	# Default settings.
	local resolution="1280:1280"
	local bitrate=3000
	local fps=24
	local type="webm"
	local formats="mp4,mov"
	local depth=2

	# Parse CLI flags.
	local input_set=0
	while [[ "$#" -gt 0 ]]; do
		case "$1" in
		-r | --resolution)
			resolution="$2"
			shift
			;;
		-b | --bitrate)
			bitrate="$2"
			shift
			;;
		-f | --fps)
			fps="$2"
			shift
			;;
		-t | --type)
			type="$2"
			shift
			;;
		-s | --formats)
			formats="$2"
			shift
			;;
		-d | --depth)
			depth="$2"
			shift
			;;
		*)
			if ((input_set == 0)); then
				input="$1"
				input_set=1
			fi
			;;
		esac
		shift
	done

	if [[ -z "$input" ]]; then
		r "$(bb '\nNo input file or directory specified.')"
		e "Use $(b 'quish --help') to see usage instructions."
		return 1
	elif [[ ! -e "$input" ]]; then
		r "$(bb '\nFile or directory not found: ')$input"
		dim "cant quish..."
		dim "(╯°□°)╯"
		return 1
	fi

	function printSettings() {
		e ""
		e "  $(bb Resolution): $(b $resolution)"
		e "  $(bb Bitrate): $(b $bitrate kbps)"
		e "  $(bb FPS): $(b $fps)"
		e "  $(bb "Inputs"): $(b $formats)"
		e "  $(bb "Output"): $(b $type)"
		e ""
	}

	process_video() {
		local file=$1
		local filename=$(basename "$file")
		local dirname=$(dirname "$file")
		local output="${dirname}/${filename%.*}"
		local name="${filename%%.*}"
		local ext="${filename##*.}"
		local currentSize=$(du -sh "$file" | cut -f1)

		local output_type="${filename##*.}"

		((video_count++))

		e "\n$video_count$(dim /)$num_videos $(dim "$name").$(b $ext) --> $(dim "$name").$(b $type)\n"

		ffmpeg -y -v quiet -stats -i "$file" -vf "scale=$resolution:force_original_aspect_ratio=decrease,pad=$resolution:(ow-iw)/2:(oh-ih)/2" \
			-r "$fps" -b:v "$bitrate"k "${output}.${type}" </dev/null

		e "$(g "Complete:") $output.$(b $type)"
		local newSize=$(du -sh "${output}.${type}" | cut -f1)
		local percent=$(bc <<<"scale=2; $newSize / $currentSize * 100")
		e "$(dim $currentSize) -> $newSize $(dim "($percent%)")"
	}

	count_videos() {
		local dir=$1
		local count=$(find "$dir" -type f \( -name "*.mp4" -o -name "*.mov" \) -maxdepth "$depth" 2>/dev/null | wc -l)
		bb $(b $count)
	}

	askFirst() {
		printf "Continue? (Y/n): "
		read confirm
		confirm=${confirm:-Y} # Default value to "Y"

		if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
			e "k.."
			return 1
		fi
	}

	# Convert formats string to array
	local IFS=',' read -r -a format_array <<<"$formats"

	if [[ -d "$input" ]]; then
		local num_videos=$(count_videos "$input")
		e "$num_videos videos found. Settings:"
		printSettings

		askFirst

		e "Processing $(b $num_videos) video files in the directory: $(realpath $input)"

		local video_count=0 # Initialize video count

		# Generate string of -name arguments for find command
		local name_args=""
		for format in "${format_array[@]}"; do
			name_args+="-name \"*.$format\" -o "
		done

		# Remove the trailing '-o' from the name arguments.
		local name_args=${name_args%'-o '}

		# Find all video files in the directory and process them.
		eval "find \"$input\" -type f \( $name_args \) -maxdepth \"$depth\"" | while IFS= read -r file; do
			process_video "$file"
		done

	elif [[ -f "$input" ]]; then

		# Convert formats string to array.
		for format in "${format_array[@]}"; do
			# Check if the input file's extension matches the current format.
			if [[ "$input" == *."$format" ]]; then
				e "\nVideo found: $(b "$(bb "$(basename "$input")")")"
				e "\nCurrent settings:"
				printSettings

				askFirst

				# e "Processing \"$(basename "$input")\""
				process_video "$input"
				break
			fi
		done
	else
		e "Invalid input. Please provide a valid directory or file path."
		return 1
	fi

	e ""
	e "$(g "All done! 🎉")"

	if [[ "$OSTYPE" == "darwin"* ]]; then
		osascript -e "display notification \"All done! 🎉\" with title \"Quish\" sound name \"Glass\""
	fi
}
