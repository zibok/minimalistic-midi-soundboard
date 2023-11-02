#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <midi-client> [<pipewire-sink-name>]"
  echo "  - <midi-client>: name of the client shown by aseqdump -l"
  echo "  - <pipewire-sink-name>: name of the sink to send sound to (defaults: media)"
fi

MIDI_CLIENT="$1"
PIPEWIRE_SINK_NAME="${2:-media}"

PROJECT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${PROJECT_DIR}/midi-soundboard.cfg"

launch_sound() {
  midi_channel=${1}
  midi_key_id=${2}

  file="${soundMapping["${midi_channel}-${midi_key_id}"]}"
  [ "${file}" == "" ] && return

  volume="${volumeMapping["${midi_channel}-${midi_key_id}"]}"
  volume="${volume:-1,0}"

  pw-play --target "${PIPEWIRE_SINK_NAME}" "$file" --volume="$volume"
}

aseqdump -p "${MIDI_CLIENT}" |
{
  # We ignore the first two lines of aseqdump output
  # Like
  #   Waiting for data. Press Ctrl+C to end.
  #   Source  Event                  Ch  Data
  read
  read
  while IFS=" ," read source event_type event_on_off channel control_type key_id velocity_label velocity_value dont_care_the_rest_of_the_line
  do
    [ "${event_type} ${event_on_off}" == "Note on" ] && launch_sound "${channel}" "${key_id}"
  done
}
