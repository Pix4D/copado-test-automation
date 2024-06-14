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
Signup_user_creation_test
    [Documentation]             Account EUM redirection
    [Tags]                      signup
    Log                         Signup user creation test starting                 console=True
    TRY
        # Login with eum user account to staging
        EUM_User_Login_To_Staging_AP

        # redirect credits and verify org selection is availbale
        Redirect_Credit_And_Verify_Org_Selection

        # Select org and verify credit page component  
        Select_Org_and_Verify_Credit_Page_Component
    
        # redirect donwload and verify org selection is available
        Redirect_Download_And_Verify_Org_Selection

        # Verify dowload page component
        Download_Page_Component
        # gc_notification message_succes
        Log To Console              Success!
           
    EXCEPT
        Log To Console              Failed
        # gc_notification message_faile
    END

    