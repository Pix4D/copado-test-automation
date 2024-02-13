*** Settings ***

Documentation              Admin panel user journay test suite
Library                    QWeb
Suite Setup                Open Browser                about:blank    chrome
Suite Teardown             Close All Browsers
Resource                   ../resources/common.robot
Resource                   ../resources/licenses.robot
Resource                   ../resources/invoices.robot

*** Variables ***
${my_user_url}    
${email_address}
${license_key}    
${product_key}
${product_description}  

*** Test Cases ***
User journay
    LoginApp
    CreateUser
    Hubspot sync verify    ${my_user_url}
    CreateLicense    ${email_address}    ${my_user_url}
    CreateInvoice    ${email_address}    ${license_key}    ${product_description}     ${product_key}
    GDPR_Deletion
