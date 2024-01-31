*** Settings ***
Library                QWeb
Library                String

*** Keywords ***
Add Invoice
    [Documentation]    This is used for creating a new Invoice
    [Arguments]        ${commerce_type}            ${issuer}              ${customer_country}    ${reference_document}    ${product}
    GoTo               ${url}/admin_panel/store/documents/invoice/
    ClickText          playlist_add
    UseTable           xpath\=//*[@id\='invoiceBody']/table[1]
    ClickText          ${commerce_type}
    DropDown           issuer                      ${issuer}
    DropDown           country                     ${customer_country}
    ScrollTo           Billable
    DropDown           Product                     ${product}
