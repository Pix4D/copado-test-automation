*** Settings ***
Library                         QWeb
Library                         String
Library                         DateTime
Library                         FakerLibrary

*** Variables ***
${BROWSER}                      chrome
${first_name}                   CRT_user
${last_name}                    CRT_last
${email_address}                crt_user_test@test.com
${user_password}                crt_pass123
${hidde_test}                   FakerLibrary.email

*** Keywords ***
Setup Browser
    Set Library Search Order    QWeb
    Evaluate                    random.seed()
    Open Browser                about:blank                 ${BROWSER}
    Set Config                  LineBreak                   ${EMPTY}                    #\ue000
    Set Config                  DefaultTimeout              20s                         #sometimes salesforce is slow
    Set Config                  CaseInsensitive             True

LoginApp
    Setup Browser
    Go To                       ${url}/admin_panel/         #timeout=5
    Type Text                   Enter email                 ${username}
    Click Text                  Continue
    Verify Text                 Log in
    Type Text                   Enter password              ${password}
    Click Text                  Log in                      anchor=Back                 index=2                     # <log in> button closest to <Back> button

CreateRandomPersonData
    [Documentation]             This will create a random person with first_name, last_name, email
    ${fake_first_name}=         FakerLibrary.first_name
    Set Suite Variable          ${fake_first_name}
    ${fake_last_name}=          FakerLibrary.last_name
    Set Suite Variable          ${fake_last_name}
    ${fake_email}=              FakerLibrary.email          domain=cxops.com
    Set Suite Variable          ${fake_email}
    Log To Console              Created user: ${fake_first_name}, ${fake_last_name}, ${fake_email}

Fill User Form And Verify
    [Documentation]             Fill the user form and verify 'Billing info'. Retry up to 3 times if verification fails.
    ${retries}=                 Set Variable                3
    FOR                         ${index}                    IN RANGE                    ${retries} # with varibale not working
        CreateRandomPersonData
        Type Text               First name                  ${fake_first_name}
        Type Text               Last name                   ${fake_last_name}
        Type Text               Email address               ${fake_email}
        Type Text               Password                    ${user_password}
        Type Text               Password confirmation       ${user_password}
        Click Text              SAVE
        ${status}=              Is Text                     Billing info                timeout=5
        IF                      ${status}
            Log To Console      Billing info verified.
            Return From Keyword
        ELSE
            Log To Console      Billing info not found, retrying...
            Refresh Page
            Sleep               2                           # Wait for 2 seconds before retrying
        END
    END
    Fail                        Billing info could not be verified after: ${retries} retries.

CreateUser
    [Documentation]             This will create a new user in the Admin Panel application
    # CreateRandomPersonData
    Go To                       ${url}/admin_panel/pixuser/new/
    Fill User Form And Verify
    Refresh Page
    Set Suite Variable          ${my_user_url}             GetUrl 
    Log To Console              ${my_user_url}
    TypeText                    id_comment                  TEST_CXOps_QA
    ClickText                   SAVE PROFILE



Hubspot sync verify
    [Documentation]             This will check user hubspot sync
    GoTo                        ${my_user_url}
    Click Text                  HubSpot
    ${hubspot_id}=              Get Text                    //*[@title\='Go user page in HubSpot']
    Log To Console              ${hubspot_id}
    Set Suite Variable          ${hubspot_id}




