#!/bin/bash

# Function to switch the audio sink
switch_audio_sink() {
  # pactl list short sinks
    laptop_sink="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.stereo-fallback"
    headphones_sink="bluez_output.80_C3_BA_58_A4_09.1"
    earbuds_sink="bluez_output.AC_3E_B1_A2_31_A1.1"

    # Check the input argument and set the new_sink variable
    case "$1" in
        laptop)
            new_sink="$laptop_sink"
            ;;
        headphones)
            new_sink="$headphones_sink"
            ;;
        earbuds)
            new_sink="$earbuds_sink"
            ;;
        *)
            echo "Invalid argument. Please use 'laptop', 'headphones', or 'earbuds'."
            exit 1
            ;;
    esac

    # Set the default sink
    pactl set-default-sink "$new_sink"

    # Move all existing audio streams to the new sink
    pactl list short sink-inputs | while read stream; do
        stream_id=$(echo $stream | cut -f1)
        pactl move-sink-input "$stream_id" "$new_sink"
    done

    echo "Audio switched to $1."
    notify-send "Audio switched to $1."
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [laptop|headphones|earbuds]"
    exit 1
fi

# Call the function with the provided argument
switch_audio_sink "$1"

