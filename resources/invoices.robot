*** Settings ***
Library                   QWeb
Library                   String


*** Keywords ***
CreateInvoice
    [Documentation]       Create invoice for user's license
    [Arguments]           ${email_address}            ${license_key}              ${product_key}    ${product_description}
    GoTo                  ${url}/admin_panel/store/documents/invoice/new/
    DropDown              issuerSelect                PCH
    DropDown              country                     Switzerland
    TypeText              id-pix4d-contact-input      CXOps RoboticTesting
    TypeText              Company or Client Name      ${email_address}
    TypeText              trumbowyg-editor            CXOps RoboticTesting
    ${invoice_product}    Catenate                    ${product_description} [${product_key}]
    Log To Console        ${invoice_product}
    DropDown              product-description         ${invoice_product}
    TypeText              license id/sn               ${license_key}
    ClickText             ${license_key}              anchor=2
    ClickText             Save
