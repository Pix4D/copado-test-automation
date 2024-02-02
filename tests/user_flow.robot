*** Settings ***

Documentation          New test suite
Library                QWeb
Suite Setup            Open Browser                about:blank                 chrome
Suite Teardown         Close All Browsers
Resource               ../resources/common.robot
Resource               ../resources/licenses.robot
Resource               ../resources/invoices.robot

*** Test Cases ***
Create pix4d User
    [Documentation]
    [Tags]
    LoginApp
    CreateUser

Validate User exist
    [Documentation]    This will validate the user exist
    GoTo               ${url}/admin_panel/users/
    TypeText           username, name, email, company,                         Kwakman
    ClickText          SEARCH
    UseTable           xpath\=//table[@data-upgraded\=",MaterialDataTable"]
    VerifyTable        r1c6                        Kwakman


Create Invoice
    [Documentation]    Test for creating invoice
    LoginApp
    CreateLicense2      cxops.robot@pix4d.work    MAPPER-OTC-DESKTOP: PIX4Dmapper Desktop, Perpetual license    Yes    TEST_CXOps_QA
    Add Invoice        Oem    PCH - Pix4D SA (Switzerland)    Australia    ref_doc    AEC Software Bundle Yearly (PIX4Dmatic & PIX4Dsurvey & PIX4Dcloud Advanced) [MATIC-SURVEY-CLOUD-ADVANCED-YEAR]


Sign up user creation
    SignupUser

User journay
    LoginApp
    CreateUser
    ${my_user_url}    GetUrl
    Log To Console              ${my_user_url}
    ${email_address}                     GetAttribute                   id_email                        tag=input  attribute=value
    #${email_address}                     GetAttribute                  //input[@id\="id_email"]  value
    Log To Console              ${email_address}
    ClickText    playlist_add
    DropDown           Product code                      MAPPER-OTC-DESKTOP: PIX4Dmapper Desktop, Perpetual license    # DropDown           template
    ClickText          Yes
    TypeText           comment                     TEST_CXOps_QA
    ClickText          Save
    GoTo              ${my_user_url}             # back to user page
    VerifyText    Product key                      # ScrollText    Add-Ons can be use   
    UseTable    ID
    ClickCell    r2c1                        # Go license page   
    ${license_key}      GetText          //a[@title\='Download Licence']
    Log To Console    ${license_key}  
    ClickText         Create invoice
    TypeText          Company or Client Name      ${email_address}
    TypeText          license id/sn      ${license_key}
    ClickText         ${license_key}     anchor=2
    ClickText         Save
    GoTo              ${my_user_url}             # back to user page
    ClickText         GDPR Deletion
    CloseAlert                        accept      10s
    VerifyText                        Account disabled upon GDPR request from data subject 