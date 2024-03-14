# data_helpers.py
from faker import Faker
from faker.providers import BaseProvider

class SafePasswordProvider(BaseProvider):
    def safe_password(self, length=10, special_chars=True, digits=True, upper_case=True, lower_case=True):
        password = self.generator.password(length=length, special_chars=special_chars, digits=digits, upper_case=upper_case, lower_case=lower_case)
        while password.startswith('${'):
            password = self.generator.password(length=length, special_chars=special_chars, digits=digits, upper_case=upper_case, lower_case=lower_case)
        return password

class CustomFaker:
    def __init__(self):
        self.faker = Faker()
        self.faker.add_provider(SafePasswordProvider)
    
    def first_name(self):
        return self.faker.first_name()
    
    def last_name(self):
        return self.faker.last_name()
    
    def email(self, domain="example.com"):
        return self.faker.email(domain=domain)
    
    def safe_password(self):
        return self.faker.safe_password()