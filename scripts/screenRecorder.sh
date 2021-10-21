#!/usr/bin/env bash
set -x

# Ensure we're not using the wayland backend on SDL
unset SDL_VIDEODRIVER

# geometry=$(geometry) || exit $?
# wf-recorder -c rawvideo --geometry="$geometry" -m sdl -f pipe:wayland-mirror
# wf-recorder --geometry="$geometry" -m v4l2 -c rawvideo -f /dev/video$videoNr -x yuv420p


# Alternative method via ffplay
# wf-recorder -c rawvideo --geometry="$geometry" -x yuv420p -m avi -f pipe:99 99>&1 >&2 | ffplay -f avi - &
# wf-recorder --muxer=v4l2 --codec=rawvideo --geometry="$geometry" -x yuv420p  -f /dev/video$videoNr
wf-recorder
