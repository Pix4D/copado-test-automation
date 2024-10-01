*** Settings ***
Documentation                   E2e test for Partner and Account UI
Suite Setup                     Open Browser                about:blank     ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot
Library                         QWeb



*** Variables ***
${BROWSER}                      chrome


*** Test Cases ***
Partner_and_Account_UI_check
    [Documentation]             Partner and Account app UI element test
    [Tags]                      ci, Account, Partner
    Log                         Partner and Account UI Test Starting        console=True
    # login to partner page
    EUM_User_Login_To_Partner_Dev
    # Home Check
    Organization_Dashboard_Page_Check
    # Invoices
    Invoice_Page_Check
    # Store products
    Product_Store_Page_Check
    # Organization managements
    Organization_Settings_Page_Check
    # Org member
    User_Management_Page_Check
    # Licenses
    Licenses_Page_Check
    # Vouchers list
    Vouchers_Page_Check
    # Account switcher test
    Account_Switcher_Test
    # Switch to account and verify home page
    Switch_To_Account_App_Verify_Home_Page
    # Privacy
    Privacy_Page_Check
    # Notifications
    Notification_Page_Check
    # Account settings
    Account_Settings_Page_Check
