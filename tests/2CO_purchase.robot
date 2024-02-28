*** Settings ***
Documentation             E2e test for 2Checkout purchase flow
Library                   QWeb
Suite Setup               Initialize Suite
Suite Teardown            Close All Browsers
# Resource                ../resources/common.robot
# Resource                ../resources/licenses.robot
# Resource                ../resources/invoices.robot

*** Variables ***
${product_key}            MAPPER-OTC1-DESKTOP
${product_credit_500}     CLOUD-CREDITS-500,CLOUD-ADVANCED-MONTH-SUBS
# ${url_buy_now}          https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_key}
${url_buy_product}        https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_credit_500}
${url_dev}                https://dev.cloud.pix4d.com
${username}               cxops.robot@pix4d.work
${password}               ?sKZZ=g5>K(NL];$7jXB


*** Keywords ***
Initialize Suite
    Open Browser    about:blank    chrome
    Initialize Suite Variables

Initialize Suite Variables
    #                     Set Suite Variable          ${product_key}                             MAPPER-OTC1-DESKTOP
    #                     Set Suite Variable          ${product_description}                     PIX4Dmapper Desktop, Single device, Perpetual license

LoginAppStagingAP
    GoTo                  ${url_dev}/admin_panel/     #timeout=5
    TypeText              Enter email                 ${username}
    ClickText             Continue
    VerifyText            Log in
    TypeText              Enter password              ${password}
    ClickText             Log in                      anchor=Back    index=2 # <log in> button closest to <Back> button


*** Test Cases ***

2CO Purchase Flow
    LoginAppStagingAP
    VerifyAll             ${username}, Profile info
    ${my_user_url}        GetUrl
    Set Suite Variable    ${my_user_url}
    Log To Console        ${my_user_url}
    GoTo                  ${url_buy_product}
