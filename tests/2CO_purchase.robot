*** Settings ***
Documentation                   E2e test for 2Checkout purchase flow
Library                         QWeb
Library                         BuiltIn
Library                         String
Suite Setup                     Setup Browser
Suite Teardown                  CloseAllBrowsers
Resource                   ../resources/common.robot


*** Variables ***
${BROWSER}                      chrome
${eum_org_name}                 CXOps RoboticTesting CREDITS
${product_key}                  MAPPER-OTC1-DESKTOP
${product_description}          PIX4Dcloud Advanced, Monthly, Subscription
# credit amount view ui variable
${credit_amount_ui}             1,000
${total_user_credit}            2200
${product_credit_1000}          CLOUD-CREDITS-1000,CLOUD-ADVANCED-MONTH-SUBS
${url_buy_product}              https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_credit_1000}
${url_dev}                      https://dev.cloud.pix4d.com
${url_account_dev}              https://dev.account.pix4d.com
# Remove credentials tehy'e going github XXXXXXXX
${robot_username}                     cxops.robot@pix4d.work
${robot_password}                     ?sKZZ=g5>K(NL];$7jXB
${card_number}                  4111111111111111
${card_expiration_date}         0130
${card_security_code}           234
${cart_holder_name}             John Doe



*** Keywords ***
Setup Browser
    ${chrome_options}=          Evaluate                    sys.modules['selenium.webdriver'].ChromeOptions()       sys, selenium.webdriver
    Call Method                 ${chrome_options}           add_experimental_option     prefs                       {'profile.default_content_setting_values.notifications': 2}
    Open Browser                about:blank                 chrome                      options=${chrome_options}
    # Setup Browser
    #                           # ${chrome_options}=        Set Variable                --disable-save-password-bubble;--no-first-run;--disable-infobars
    #                           # Open Browser              about:blank                 chrome                      options=${chrome_options}
    #                           Open Browser                url=about:blank             browser_alias=chrome        options=add_argument("--disable-notifications")
LoginAppStagingAP
    GoTo                        ${url_dev}/admin_panel/     timeout=5
    TypeText                    Enter email                 ${robot_username}
    ClickText                   Continue
    VerifyText                  Log in
    TypeText                    Enter password              ${robot_password}
    ClickText                   Log in                      anchor=Back                 # <log in> button closest to <Back> button

*** Test Cases ***
2CO Purchase Flow
    [Documentation]             2Checkoutcredit purshase flow
    # User Should be member of EUM ORG
    LoginAppStagingAP
    # Verify user and get necessary org value
    VerifyText                  CXOps RoboticTesting
    ClickText                   CXOps RoboticTesting
    VerifyAll                   ${robot_username}, Profile info
    ${robot_user_url}              GetUrl
    Set Suite Variable          ${robot_user_url}
    Log To Console              ${robot_user_url}
    # Create Rondom user
    CreateUser
        # UUID => need for pandora task
        # Get/store necessary info for user
    # MIGRATE TO PANDORA
        # pandora tasks:  https://dev.cloud.pix4d.com/admin/common/admintask/63/change/?_changelist_filters=q%3Dpandora
            # exec args replace exisitng with user uuid
            # "Save and continue editing" button
        # admin tasks page = https://dev.cloud.pix4d.com/admin/common/admintask/
            # Migrate to Pandora	common.admin_tasks.one_off.migrate_to_pandora.migrate_to_pandora
            # Tick Mark => Migrate to Pandora	common.admin_tasks.one_off.migrate_to_pandora.migrate_to_pandora
            # Actions=> Run selected task => Run
            # refresh page and back to user
    
    # EUM state: user with EUM org
        # 
    
    
    
    # Migrate user to 
    ClickText                   ${eum_org_name}
    ${org_uuid}                 GetAttribute                id_uuid                     tag=input                   attribute=value
    Set Suite Variable          ${org_uuid}
    Log To Console              ${org_uuid}
    ${eum_org_url}              GetUrl
    Set Suite Variable          ${eum_org_url}
    Log To Console              ${eum_org_url}
    # Set account UI page
    ${org_account_page}         Set Variable                ${url_account_dev}/organization/${org_uuid}/credits
    Set Suite Variable          ${org_account_page}
    Log To Console              ${org_account_page}
    # login as user
    # https://dev.cloud.pix4d.com/login or log out

    # 2CO journey starting with chosed prodcut and credit
    GoTo                        ${url_buy_product}
    VerifyAll                   Your order, You are logged in as: ${robot_username}, ${product_description}, ${credit_amount_ui} Credits
    ClickText                   Continue
    # Retrives ORG Billing info of the org
    VerifyAll                   Order summary, Billing Information, Payment details, ${product_description}
    VerifyInputValue            Email                       ${robot_username}
    TypeText                    Card number                 ${card_number}
    TypeText                    Card expiration date*:      ${card_expiration_date}
    TypeText                    Security code*:             ${card_security_code}
    TypeText                    Card holder name            ${cart_holder_name}
    Execute Javascript          document.getElementById('custom[9120]').click();
    ClickText                   Continue
    # Press Key                 //body                      \\27
    # RightClick                //body
    # Click Element             Review your order
    # RightClick                Review your order
    # ClickText                 Review your order
    # VerifyText                Place order
    # ClickText                 Place order
    # Verify Text               Thank you for your order!                               timeout=5                   #(Order no. 229167812)
    # VerifyText                ${username}
    # check credits and SUBS
    GoTo                        ${org_account_page}         timeout=5
    # ${license_key}            GetText                     //a[@title\='Download Licence']
    ${creditAmount}             GetText                     //*[@data-test\='creditAmount']                         timeout=5
    Log To Console              Credit in account: ${creditAmount}, Expected credit: ${total_user_credit}
    Should Be Equal As Strings                              ${creditAmount}             ${total_user_credit}
    # first go admin panel: Verify invoice, prodcut etc, hubspot
    GoTo                        ${eum_org_url}
    VerifyInputValue            id_uuid                     ${org_uuid}                 anchor=UUID
    Log To Console              ${org_uuid}
    ScrollTo                    Invoice number
    UseTable                    Invoice number
    ${invoice_product}=         Get Cell Text               r1c8
    Should Contain              ${invoice_product}          ${product_description}
    Should Contain              ${invoice_product}          ${credit_amount_ui}

    # VerifyTable                 r1c8                        ${product_description} ${credit_amount_ui} Credits
    # VerifyText                  ${product_description}      anchor=//a[@title\='Edit invoice']
    # # //*[@id='section-invoices']
    # # UseTable                  //*[@id='section-invoices']
    # # ${license_key}            GetText                     //a[@title\='Download Licence']
    # VerifyText                  ${product_description}      anchor=//a[@title\='Edit invoice']
    # VerifyElement               //a[@title\='Edit invoice']
    
    # GDPR deletion
        # 









