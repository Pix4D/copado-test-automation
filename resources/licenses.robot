*** Settings ***
Library                    QWeb
Library                    String


# *** Variables ***
# ${product_key}=            set Variable              MAPPER-OTC1-DESKTOP
# ${product_description}=    set Variable              PIX4Dmapper Desktop, Single device, Perpetual license


*** Keywords ***
CreateLicense
    [Documentation]        Creating license: "MAPPER-OTC1-DESKTOP: PIX4Dmapper Desktop, Single device, Perpetual license"
    [Arguments]            ${email_address}    ${my_user_url}    ${product_key}    ${product_description}
    VerifyText             ${email_address}
    Log To Console         ${email_address}    ${my_user_url}    ${product_key}    ${product_description}
    ClickText              playlist_add              # clicks license create button
    ${license_product}=    Set Variable              ${product_key}: ${product_description}
    Log To Console         ${license_product}
    DropDown               Product code              ${license_product}          # DropDown template
    ClickText              Yes
    TypeText               comment                   TEST_CXOps_QA
    ClickText              Save
    GoTo                   ${my_user_url}            # back to user page
    VerifyText             Product key               # ScrollText                Add-Ons can be use
    UseTable               ID
    ClickCell              r1c1                      # Go license page
    ${license_key}         GetText                   //a[@title\='Download Licence']
    Set Suite Variable     ${license_key}
    Log To Console         ${license_key}
    ${license_page_url}    GetUrl
    Set Suite Variable     ${license_page_url}
    Log To Console         ${license_page_url}

