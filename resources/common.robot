*** Settings ***
Library                QWeb

*** Variables ***
${partner_base_url}    https://dev.partner.pix4d.com
${partner_home_url}    https://dev.partner.pix4d.com/organization/be69b1d6-df2a-49f6-aa44-8fac0f90d6cf/home
${partner_org_name}    TestCXops UI Test
${user_fullname}       TestCXops UI


*** Keywords ***
EUM_User_Login_To_Partner_Dev
    [Documentation]    Robot loging to staging Admin Panel
    GoTo               ${partner_home_url}         timeout=5
    TypeText           Enter email                 ${ui_test_username}
    ClickText          Continue
    VerifyText         Log in
    TypeText           Enter password              ${ui_test_password}
    ClickText          Log in                      anchor=Back




Home_Page_Check
    VerifyText         Welcome, ${partner_org_name}

Invoice_Page_Check
    ClickText          Invoices                    anchor=Home
    VerifyText         Invoices                    anchor=No invoices found for the account

Store_Products_Page_Check
    ClickText          Store Products              anchor=Organization management
    VerifyText         All products                anchor=Desktop


Organization_Management_Page_Check
    ClickText          Organization management     anchor=Store Products
    VerifyAll          ${partner_org_name}, ${ui_test_username}


Licenses_Page_Check
    ClickText          Licenses                    anchor=Organization management
    VerifyTable        Licenses
    UseTable           Licenses


Account_Switch_Test
    ClickText          ${partner_org_name}         anchor=owner
    ClickText          ${user_fullname}            anchor=${partner_org_name}



Switch_To_Account_Verify_Home_Page
    ClickElement    //    anchor=${ui_test_username}
    ClickText       Account Settings    anchor=Logout
    VerifyText      Home                anchor=3rd party integrations
    VerifyText      Welcome, ${user_fullname}

Privacy_Page_Check
    ClickText    Privacy    anchor=Notifications
    VerifyAll    Communication preferences, Analytics

Notification_Page_Check
    ClickText    Notifications    anchor=Privacy


Account_Settings_Page_Check
    ClickText    Account settings    anchor=Notifications
    VerifyAll    Personal information, Personal preference




# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------


