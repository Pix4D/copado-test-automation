*** Settings ***
Library                QWeb
Library                String

*** Keywords ***

CreateInvoice
    [Documentation]    Create invoice for user's license
    GoTo               ${url}/admin_panel/store/documents/invoice/new/
    DropDown           issuerSelect    PCH
    DropDown           country    Switzerland
    TypeText           id-pix4d-contact-input       CXOps RoboticTesting
    TypeText           Company or Client Name      ${email_address}
    TypeText           trumbowyg-editor             CXOps RoboticTesting
    # here select product for invoice
    DropDown           Product
    TypeText           license id/sn               ${license_key}
    ClickText          ${license_key}              anchor=2
    ClickText          Save



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

