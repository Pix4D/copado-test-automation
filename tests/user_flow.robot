*** Settings ***

Documentation              Admin panel user journey test suite
Library                    QWeb
Suite Setup                Initialize Suite
Suite Teardown             Close All Browsers
Resource                   ../resources/common.robot
Resource                   ../resources/licenses.robot
Resource                   ../resources/invoices.robot

*** Variables ***
${product_key}             MAPPER-OTC1-DESKTOP
${product_description}     PIX4Dmapper Desktop, Single device, Perpetual license

*** Keywords ***
Initialize Suite
    Open Browser    about:blank    chrome
    Initialize Suite Variables
Initialize Suite Variables
    Set Suite Variable    ${product_key}    MAPPER-OTC1-DESKTOP
    Set Suite Variable    ${product_description}    PIX4Dmapper Desktop, Single device, Perpetual license

*** Test Cases ***
User Journey
    LoginApp
    CreateUser
    Hubspot sync verify    ${my_user_url}
    CreateLicense          ${email_address}    ${my_user_url}    ${product_key}    ${product_description}    # Some variable suite level no need to pass to function
    CreateInvoice          ${email_address}    ${license_key}    ${product_key}    ${product_description}
    GDPR_Deletion
