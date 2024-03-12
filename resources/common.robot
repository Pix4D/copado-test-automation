*** Settings ***
Library                         QWeb
Library                         String
Library                         FakerLibrary


*** Variables ***

${url_dev}                      https://dev.cloud.pix4d.com



*** Keywords ***
CreateRandomPersonData
    [Documentation]             This will create a random person with first_name, last_name, email, password
    ${fake_first_name}=         FakerLibrary.first_name
    Set Suite Variable          ${fake_first_name}
    ${fake_last_name}=          FakerLibrary.last_name
    Set Suite Variable          ${fake_last_name}
    ${fake_email}=              FakerLibrary.email          domain=pix4d.work
    Set Suite Variable          ${fake_email}
    ${fake_password}=           FakerLibrary.Password
    Set Suite Variable          ${fake_password}
    Log To Console              Created user: ${fake_first_name}, ${fake_last_name}, ${fake_email}, ${fake_password}
    Return From Keyword

Fill User Form And Verify
    [Documentation]             Fill the user form and verify 'Billing info'. Retry up to 3 times if verification fails.
    ${retries}=                 Set Variable                3
    FOR                         ${index}                    IN RANGE                    ${retries} # with varibale not working
        CreateRandomPersonData
        GoTo                    ${url_dev}/admin_panel/pixuser/new/
        VerifyText              New User
        Type Text               id_first_name               ${fake_first_name}
        Type Text               Last name                   ${fake_last_name}
        Type Text               Email address               ${fake_email}
        Type Text               Password                    ${fake_password}
        Type Text               Password confirmation       ${fake_password}
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
    GoTo                        ${url_dev}/admin_panel/pixuser/new/
    Sleep                       3
    Fill User Form And Verify
    Refresh Page
    VerifyAll                   ${fake_email}, Profile info
    ${fake_user_url}            GetUrl
    Set Suite Variable          ${fake_user_url}
    Log To Console              ${fake_user_url}
    # ${email_address}=         GetAttribute                id_email                    tag=input                   attribute=value
    # Set Suite Variable        ${email_address}
    # Log To Console            ${email_address}
    # GoTo                      https://dev.cloud.pix4d.com/admin_panel/pixuser/813952/edit/
    ${example_string}=          Set Variable                Hello, World!
    ${uppercase_string}=        Convert To Uppercase        ${example_string}
    Log To Console              ${uppercase_string}
    ${full_uuid_text}           GetText                     //div[contains(@class, 'mdl-cell-full') and contains(., 'UUID:')]
    Log To Console              ${full_uuid_text}
    @{split_text}=              Split String                ${full_uuid_text}           UUID:
    Log To Console              @{split_text}
    ${fake_user_uuid}=          Strip String                ${split_text}[1]
    Log To Console              ${fake_user_uuid}

    # ${fake_user_uuid}         Fetch From Right            ${full_uuid_text}           UUID:
    Log To Console              ${fake_user_uuid}

    Set Suite Variable          ${fake_user_uuid}
    Log To Console              ${fake_user_uuid}
    TypeText                    id_comment                  TEST_CXOps_QA
    ClickText                   SAVE PROFILE


GDPR_Deletion
    [Documentation]             GDPR deletion of the test pixuser
    GoTo                        ${fake_user_url}
    VerifyText                  ${fake_email}
    VerifyAll                   ${fake_email}, Profile info
    ClickText                   GDPR Deletion               tag=button
    CloseAlert                  accept                      10s
    VerifyText                  Account disabled upon GDPR request from data subject

