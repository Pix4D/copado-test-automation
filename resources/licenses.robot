*** Settings ***
Library                QWeb
Library                String

*** Keywords ***
CreateLicense
    [Documentation]    Create a new license
    # [Arguments]        ${user}     ${product}    ${is_paid}       ${comment}
    GoTo               ${url}/admin_panel/license/new/
    DropDown           template                        MAPPER-OTC-DESKTOP: PIX4Dmapper Desktop, Perpetual license
    ClickText          Yes
    TypeText           comment                     TEST_CXOps_QA
    ClickText          Save
    # UseTable           \n \n \n \n
    # VerifyTable        r1c13                       1b718e99
    # ${license_key}               GetText                     //*[@title\='Download Licence']
    # Log To Console              ${license_key}
    # Set Suite Variable          ${license_key}



CreateLicense2
    [Documentation]    Create a new license
    [Arguments]        ${user}     ${product}    ${is_paid}       ${comment}
    GoTo               ${url}/admin_panel/license/
    ClickText          playlist_add
    # UseTable           xpath\=//*[@id\='licenses']//table[1]
    ClickElement       xpath\=//select[@data-select2-id\='id_user']/following-sibling::span
    TypeText           xpath\=//input[@class\='select2-search__field']         test
    DropDown           User                        cxops.robot@pix4d.work
    ClickText          ${is_paid}
    VerifyTable        r3c1                        ali.mengutay+
    TypeText           /html[1]/body[1]/span[1]/span[1]/span[1]/input[1]       cxops.robot@pix4d.work
    DropDown           template                        ${product}
    ClickCell          r7c2
    TypeText           comment                     ${comment}
    ClickText          Save
    UseTable           \n \n \n \n
    VerifyTable        r1c13                       1b718e99
