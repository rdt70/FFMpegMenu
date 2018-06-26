To install on a different path: Install <path> 

Copy a stream
ffmpeg -i rtmp://source.com/live/stream -c copy -flags +global_header -f segment -segment_time 60 -segment_format_options movflags=+faststart -reset_timestamps 1 test%d.mp4
