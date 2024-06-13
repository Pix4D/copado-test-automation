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

    # -------------EUM redirection-----
    # 1. Create EUM redirection user test user
    # Keep credetial save test leve
    # Logged in as eum user
    EUM_User_Login_To_Staging_AP


    # redirect credits and verify org selection is availbale
    Redirect_Credit_And_Verify_Org_Selection

    # redirect donwload and verify org selection is available
    Redirect_Download_And_Verify_Org_Selection

    # Select org and verify credit page component  
    Select_Org_and_Verify_Credit_Page_Component
    
    # Verify dowload page component
    Verify_Download_Page_Component
    
    


    # ------------------------------
    # ------------------------------

    # Create your account email
    Fill_User_Email_And_Verify

    # Create your account personal info
    Fill_User_Form_And_Verify

    # We take your data very seriously
    Fill_Communication_Preference

    # login AP staging with Test user
    Robot_Login_To_Staging_AP

    # Find created user in staging
    Find_The_User
    
    # GDPR deletion of the test user
    GDPR_Deletion_Rondom_User

    # Test Webhook with TRY except
