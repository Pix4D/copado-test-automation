*** Settings ***
Documentation              E2e test for 2Checkout purchase flow
Library                    QWeb
# Library                  SeleniumLibrary
# Library                  ../Libraries/CookieManager.py
Suite Setup                Open Browser                about:blank       ${BROWSER}
Suite Teardown             Close All Browsers
# Resource                 ../resources/common.robot                     # Actually I can put evethings in common filed varibales etc
# Resource                 ../resources/licenses.robot
# Resource                 ../resources/invoices.robot

*** Variables ***
${BROWSER}                 chrome
${product_key}             MAPPER-OTC1-DESKTOP
${product_description}     PIX4Dcloud Advanced, Monthly, Subscription
# credit emout view ui variable
${credit_amount_ui}        1,000
${product_credit_1000}     CLOUD-CREDITS-1000,CLOUD-ADVANCED-MONTH-SUBS
# ${url_buy_now}           https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_key}
${url_buy_product}         https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_credit_1000}
${url_dev}                 https://dev.cloud.pix4d.com
${username}                cxops.robot@pix4d.work
${password}                ?sKZZ=g5>K(NL];$7jXB
${expected_2co_domain}     https://checkout.pix4d.com
# Test Card data
${card_number}             4111111111111111
${card_expiration_date}    0130
${card_security_code}      234
${cart_holder_name}        John Doe



*** Keywords ***
LoginAppStagingAP
    GoTo                   ${url_dev}/admin_panel/     timeout=5
    TypeText               Enter email                 ${username}
    ClickText              Continue
    VerifyText             Log in
    TypeText               Enter password              ${password}
    ClickText              Log in                      anchor=Back       # <log in> button closest to <Back> button


*** Test Cases ***
2CO Purchase Flow
    # User Should be mmemberemebr of EUM ORG
    LoginAppStagingAP
    VerifyText             CXOps RoboticTesting
    ClickText              CXOps RoboticTesting
    VerifyAll              ${username}, Profile info
    ${my_user_url}         GetUrl
    Set Suite Variable     ${my_user_url}
    Log To Console         ${my_user_url}
    GoTo                   ${url_buy_product}
    # Campnay shows up with credit amount etc
    VerifyAll              Your order, You are logged in as: ${username}, ${product_description}, ${credit_amount_ui} Credits
    ClickText              Continue
    # We land on 2CO after redirection from Django backend
    # COPADO server is running different location 2CO using geo location. Consider it.
    # Retrives ORG Billing info of the org
    VerifyAll              Order summary, Billing Information, Payment details, ${product_description}
    VerifyInputValue       Email                       ${username}
    TypeText               Card number                 ${card_number}
    # TypeText             Card expiration date*:      ${card_expiration_date}
    # TypeText             Security code*:             ${card_security_code}
    # TypeText             Card holder name            ${cart_holder_name}
    # ClickCheckbox        Yes, I agree to the Pix4D General Terms and Conditions
    TypeText               Card expiration date        0130
    TypeText               Security code               234
    TypeText               Card holder name            John Doe
    # Acept condition
    UseTable               xpath\=//*[@id\='order__checkout__payoptions__data']/div[1]/div[1]/div[1]/div[3]/div[2]/div[2]/table[1]
    ClickCheckbox          r?\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tYes, I agree to the Pix4D General Terms and Conditions*\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t/c1    on
    VerifyCheckbox         Yes, I agree                        anchor=Yes
