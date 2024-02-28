from robot.libraries.BuiltIn import BuiltIn

class CookieManager:
    def __init__(self):
        self.selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')

    def transfer_cookies(self, target_url):
        # Assuming the browser is already opened and at the source_url with the desired cookies set
        cookies = self.selenium_lib.get_cookies()
        self.selenium_lib.go_to(target_url)
        for cookie in cookies:
            # Before adding cookies, make sure the browser is on the domain of the cookie.
            # Some browsers may restrict adding cookies if the current domain doesn't match the cookie domain.
            self.selenium_lib.add_cookie(cookie['name'], cookie['value'])
        # Refresh the page to ensure the cookies take effect.
        self.selenium_lib.reload_page()