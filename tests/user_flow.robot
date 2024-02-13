*** Settings ***

Documentation              Admin panel user journay test suite
Library                    QWeb
Suite Setup                Open Browser                about:blank    chrome
Suite Teardown             Close All Browsers
Resource                   ../resources/common.robot
Resource                   ../resources/licenses.robot
Resource                   ../resources/invoices.robot

*** Test Cases ***
User journay
    LoginApp
    CreateUser
    Hubspot sync verify
    CreateLicense
    CreateInvoice
    GDPR_Deletion
