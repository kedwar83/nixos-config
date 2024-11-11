#!/usr/bin/env bash

# Wait for input-remapper services to be ready - check every 0.5s
while ! systemctl is-active input-remapper.service; do
  sleep 0.5
done

sleep 1 # Added small delay to ensure service is fully ready

input-remapper-control --command stop-all
sleep 0.5 # Added small delay between commands
input-remapper-control --command autoload

# Check for success
if ! input-remapper-control --command is-active; then
  # Retry if failed
  sleep 1 # Reduced from 2s to 1s
  input-remapper-control --command stop-all
  sleep 0.5 # Added small delay between commands
  input-remapper-control --command autoload
fi

