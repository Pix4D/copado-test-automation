import json
import logging
import os
import time
from datetime import datetime
from json import dumps

import requests
from dotenv import load_dotenv
from httplib2 import Http

# Load environment variables from .env file if it exists (for local development)
load_dotenv()

# Logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Copado
PROJECT_ID = 48231
COPADO_PERSONAL_ACCESS_KEY = os.getenv('COPADO_PERSONAL_ACCESS_KEY')
if not COPADO_PERSONAL_ACCESS_KEY:
    raise ValueError("COPADO_PERSONAL_ACCESS_KEY is not set in the environment")

# Google Chat webhook URL
CHAT_WEBHOOK_URL = os.getenv('COPADO_CHAT_WEBHOOK_URL')
if not CHAT_WEBHOOK_URL:
    raise ValueError("COPADO_CHAT_WEBHOOK_URL is not set in the environment")

# Copado API base URL
COPADO_API_BASE_URL = os.getenv('COPADO_API_BASE_URL')
if not COPADO_API_BASE_URL:
    raise ValueError("COPADO_API_BASE_URL is not set in the environment")

# Headers
headers = {
    'X-Authorization': COPADO_PERSONAL_ACCESS_KEY,
    'Content-Type': 'application/json'
}

# Test suites
CI_TEST_SUITES = {
    "CI_Signup": 72094,
    "Failed_test_simulation": 66891,
    # "EUM_Redirection": 72653,
    # "UI_Partner-Account": 72989,
    # Add other test suites as needed
}

def send_chat_message(message_text):
    app_message = {"text": message_text}
    message_headers = {"Content-Type": "application/json; charset=UTF-8"}
    http_obj = Http()
    response = http_obj.request(
        uri=CHAT_WEBHOOK_URL,
        method="POST",
        headers=message_headers,
        body=dumps(app_message),
    )
    logger.info(f"Sent message to Google Chat: \n{message_text}")

# Iterate over each test suite
for test_name, SUITE_ID in CI_TEST_SUITES.items():
    logger.info(f"🚀 Starting test suite '{test_name}' with SUITE_ID {SUITE_ID}")

    CRT_API_URL = f"{COPADO_API_BASE_URL}/pace/v4/projects/{PROJECT_ID}/jobs/{SUITE_ID}/builds"
    
    # Start the build
    data = {
        "record": "failed"  # Setting the recording to 'fail' possible to set 'all','failed','none'
    }
    
    response = requests.post(CRT_API_URL, headers=headers, data=json.dumps(data))
    response.raise_for_status()

    build = response.json()
    build_id = build.get("data", {}).get("id")
    if not build_id:
        error_message = f"❌ No build ID found for test suite '{test_name}', skipping..."
        logger.error(error_message)
        send_chat_message(error_message)
        continue

    logger.info(f"🔢 Build ID: {build_id}")
    logger.info(f"▶️ Executing tests for '{test_name}'")

    status = "executing"
    start_time = time.time()
    timeout = 600  # 10 minutes timeout

    # Poll every 10 seconds until the build is finished or timeout
    while status == "executing" and (time.time() - start_time) < timeout:
        time.sleep(10)
        result_response = requests.get(f"{CRT_API_URL}/{build_id}", headers=headers)
        result_response.raise_for_status()
        results = result_response.json()
        status = results.get("data", {}).get("status", "unknown")
        elapsed_time = int(time.time() - start_time)
        logger.info(f"⏳ Test in progress... (Elapsed time: {elapsed_time} seconds)")

    logger.info("✅ Test execution completed")

    # Process and display results
    data = results.get("data", {})
    log_report_url = data.get("logReportUrl", "No report URL found")
    start_time = data.get("startTime")
    duration = data.get("duration")

    logger.info(f"📊 Test Execution Summary for '{test_name}':")
    logger.info(f"🏷️ Status: {status}")
    logger.info(f"🕒 Start Time: {start_time}")
    logger.info(f"⏱️ Duration: {duration} seconds")
    logger.info(f"🔗 Report URL: {log_report_url}")

    # Message based on test result
    if status == "succeeded":
        icon = "🟢"
        status_text = "PASSED"
    elif status == "failed":
        icon = "🔴"
        status_text = "FAILED"
    elif status == "executing":
        icon = "🟠"
        status_text = "TIMED OUT"
    else:
        icon = "❓"
        status_text = f"UNEXPECTED STATUS: {status}"

    message_text = f"""\
    {icon} *Test Suite Result: {status_text}*
    --------------------------------------------------
    • *Suite Name:* {test_name}
    • *Start Time:* {start_time}
    • *Duration:* {duration} seconds
    • *Status:* {status_text}

    🔗 <{log_report_url}|View Detailed Report>"""

    # Send message to Google Chat
    send_chat_message(message_text)
