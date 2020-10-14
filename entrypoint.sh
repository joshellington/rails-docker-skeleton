#!/bin/bash
# entrypoint.sh

set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# DB stuff
echo "Prepare db..."
bundle exec rails db:prepare

# Prod asset compile
echo "Precompiling assets..."
bundle exec rake assets:precompile

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"