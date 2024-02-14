*** Settings ***

Documentation              Admin panel user journay test suite
Library                    QWeb
Suite Setup                Open Browser                about:blank       chrome
Suite Teardown             Close All Browsers
Resource                   ../resources/common.robot
Resource                   ../resources/licenses.robot
Resource                   ../resources/invoices.robot

*** Variables ***
${product_key}             MAPPER-OTC1-DESKTOP
${product_description}     PIX4Dmapper Desktop, Single device, Perpetual license

*** Keywords ***
Initialize Suite Variables
    Set Suite Variable    ${product_key}    MAPPER-OTC1-DESKTOP
    Set Suite Variable    ${product_description}    PIX4Dmapper Desktop, Single device, Perpetual license

*** Test Cases ***
User journay
    LoginApp
    CreateUser
    Hubspot sync verify    ${my_user_url}
    CreateLicense          ${email_address}    ${my_user_url}    ${product_key}    ${product_description}
    CreateInvoice          ${email_address}    ${license_key}    ${product_key}    ${product_description}
    GDPR_Deletion
