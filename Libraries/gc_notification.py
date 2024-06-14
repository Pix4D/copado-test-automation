import requests
import time
import json

# credential will be suit level variable
CRT_API_URL = ${CRT_API_URL}
CRT_API_KEY = ${CRT_API_KEY}

# Start the build
payload = {
    "key": CRT_API_KEY,
    "inputParameters": [
        {"key": "BROWSER", "value": "firefox"}
    ]
}

response = requests.post(CRT_API_URL, json=payload)
build = response.json()
print(build)

build_id = build.get('id')
if build_id is None:
    exit(1)

print("Executing tests ", end='')
status = 'executing'

# Poll every 10 seconds until the build is finished
while status == 'executing':
    time.sleep(10)
    results = requests.get(f"{CRT_API_URL}/{build_id}", params={"key": CRT_API_KEY}).json()
    status = results.get('status', '')
    print(".", end='')

print(" done!")
failures = results.get('failures', 0)
log_report_url = results.get('logReportUrl', '')
print(f"Report URL: {log_report_url}")