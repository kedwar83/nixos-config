#!/usr/bin/env bash

username="$1"

# Wait for user session - check every 0.5s instead of 1s for faster startup
while ! pgrep -u "$username" "plasma"; do
  sleep 0.5
done

# Start services if not running
if ! pgrep -u root "input-remapper-service" > /dev/null; then
  input-remapper-service &
fi

sleep 2 # Added small delay between services to prevent race conditions

if ! pgrep -u root "input-remapper-reader" > /dev/null; then
  input-remapper-reader-service &
fi

# Wait for services to be fully started - reduced from 5s to 3s
sleep 3

# Apply configuration
sudo -u "$username" input-remapper-control --command stop-all
sleep 1 # Added small delay between commands
sudo -u "$username" input-remapper-control --command autoload

# Keep the service running
while true; do
  if ! pgrep -u root "input-remapper-service" > /dev/null || ! pgrep -u root "input-remapper-reader" > /dev/null; then
    # Restart services if they die
    pkill -u root "input-remapper"
    sleep 0.5 # Added small delay after kill
    input-remapper-service &
    sleep 1
    input-remapper-reader-service &
    sleep 2 # Reduced from 5s to 2s
    sudo -u "$username" input-remapper-control --command stop-all
    sleep 0.5 # Added small delay between commands
    sudo -u "$username" input-remapper-control --command autoload
  fi
  sleep 5 # Reduced from 10s to 5s since we don't need to wait that long between checks
done

