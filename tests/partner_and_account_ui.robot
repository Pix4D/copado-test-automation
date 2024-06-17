*** Settings ***
Documentation                   E2e test EUM redirection
Suite Setup                     Open Browser                about:blank                 ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot
Library                        ../Libraries/gc_notification.py
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
    
    # Create user, migrate to pandora, convert org to partner 
    # Save env variables
    # login to partner page


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
     
