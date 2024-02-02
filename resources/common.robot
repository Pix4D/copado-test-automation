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
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              20s                         #sometimes salesforce is slow
    SetConfig                   CaseInsensitive             True


LoginApp
    GoTo                        ${url}/admin_panel/
    TypeText                    Email*                      ${username} 
    ClickText                   Continue                   
    TypeText                    Username:                   ${username}
    VerifyText                  Log in
    TypeText                    Enter password              ${password}
    ClickText                   Log in                      anchor=Back    index=2


CreateRandomPerson
    [Documentation]             This will create a random person with first_name, last_name, email
    ${fake_first_name}          FakerLibrary.first_name
    Set Suite Variable          ${fake_first_name}
    ${fake_last_name}           FakerLibrary.last_name
    Set Suite Variable          ${fake_last_name}
    ${fake_email}               FakerLibrary.email
    Set Suite Variable          ${fake_email}
    Log To Console              Created user: + ${fake_first_name} + , + ${fake_last_name} + , + ${fake_email}

CreateUser
    [Documentation]             This will create a new user in the Pix4D application
    CreateRandomPerson
    GoTo                        ${url}/admin_panel/pixuser/new/
    TypeText                    First name                  ${fake_first_name}
    TypeText                    Last name                   ${fake_last_name}
    TypeText                    Email address               ${fake_email}
    TypeText                    Password                    ${user_password}
    TypeText                    Password confirmation       ${user_password}
    ClickText                   SAVE
    VerifyText                  Billing info
    RefreshPage
    ClickText                   HubSpot
    # VerifyText                HubSpot ID
    ${hubspot_id}               GetText                     //*[@title\='Go user page in HubSpot']
    Log To Console              ${hubspot_id}
    Set Suite Variable          ${hubspot_id}

SignupUser
    Setup Browser
    [Documentation]             This flow will create user from sign up flow
    GoTo                        https://dev.account.pix4d.com/signup
    TypeText    First Name *    ali
    TypeText    Last Name *    test
    TypeText    Email *    demo@test.cooom
    TypeText    Password *     ;jfsd9wef-0qwef
    ClickText    Country *    
    ClickText    Israel
    TypeText    Company *      Alitech  
    ClickText    Industries *
    ClickText    Education
    PressKey     Education      {ESCAPE}
    ClickElement    //input[@id\="mat-checkbox-1-input"]
    ClickElement    //input[@id\="mat-checkbox-2-input"]
    ClickText       Continue

    
    
    