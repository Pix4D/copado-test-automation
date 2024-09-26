*** Settings ***
Library                QWeb

*** Variables ***
${partner_base_url}    https://dev.partner.pix4d.com
${partner_home_url}    https://dev.partner.pix4d.com/organization/be69b1d6-df2a-49f6-aa44-8fac0f90d6cf/home
${partner_org_name}    TestCXops UI Test
${user_fullname}       TestCXops UI
${home_page_text}      Manage your orders, buy more products and check the licenses bought


*** Keywords ***
EUM_User_Login_To_Partner_Dev
    [Documentation]    Robot loging to staging Admin Panel
    GoTo               ${partner_home_url}         timeout=5
    TypeText           Enter email                 ${ui_test_username}
    ClickText          Continue
    VerifyText         Log in
    TypeText           Enter password              ${ui_test_password}
    ClickText          Log in                      anchor=Back

Organization_Dashboard_Page_Check
    VerifyText         ${partner_org_name}
    VerifyText         ${home_page_text}

Invoice_Page_Check
    ClickText          Invoices                    anchor=Organization dashboard
    VerifyText         Invoices                    anchor=No invoices found for this account

Product_Store_Page_Check
    ClickText          Product store               anchor=User management
    VerifyText         All products                anchor=Desktop

User_Management_Page_Check
    ClickText          User management             anchor=Product store
    UseTable           //*[@data-test\='table']
    VerifyTable        r1c2                        ${user_fullname}
    VerifyTable        r1c3                        ${ui_test_username}

Organization_Settings_Page_Check
    ClickText          Organization settings       anchor=User management
    VerifyAll          Organization Logo, Legal owner, Data protection officer              # replace "Organization Logo" with "My organization"

Licenses_Page_Check
    ClickText          Licenses                    anchor=Organization settings
    VerifyText         Licenses                    anchor=Filters
    UseTable           //*[@data-test\='desktopTable']
    VerifyColHeader    License key
    VerifyColHeader    Software code
    VerifyColHeader    Creation date
    VerifyColHeader    Activation date
    VerifyColHeader    Owner
    VerifyColHeader    Terms of service

Vouchers_Page_Check
    ClickText          Vouchers                    anchor=Licenses
    VerifyText         Vouchers                    anchor=Redeem status

Account_Switcher_Test
    ClickText          ${partner_org_name}         anchor=Owner
    ClickText          ${user_fullname}            anchor=TU
    VerifyText         Your partner organizations
    VerifyText         ${partner_org_name}         anchor=Name

Switch_To_Account_App_Verify_Home_Page
    ClickElement       //*[@data-test\='icon-user_circle']
    ClickText          Account Settings            anchor=Logout
    VerifyText         Home                        anchor=3rd party integrations            timeout=3
    VerifyText         Welcome, ${user_fullname}
    VerifyAll          Collaborate with others, Protect your data

Privacy_Page_Check
    ClickText          Privacy                     anchor=Notifications
    VerifyAll          Communication preferences, Analytics                    timeout=3

Notification_Page_Check
    ClickText          Notifications               anchor=Privacy

Account_Settings_Page_Check
    ClickText          Account settings            anchor=Notifications
    VerifyAll          Personal information, Personal preference

