# Minimalistic MIDI soundboard for Linux

This project aims to offer a very very basic MIDI soundboard
based on Pipewire and ALSA tools.

## Pre-requisite

* `aseqdump`
* `pw-play`

## Configuration

Copy `midi-soundboard.cfg.example` as `midi-soundboard.cfg` and configure it

## Run

```bash
./midi-soundboard.sh <name-of-your-midi-client> [<pipewire-sink-name>]
```

Where `<name-of-your-midi-client>` is the one listed by `aseqdump -l` as `Client name`

and `<pipewire-sink-name>` is the sink to use for sound sending (defaults to `media`)
