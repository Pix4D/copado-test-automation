from robot.libraries.BuiltIn import BuiltIn

class CookieManager:
    def __init__(self):
        self.selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')

    def store_cookies(self):
        # Store cookies from the current session
        cookies = self.selenium_lib.get_cookies()
        return cookies

    def reapply_cookies(self, cookies, target_url):
        # Navigate to the target URL
        self.selenium_lib.go_to(target_url)
        # Reapply stored cookies
        for cookie in cookies:
            if 'domain' in cookie and 'expiry' in cookie:  # Check if 'domain' and 'expiry' are in the cookie dict to avoid errors
                self.selenium_lib.add_cookie(cookie['name'], cookie['value'], path=cookie.get('path', '/'), domain=cookie['domain'], secure=cookie.get('secure', False), expiry=cookie['expiry'])
            else:
                self.selenium_lib.add_cookie(cookie['name'], cookie['value'])
        # Refresh the page to ensure cookies are applied
        self.selenium_lib.reload_page()
