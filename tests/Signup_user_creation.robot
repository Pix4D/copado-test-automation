*** Settings ***
Documentation                   E2e test for 2Checkout purchase flow
Suite Setup                     Open Browser                about:blank     ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot
Library                         QWeb
Library                         String
Library                         FakerLibrary

*** Variables ***
${BROWSER}                      chrome



*** Test Cases ***
Signup_user_creation_test
    [Documentation]             New Partner portal e2e test flow
    [Tags]                      ci                          signup          # tags not case sensitive, you can use multiple.
    Log                         Signup user creation test starting          console=True

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
    Account_Deletion_Rondom_User
