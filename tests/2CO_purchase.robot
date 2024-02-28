*** Settings ***
Documentation              E2e test for 2Checkout purchase flow
Library                    QWeb
Library    SeleniumLibrary
Library    
Suite Setup                Open Browser                about:blank                 ${BROWSER}
Suite Teardown             Close All Browsers
# Resource                 ../resources/common.robot                               # Actually I can put evethings in common filed varibales etc
# Resource                 ../resources/licenses.robot
# Resource                 ../resources/invoices.robot

*** Variables ***
${BROWSER}                 chrome
${product_key}             MAPPER-OTC1-DESKTOP
${product_description}     PIX4Dcloud Advanced, Monthly, Subscription
${credit_amount}           500
${product_credit_500}      CLOUD-CREDITS-500,CLOUD-ADVANCED-MONTH-SUBS
# ${url_buy_now}           https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_key}
${url_buy_product}         https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_credit_500}
${url_dev}                 https://dev.cloud.pix4d.com
${username}                cxops.robot@pix4d.work
${password}                ?sKZZ=g5>K(NL];$7jXB
${expected_new_domain}     https://checkout.pix4d.com


*** Keywords ***
LoginAppStagingAP
    GoTo                   ${url_dev}/admin_panel/     timeout=5
    TypeText               Enter email                 ${username}
    ClickText              Continue
    VerifyText             Log in
    TypeText               Enter password              ${password}
    ClickText              Log in                      anchor=Back                 # <log in> button closest to <Back> button


*** Test Cases ***
2CO Purchase Flow
    LoginAppStagingAP
    VerifyText             CXOps RoboticTesting
    ClickText              CXOps RoboticTesting
    VerifyAll              ${username}, Profile info
    ${my_user_url}         GetUrl
    Set Suite Variable     ${my_user_url}
    Log To Console         ${my_user_url}
    GoTo                   ${url_buy_product}
    Set Test Variable      ${product_description}      PIX4Dcloud Advanced, Monthly, Subscription              # Remove this line
    Set Test Variable      ${credit_amount}            500                         # Remove this line
    Log To Console         ${product_description}, ${credit_amount}                # Remove this line
    VerifyAll              Your order, You are logged in as: ${username}, ${product_description}, ${credit_amount} Credits
    ClickText              Continue



