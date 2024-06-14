*** Settings ***
Documentation                   E2e test EUM redirection
Suite Setup                     Open Browser                about:blank                 ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot
Library                         QWeb
Library                         String
# Library                         FakerLibrary

*** Variables ***
${BROWSER}                      chrome



*** Test Cases ***
Signup_user_creation_test
    [Documentation]             Account EUM redirection
    [Tags]                      signup
    Log                         Signup user creation test starting                 console=True
    # Login with eum user account to staging
    EUM_User_Login_To_Staging_AP

    # redirect credits and verify org selection is availbale
    Redirect_Credit_And_Verify_Org_Selection

    # redirect donwload and verify org selection is available
    Redirect_Download_And_Verify_Org_Selection

    # Select org and verify credit page component  
    Select_Org_and_Verify_Credit_Page_Component
    
    # Verify dowload page component
    Verify_Download_Page_Component
    