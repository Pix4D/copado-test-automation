*** Settings ***
Library                        QWeb
Library                        String
Library                        FakerLibrary


*** Variables ***
${url_dev}                     https://dev.cloud.pix4d.com
${url_account_dev}             https://dev.account.pix4d.com
${email_domain}                pix4d.work
${country}                     Switzerland
${company_name}                CXOps_TEST_AUTOMATION
${industries}                  Engineering



*** Keywords ***
Create_Account_Email
    [Documentation]            Create account email with Uuid4.
    ${uuid}=                   FakerLibrary.Uuid4
    Log To Console             ${uuid}
    ${user_email}=             Set Variable                ${uuid}@pix4d.work
    Log To Console             ${user_email}
    Set Suite Variable         ${user_email}

Fill_User_Email_And_Verify
    [Documentation]            Fill the user email and verify. Retry up to 3 times if verification fails.
    ${retries}=                Set Variable                3
    FOR                        ${index}                    IN RANGE                    ${retries}
        Create_Account_Email
        GoTo                   ${url_account_dev}/signup
        VerifyAll              Create your account, Email
        Type Text              Enter email                 ${user_email}
        Click Text             Continue
        ${status}=             Is Text                     First Name                  timeout=5
        IF                     ${status}
            Log To Console     Email is not in use verified.
            Return From Keyword
        ELSE
            Log To Console     Email in use or something else, retrying...
            Refresh Page
            Sleep              2                           # Wait for 2 seconds before retrying
        END
    END
    Fail                       Email registery could not be verify after: ${retries} retries.

Create_Random_User_Data
    [Documentation]            Creating random user data
    ${user_first_name}=        FakerLibrary.first_name
    Set Suite Variable         ${user_first_name}
    ${user_last_name}=         FakerLibrary.last_name
    Set Suite Variable         ${user_last_name}
    ${user_password}=          FakerLibrary.Password       special_chars=False
    Set Suite Variable         ${user_password}
    Log To Console             Created user, name: ${user_first_name} ${user_last_name}, username: ${user_email}, password: ${user_password}
    Return From Keyword

Fill_User_Form_And_Verify
    [Documentation]            Fill the user creation form and verify.
    VerifyAll                  Password, First Name
    # VerifyText               ${user_email}
    Create_Random_User_Data
    Type Text                  Password                    ${user_password}
    Type Text                  First Name                  ${user_first_name}
    Type Text                  Last Name                   ${user_last_name}
    # DropDown                 Country                     ${country}                  anchor=Country
    # DropDown                 mat-select-value-3          ${country}
    # DropDown                 //*[@id\='mat-select-value-3']                          English
    TypeText                   Company                     ${company_name}
    # DropDown                 Industries                  Engineering
    ClickText                  //*[@id\='mat-select-value-7']
    ClickText                  Engineering
    ClickText                  Software / Hardware manufacturer
    ClickText                  Create your account         doubleclick=True            # to close open dropdown
    ClickCheckbox              //*[@id\='mat-mdc-checkbox-1-input']                    on
    ClickCheckbox              //*[@id\='mat-mdc-checkbox-2-input']                    on
    Click Text                 Continue                    anchor=Back


Fill_Communication_Preference
    [Documentation]            Fill the user communication preference form and verify.
    VerifyText                 We take your data very seriously                        timeout=5
    # ClickCheckbox            Migrate to Pandora          on                          anchor=63
    ClickText                  Yes                         anchor=1
    ClickText                  Yes                         anchor=2
    # ClickText                Yes                         anchor=3
    ClickText                  Save                        anchor=Cancel
    VerifyText                 You are almost done!        timeout=5


Robot_Login_To_Staging_AP
    [Documentation]            Robot loging to staging Admin Panel
    GoTo                       ${url_dev}/admin_panel/     timeout=5
    TypeText                   Enter email                 ${robot_username}
    ClickText                  Continue
    VerifyText                 Log in
    TypeText                   Enter password              ${robot_password}
    ClickText                  Log in                      anchor=Back


Find_The_User
    [Documentation]            Find the user
    VerifyText                 Cloud Projects
    GoTo                       ${url_dev}/admin_panel/users/                           timeout=5
    ${is_user_visible}=        Run Keyword And Return Status                           VerifyText                  ${user_email}    anchor=Email
    Log To Console             ${is_user_visible}
    IF                         ${is_user_visible}
    # ${user_email}=           Set Variable                e2e-cloud+ca481be4-0f83-489d-88c1-aa7a9eaeb352@pix4d.work
    # GetTableRow              e2e-cloud+ca481be4-0f83-489d-88c1-aa7a9eaeb352@pix4d.work
    # ClickCell                r2c3
    # ClickCell                r-1c-1                      #Last row, last cell
        UseTable               USER
        ClickCell              r?${user_email}/c1          #Click cell 1 in row that contains text SomeText(${user_email})
        # ClickCell            r?Robot/c3                  Hello                       #Click cell 3 in row with words Robot and Hello in it
        # ClickCell            r1c1                        tag=a                       #Clicks first child element with a tag
        # ClickCell            r?Robot/c3                  index=2                     tag=input                   #Clicks the second child element of cell 3
        # ClickText            ${user_email}               anchor=CXOps_TEST_AUTOMATION
        VerifyAll              ${user_email}, Profile info
        # RETURN
    ELSE
        TypeText               username, name, email, company,                         ${user_email}
        ClickText              SEARCH                      anchor=country              timeout=5
        VerifyText             ${user_email}               anchor=Email
        UseTable               USER
        ClickCell              r?${user_email}/c1          anchor=1                    timeout=2
        VerifyAll              ${user_email}, Profile info
        # RETURN
    END


GDPR_Deletion_Rondom_User
    [Documentation]            GDPR deletion of the test pixuser
    # VerifyAll                ${user_email}, Profile info                             timeout=5
    ScrollTo                   Staff actions
    ClickText                  GDPR Deletion               tag=button
    CloseAlert                 accept                      10s
    VerifyText                 Account disabled upon GDPR request from data subject

Account_Deletion_Rondom_User
    [Documentation]            GDPR deletion of the test pixuser
    # VerifyAll                ${user_email}, Profile info                             timeout=5
    ScrollTo                   Staff actions
    ClickText                  Account Deletion    anchor=Disable user
    ClickText                  Delete Account      anchor=Schedule GDPR Deletion      tag=button
    CloseAlert                 accept                      10s
    VerifyText                 The account will be deleted shortly.
    RefreshPage
    VerifyText                 Account disabled upon GDPR request from data subject

