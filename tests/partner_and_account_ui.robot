*** Settings ***
Documentation                   E2e test for Partner and Account UI
Suite Setup                     Open Browser                about:blank                 ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot
Library                         QWeb
Library                         DateTime
Library                         



*** Variables ***
${BROWSER}                      chrome
${message_success}                Test succesful
${mesage_fail}                    Test failed


*** Test Cases ***
Partner_and_Account_UI_check
    [Documentation]             XXXXXX
    [Tags]                      XXXXXXX
    Log                         XXXXXX                 console=True
    
    # login to partner page
    EUM_User_Login_To_Partner_Dev


    # Home Check

    # Invoices 

    # Store products

    # Organization managements

    # Licenses
     
    # Switcher Check: Click user and click back

    # Switch user account page

    # Home, Privacy

    # Notifications

    # Account settings
     
