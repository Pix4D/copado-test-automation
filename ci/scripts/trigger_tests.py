
# THIS PART will be updated.

import requests
import time

def trigger_test_suite(test_name, crt_api_key, crt_api_url):
    payload = {
        "key": crt_api_key,
        "inputParameters": [
            {"key": "-i", "value": "ci"}, # copado test tag
        ]
    }

    response = requests.post(crt_api_url, json=payload)
    build = response.json()
    
    if 'id' not in build:
        print(f"Failed to trigger test: {test_name}")
        return None

    build_id = build['id']
    status = 'executing'
    
    print(f"Triggered test: {test_name}, waiting for completion...")
    
    # Poll the status every 10 seconds
    while status == 'executing':
        time.sleep(10)
        result = requests.get(f"{crt_api_url}/{build_id}", params={"key": crt_api_key}).json()
        status = result.get('status', '')

    print(f"Test {test_name} finished with status: {status}")
    return result

def main():
    crt_api_url = "https://copado.api.url"  # Update with real URL
    crt_api_key = "YOUR_API_KEY"            # To be passed from Concourse
    test_suites = ["test1", "test2", "test3"]  # Add your test suite names

    for test in test_suites:
        result = trigger_test_suite(test, crt_api_key, crt_api_url)
        if result is not None and result.get('failures', 0) > 0:
            print(f"Test {test} failed!")
            return 1  # Indicate failure to Concourse pipeline

    print("All tests finished successfully!")
    return 0

if __name__ == "__main__":
    main()
