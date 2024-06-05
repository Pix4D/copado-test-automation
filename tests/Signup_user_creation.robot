*** Settings ***
Documentation                   E2e test for 2Checkout purchase flow
Suite Setup                     Open Browser                about:blank                 ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot
Library                         QWeb
Library                         String
Library                         FakerLibrary

*** Variables ***
${BROWSER}                      chrome
${url_signup_dev}              https://dev.account.pix4d.com/signup


*** Test Cases ***
Signup_user_creation_test
    [Documentation]             New Partner portal e2e test flow
    [Tags]                      signup
    Log                         Signup user creation test starting                 console=True
    
    #-------------------------
    # Create your account email
    # name CXOps TestAutomation
    # Email: uuid                 
    # User uuid to      



    # Create your account personal info


    # We take your data very seriously


    # login AP staging with Test user


    # GDPR deletion of the test user


    # Test Webshook with TRY except

    #-------------------------
 

