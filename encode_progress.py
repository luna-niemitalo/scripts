#!/usr/bin/env python3
import subprocess
import sys
import re
import shlex
from tqdm import tqdm


def get_total_frames(ffmpeg_path, input_path):
    """Get total frames from ffprobe."""
    cmd = [
        ffmpeg_path + "ffprobe",
        "-v", "error",
        "-select_streams", "v:0",
        "-count_packets",
        "-show_entries", "stream=nb_read_packets",
        "-of", "csv=p=0",
        input_path,
    ]
    try:
        #result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
        #total_frames = result.stdout.strip()
        #if total_frames == "N/A" or total_frames == "":
            #return None
        return int(338832)
    except Exception as e:
        print(f"Error getting total frames: {e}")
        return None

def run_ffmpeg_pass(ffmpeg_path, input_path, output_path, pass_num, total_frames, common_opts, extra_opts):
    """
    Run a single ffmpeg pass with progress parsed to tqdm.
    pass_num: 1 or 2
    """
    print(f"Starting pass {pass_num}...")

    cmd = [
        ffmpeg_path + "ffmpeg",
        "-hide_banner",
        "-y",
        "-i", input_path,
    ]

    # Add common video options
    cmd.extend(shlex.split(common_opts))

    # Add pass number specific options
    cmd.extend(shlex.split(extra_opts))

    # Output file for pass 1 is null, for pass 2 is actual output
    if pass_num == 1:
        cmd.extend(["-pass", "1", "-an", "-f", "null", "/dev/null"])
    else:
        cmd.extend(["-pass", "2", "-c:a", "copy", "-c:s", "copy", "-map", "0", output_path])

    # Ensure progress pipe to stdout
    cmd.extend(["-progress", "pipe:1"])

    print(f"Running: {' '.join(cmd)}")

    pbar = None
    if total_frames:
        pbar = tqdm(total=total_frames, unit="frames")

    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, bufsize=1)

    frame_regex = re.compile(r"frame=(\d+)")

    postfix_dict = {}


    #frame = 1560
    #fps = 3.78
    #stream_0_0_q = 20.6
    #bitrate = N / A
    #total_size = N / A
    #out_time_us = 64981583
    #out_time_ms = 64981583
    #out_time = 00:01: 04.981583
    #dup_frames = 0
    #drop_frames = 0
    #speed = 0.158


    try:
        for line in process.stdout:
            line = line.strip()
            if line.startswith("speed="):
                speed = line.split('=')[1]
                postfix_dict['speed'] = speed
                if pbar:
                    pbar.set_postfix(postfix_dict, refresh=False)
            if line.startswith("stream"):
                quality = line.split('=')[1]
                postfix_dict['quality'] = quality
                if pbar:
                    pbar.set_postfix(postfix_dict, refresh=False)
            if line.startswith("bitrate"):
                bitrate = line.split('=')[1]
                postfix_dict['bitrate'] = bitrate
                if pbar:
                    pbar.set_postfix(postfix_dict, refresh=False)
            if line.startswith("frame="):
                m = frame_regex.match(line)
                if m and pbar:
                    current_frame = int(m.group(1))
                    pbar.n = current_frame
                    pbar.refresh()
            elif line.startswith("progress=") and line.split('=')[1] == "end":
                if pbar:
                    pbar.n = total_frames
                    pbar.refresh()
                    pbar.close()
                break
        # Wait for process to end to collect stderr and check errors
        process.wait()
        stderr = process.stderr.read()
        if process.returncode != 0:
            print(f"FFmpeg pass {pass_num} exited with error code {process.returncode}")
            print(stderr)
            sys.exit(process.returncode)
    except KeyboardInterrupt:
        process.terminate()
        if pbar:
            pbar.close()
        print("\nEncoding interrupted.")
        sys.exit(1)


def main():
    if len(sys.argv) < 3:
        print("Usage: encode_4k_bluray.py input_path output_path")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]
    ffmpeg_path = '/home/luna/ffmpeg_sources/ffmpeg/'

    print(f"Using ffmpeg at: {ffmpeg_path}")

    total_frames = get_total_frames(ffmpeg_path, input_path)
    if total_frames is None:
        print("Warning: Could not determine total frames; progress bar disabled.")
    else:
        print(f"Total frames in input: {total_frames}")

    # Common video encoding options (same for both passes)
    common_video_opts = (
        "-vf yadif,format=yuv420p "
        "-c:v libx265 "
        "-preset slow "
        "-g 48 -keyint_min 48 -sc_threshold 0 -bf 3 "
        "-crf 18 -b:v 0 "
        "-loglevel warning "
        "-threads 16 "
        "-x265-params psy-rd=2.0:aq-mode=3"
    )

    # Pass-specific options are handled inside run_ffmpeg_pass

    # Run two-pass encoding
    run_ffmpeg_pass(ffmpeg_path, input_path, output_path, pass_num=1, total_frames=total_frames, common_opts=common_video_opts, extra_opts="")
    run_ffmpeg_pass(ffmpeg_path, input_path, output_path, pass_num=2, total_frames=total_frames, common_opts=common_video_opts, extra_opts="")

    print("Encoding finished successfully!")

if __name__ == "__main__":
    main()