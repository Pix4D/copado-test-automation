from robot.libraries.BuiltIn import BuiltIn

class CookieManager:
    def __init__(self):
        self.selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary

')

    def transfer_cookies(self, source_url, target_url):
        self.selenium_lib.open_browser(source_url, browser='chrome')
        cookies = self.selenium_lib.get_cookies()
        self.selenium_lib.go_to(target_url)
       

 for cookie in cookies:
            self.selenium_lib.add_cookie(cookie['name'], cookie['value'])
        # Optionally, after setting cookies, you might want to refresh the page to ensure the cookies take effect.
        self.selenium_lib.reload_page()