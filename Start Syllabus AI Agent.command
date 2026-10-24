#!/bin/bash
set -e
cd "$(dirname "$0")"
printf '\n====================================\n'
printf '       Syllabus AI Agent (Gemini)\n'
printf '====================================\n\n'
if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 was not found. Install Python 3 from https://www.python.org/downloads/macos/ and run this file again."
  read -r -p "Press Return to close..."
  exit 1
fi
if [ ! -d ".venv" ]; then
  echo "Setting up the app environment (first run only)..."
  python3 -m venv .venv
fi
source .venv/bin/activate
echo "Installing/checking required packages..."
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
if [ ! -f ".env" ]; then cp .env.example .env; fi
if grep -q 'replace_with_your_key' .env || ! grep -q '^GEMINI_API_KEY=.' .env; then
  echo
  echo "A Google Gemini API key is needed for AI analysis."
  echo "Get one from https://aistudio.google.com/apikey"
  read -r -s -p "Paste your Gemini API key (or press Return to configure it later): " API_KEY
  echo
  if [ -n "$API_KEY" ]; then
    API_KEY="$API_KEY" python - <<'PY'
from pathlib import Path
import os
p = Path('.env')
lines = p.read_text().splitlines()
new_lines = []
found = False
for line in lines:
    if line.startswith('GEMINI_API_KEY='):
        new_lines.append('GEMINI_API_KEY=' + os.environ['API_KEY'])
        found = True
    else:
        new_lines.append(line)
if not found:
    new_lines.append('GEMINI_API_KEY=' + os.environ['API_KEY'])
p.write_text('\n'.join(new_lines) + '\n')
PY
    chmod 600 .env
  fi
fi
echo
echo "Starting the app. Keep this Terminal window open while using it."
(open http://127.0.0.1:8000 >/dev/null 2>&1 || true) &
python -m uvicorn app:app --host 127.0.0.1 --port 8000
