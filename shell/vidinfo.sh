#!/bin/zsh

#? pretty-print video metadata

function vidinfo() {

	local dir_to_search="${1:-.}"

	find "$dir_to_search" -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" -o -name "*.flv" -o -name "*.mov" -o -name "*.webm" \) | while read -r video_file; do
		local file_size=$(du -sh "$video_file" | cut -f1)

		local resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$video_file")

		local fps=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$video_file")

		local bitrate=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$video_file")
		local bitrate_kb=$(echo "scale=2; $bitrate/1000" | bc) # scale=2; for rounding up to 2 decimal places

		local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file")
		local duration=$(echo "$duration" | awk '{printf "%02d:%02d:%02d\n",int($1/3600),int($1/60%60),int($1%60)}')

		dim "------------------------------------"
		echo "$(b File)     $video_file"
		echo "$(b Size)     $file_size"
		echo "$(b Res)      $resolution"
		echo "$(b FPS)      $fps"
		echo "$(b Bitrate)  ${bitrate_kb} kb/s"
		echo "$(b Length)   $duration"
	done
}
