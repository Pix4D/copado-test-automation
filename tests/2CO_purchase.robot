*** Settings ***
Documentation              E2e test for 2Checkout purchase flow
Library                    QWeb
# Library                  SeleniumLibrary
Suite Setup                Setup Browser
Suite Teardown             CloseAllBrowsers


*** Variables ***
${BROWSER}                 chrome
${eum_org_name}            CXOps RoboticTesting CREDITS
${product_key}             MAPPER-OTC1-DESKTOP
${product_description}     PIX4Dcloud Advanced, Monthly, Subscription
# credit amount view ui variable
${credit_amount_ui}        1,000
${total_user_credit}       1100
${product_credit_1000}     CLOUD-CREDITS-1000,CLOUD-ADVANCED-MONTH-SUBS
${url_buy_product}         https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_credit_1000}
${url_dev}                 https://dev.cloud.pix4d.com
${url_account_dev}         https://dev.account.pix4d.com
# Remove credentials tehy'e going github XXXXXXXX
${username}                cxops.robot@pix4d.work
${password}                ?sKZZ=g5>K(NL];$7jXB
${card_number}             4111111111111111
${card_expiration_date}    0130
${card_security_code}      234
${cart_holder_name}        John Doe



*** Keywords ***
Setup Browser
    # ${chrome_options}=     Set Variable                --disable-save-password-bubble;--no-first-run;--disable-infobars
    # Open Browser           about:blank                 chrome                      options=${chrome_options}
    Open Browser           url=about:blank             browser_alias=chrome        options=add_argument("--disable-notifications")
LoginAppStagingAP
    GoTo                   ${url_dev}/admin_panel/     timeout=5
    TypeText               Enter email                 ${username}
    ClickText              Continue
    VerifyText             Log in
    TypeText               Enter password              ${password}
    ClickText              Log in                      anchor=Back                 # <log in> button closest to <Back> button

*** Test Cases ***
2CO Purchase Flow
    [Documentation]        2Checkoutcredit purshase flow
    # User Should be member of EUM ORG
    LoginAppStagingAP
    # Verify user and get necessary org value
    VerifyText             CXOps RoboticTesting
    ClickText              CXOps RoboticTesting
    VerifyAll              ${username}, Profile info
    ${my_user_url}         GetUrl
    Set Suite Variable     ${my_user_url}
    Log To Console         ${my_user_url}
    ClickText              ${eum_org_name}
    ${org_uuid}            GetAttribute                id_uuid                     tag=input                   attribute=value
    Set Suite Variable     ${org_uuid}
    Log To Console         ${org_uuid}
    ${eum_org_url}         GetUrl
    Set Suite Variable     ${eum_org_url}
    Log To Console         ${eum_org_url}
    # Set account UI page
    ${org_account_page}    Set Variable                ${url_account_dev}/organization/${org_uuid}/credits
    Set Suite Variable     ${org_account_page}
    Log To Console         ${org_account_page}

    # 2CO journey starting with chosed prodcut and credit
    GoTo                   ${url_buy_product}
    VerifyAll              Your order, You are logged in as: ${username}, ${product_description}, ${credit_amount_ui} Credits
    ClickText              Continue
    # Retrives ORG Billing info of the org
    VerifyAll              Order summary, Billing Information, Payment details, ${product_description}
    VerifyInputValue       Email                       ${username}
    TypeText               Card number                 ${card_number}
    TypeText               Card expiration date*:      ${card_expiration_date}
    TypeText               Security code*:             ${card_security_code}
    TypeText               Card holder name            ${cart_holder_name}
    Execute Javascript     document.getElementById('custom[9120]').click();
    ClickText              Continue
    # VerifyText           Place order
    # ClickText            Place order
    # Verify Text          Thank you for your order!                               timeout=5                   #(Order no. 229167812)
    # VerifyText           ${username}
    # check credits and SUBS
    GoTo                   ${org_account_page}         timeout=5
    # first go admin panel








