# Syllabus AI Agent — Google Gemini Edition

A local-first web app prototype that accepts a syllabus PDF and pasted student email, then asks Google Gemini to either suggest a syllabus-supported draft or flag the question for human review.

## What it does
- Runs locally on your computer and opens in your browser.
- Extracts selectable text from a PDF syllabus.
- Analyzes a pasted email using the Google Gemini API.
- Displays a suggested draft, a reason, and syllabus evidence.
- Does **not** connect to Gmail, store messages in a database, or send emails.

## Start on a Mac
1. Extract the ZIP file.
2. Open the extracted `syllabus-ai-agent-gemini` folder.
3. Double-click `Start Syllabus AI Agent.command`.
4. On first run, it installs dependencies and prompts for your Gemini API key. Paste the key from Google AI Studio. The key is entered invisibly in Terminal.
5. The app opens at http://127.0.0.1:8000. Keep Terminal open while using it; press Control+C to stop.

If the app does not prompt for a key, open Terminal in this folder and run `nano .env`. Set `GEMINI_API_KEY` to your exact key and leave `GEMINI_MODEL=gemini-3.8-flash` unless you need to choose another model available to your account. Restart the app after changing `.env`. Do not add a prefix or alter the key; paste it exactly as Google AI Studio provided it.

## Manual setup
Requires Python 3.10+ and internet access.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env and add your Gemini API key
uvicorn app:app --reload
```

## Security and limitations
- This is a prototype, not a production-ready email agent.
- The PDF text and pasted email are sent to Google Gemini for analysis. Check Google's current data-use and pricing terms before processing real student information.
- Do not upload sensitive student records unless you are authorized to process them. Use fictional examples for testing.
- The app does not send emails and does not integrate with Gmail or Outlook. Review every suggestion before using it.
- Scanned PDFs without selectable text are not supported.
- The AI can make mistakes; verify policies and deadlines against the syllabus.
- Keep `.env` and API keys out of GitHub and screenshots.

Create/manage a Gemini API key in [Google AI Studio](https://aistudio.google.com/apikey). The default model is `gemini-3.8-flash`; model availability and free-tier limits can vary by account and region. Check AI Studio's usage dashboard if you receive a quota error.
