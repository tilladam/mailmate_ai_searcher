#!/bin/bash

# Define the binary path relative to this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN="$DIR/AIQueryTranslator"

# Prompt the user for a query using AppleScript
QUERY=$(osascript -e 'Tell application "System Events" to display dialog "Describe the messages you are looking for:" default answer "" with title "AI Mail Search"' -e 'text returned of result')

if [ -z "$QUERY" ]; then
    exit 0
fi

# Run the translator
TRANSLATED=$("$BIN" "$QUERY")

# URL encode the result using Python
ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$TRANSLATED'''))")

# Open clean search in MailMate
open "mlmt:quicksearch?string=$ENCODED"
