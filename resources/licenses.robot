*** Settings ***
Library                    QWeb
Library                    String


*** Variables ***
${product_key}             MAPPER-OTC1-DESKTOP
${product_description}     PIX4Dmapper Desktop, Single device, Perpetual license



*** Keywords ***

CreateLicense
    [Documentation]        Creating license: "MAPPER-OTC1-DESKTOP: PIX4Dmapper Desktop, Single device, Perpetual license"
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

    # CreateLicenseMapperOTC
    #                      [Documentation]             Create a new license
    #                      # [Arguments]               ${user}                     ${product}             ${is_paid}    ${comment}
    #                      GoTo                        ${url}/admin_panel/license/new/
    #                      DropDown                    template                    MAPPER-OTC-DESKTOP: PIX4Dmapper Desktop, Perpetual license
    #                      ClickText                   Yes
    #                      TypeText                    comment                     TEST_CXOps_QA
    #                      ClickText                   Save


    # CreateLicense2
    #                      [Documentation]             Create a new license
    #                      [Arguments]                 ${user}                     ${product}             ${is_paid}    ${comment}
    #                      GoTo                        ${url}/admin_panel/license/
    #                      ClickText                   playlist_add
    #                      # UseTable                  xpath\=//*[@id\='licenses']//table[1]
    #                      ClickElement                xpath\=//select[@data-select2-id\='id_user']/following-sibling::span
    #                      TypeText                    xpath\=//input[@class\='select2-search__field']    test
    #                      DropDown                    User                        cxops.robot@pix4d.work
    #                      ClickText                   ${is_paid}
    #                      VerifyTable                 r3c1                        ali.mengutay+
    #                      TypeText                    /html[1]/body[1]/span[1]/span[1]/span[1]/input[1]    cxops.robot@pix4d.work
    #                      DropDown                    template                    ${product}
    #                      ClickCell                   r7c2
    #                      TypeText                    comment                     ${comment}
    #                      ClickText                   Save
    #                      UseTable                    \n \n \n \n
    #                      VerifyTable                 r1c13                       1b718e99
