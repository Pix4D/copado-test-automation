*** Settings ***
Library                    QWeb
Library                    String


*** Variables ***
${product_key}             MAPPER-OTC1-DESKTOP
${product_description}     PIX4Dmapper Desktop, Single device, Perpetual license


*** Keywords ***

CreateLicense
    [Documentation]        Creating license: "MAPPER-OTC1-DESKTOP: PIX4Dmapper Desktop, Single device, Perpetual license"
    [Arguments]            ${email_address}    ${my_user_url}
    VerifyText             ${email_address}
    Set Suite Variable     ${product_key}
    Log To Console         ${product_key}
    Set Suite Variable     ${product_description}
    Log To Console         ${product_description}
    ClickText              playlist_add                # clicks license create button
    DropDown               Product code                ${product_key}: ${product_description}             # DropDown template
    ClickText              Yes
    TypeText               comment                     TEST_CXOps_QA
    ClickText              Save
    GoTo                   ${my_user_url}              # back to user page
    VerifyText             Product key                 # ScrollText                Add-Ons can be use
    UseTable               ID
    ClickCell              r1c1                        # Go license page
    ${license_key}         GetText                     //a[@title\='Download Licence']
    Set Suite Variable     ${license_key}
    Log To Console         ${license_key}
    ${license_page_url}    GetUrl
    Set Suite Variable     ${license_page_url}
    Log To Console         ${license_page_url}

