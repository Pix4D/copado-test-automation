*** Settings ***
Library                         QWeb
Library                         String
Library                         FakerLibrary


*** Variables ***
${product_key}                  MAPPER-OTC1-DESKTOP
${product_description}          PIX4Dcloud Advanced, Monthly, Subscription
${credit_amount_ui}             1,000                       # credit amount view ui variable
${total_user_credit}            1100
${product_credit_1000}          CLOUD-CREDITS-1000,CLOUD-ADVANCED-MONTH-SUBS
${url_buy_product}              https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_credit_1000}
${url_dev}                      https://dev.cloud.pix4d.com
${url_account_dev}              https://dev.account.pix4d.com
${card_number}                  4111111111111111
${card_expiration_date}         0130
${card_security_code}           234
${cart_holder_name}             John Doe
${pandora_migration_task}       https://dev.cloud.pix4d.com/admin/common/admintask/63/change/?_changelist_filters=q%3Dpandora
${admin_tasks}                  https://dev.cloud.pix4d.com/admin/common/admintask/


*** Keywords ***
Robot_Login_To_Staging_AP
    [Documentation]             Robot loging to staging Admin Panel
    GoTo                        ${url_dev}/admin_panel/     timeout=5
    TypeText                    Enter email                 ${robot_username}
    ClickText                   Continue
    VerifyText                  Log in
    TypeText                    Enter password              ${robot_password}
    ClickText                   Log in                      anchor=Back


Create_Random_Person_Data
    [Documentation]             This will create a random person with first_name, last_name, email, password
    ${fake_user_first_name}=    FakerLibrary.first_name
    Log To Console              ${fake_user_first_name}
    Set Suite Variable          ${fake_user_first_name}
    ${fake_user_last_name}=     FakerLibrary.last_name
    Set Suite Variable          ${fake_user_last_name}
    ${fake_user_email}=         FakerLibrary.email          domain=pix4d.work
    Log To Console              ${fake_user_last_name}
    Set Suite Variable          ${fake_user_email}
    ${fake_user_password}=      FakerLibrary.Password       special_chars=False
    Log To Console              ${fake_user_password}
    Set Suite Variable          ${fake_user_password}
    Log To Console              Created user: ${fake_user_first_name}, ${fake_user_last_name}, ${fake_user_email}, ${fake_user_password}
    Return From Keyword

Fill_User_Form_And_Verify
    [Documentation]             Fill the user form and verify 'Billing info'. Retry up to 3 times if verification fails.
    ${retries}=                 Set Variable                3
    FOR                         ${index}                    IN RANGE                    ${retries} # with varibale not working
        Create_Random_Person_Data
        GoTo                    ${url_dev}/admin_panel/pixuser/new/
        VerifyText              New User
        Type Text               id_first_name               ${fake_user_first_name}
        Type Text               Last name                   ${fake_user_last_name}
        Type Text               Email address               ${fake_user_email}
        Type Text               Password                    ${fake_user_password}
        Type Text               Password confirmation       ${fake_user_password}
        Click Text              SAVE
        ${status}=              Is Text                     Billing info                timeout=5
        IF                      ${status}
            Log To Console      Billing info verified.
            Return From Keyword
        ELSE
            Log To Console      Billing info not found, retrying...
            Refresh Page
            Sleep               2                           # Wait for 2 seconds before retrying
        END
    END
    Fail                        Billing info could not be verified after: ${retries} retries.

Get_User_Data_And_Save
    [Documentation]             Get user url, id, uuid and store to variable
    VerifyAll                   ${fake_user_email}, Profile info
    ${fake_user_url}            GetUrl
    Set Suite Variable          ${fake_user_url}
    Log To Console              ${fake_user_url}
    @{url_parts}=               Split String                ${fake_user_url}            /
    ${fake_user_id}=            Set Variable                ${url_parts}[5]
    Log To Console              ${fake_user_id}
    Set Suite Variable          ${fake_user_id}
    ${full_uuid_text}           GetText                     //div[contains(@class, 'mdl-cell-full') and contains(., 'UUID:')]
    Log To Console              ${full_uuid_text}
    @{split_text}=              Split String                ${full_uuid_text}           UUID:
    ${fake_user_uuid}=          Strip String                ${split_text}[1]
    Log To Console              ${fake_user_uuid}
    Set Suite Variable          ${fake_user_uuid}
Add_QA_Comment_To_User
    TypeText                    id_comment                  TEST_CXOps_QA
    ClickText                   SAVE PROFILE

Create_New_Rondom_User
    [Documentation]             This will create a new user in the Admin Panel application
    GoTo                        ${url_dev}/admin_panel/pixuser/new/
    Sleep                       3
    Fill_User_Form_And_Verify
    Refresh Page
    Get_User_Data_And_Save
    Add_QA_Comment_To_User

Login_As_User
    [Documentation]             Login as fake user
    TypeText                    Enter email                 ${fake_user_email}
    ClickText                   Continue
    VerifyText                  Log in
    TypeText                    Enter password              ${fake_user_password}
    ClickText                   Log in                      anchor=Back

Robot_User_Verify_And_Save_Data
    VerifyText                  CXOps RoboticTesting
    ClickText                   CXOps RoboticTesting
    VerifyAll                   ${robot_username}, Profile info
    ${robot_user_url}           GetUrl
    Set Suite Variable          ${robot_user_url}
    Log To Console              ${robot_user_url}

Migrate_User_To_Pandora_Verify_Execution
    [Documentation]             Migrates user to pandora to get EUM Org for the user
    VerifyAll                   ${fake_user_email}, ${fake_user_uuid}
    GoTo                        ${pandora_migration_task}
    TypeText                    Exec args:                  ${fake_user_uuid}
    ClickText                   SAVE                        anchor=Save and continue editing
    VerifyText                  Select admin task to change
    ClickCheckbox               Migrate to Pandora          on                          anchor=63
    DropDown                    ---------                   Run selected tasks          anchor=Action:
    ClickText                   Go                          anchor=Run the selected action                          timeout=5
    VerifyText                  Task Migrate to Pandora executed


Verify_EUM_Org_Migration_From_User_Page
    [Documentation]             Back to the user page and verify EUM org migration from user page
    GoTo                        ${fake_user_url}            timeout=3
    ${eum_org_name}             Set Variable                ${fake_user_first_name} ${fake_user_last_name} space
    Log To Console              ${eum_org_name}
    Set Suite Variable          ${eum_org_name}
    VerifyAll                   ${fake_user_uuid}, Already part of EUM, ${eum_org_name}


Get_EUM_Org_uuid_And_Set_Acount_UI_path
    ClickText                   ${eum_org_name}
    ${eum_org_uuid}             GetAttribute                id_uuid                     tag=input                   attribute=value
    Set Suite Variable          ${eum_org_uuid}
    Log To Console              ${eum_org_uuid}
    ${eum_org_url}              GetUrl
    Set Suite Variable          ${eum_org_url}
    Log To Console              ${eum_org_url}
    # Set account UI page
    ${org_account_page}         Set Variable                ${url_account_dev}/organization/${eum_org_uuid}/credits
    Set Suite Variable          ${org_account_page}
    Log To Console              ${org_account_page}

Set_EUM_Org_Billing_Info
    [Documentation]             Seeting EUM org billin info
    ClickText                   Add new billing information
    Sleep                       2
    VerifyText                  Billing information
    TypeText                    id_first_name               ${fake_user_first_name}
    TypeText                    id_last_name                ${fake_user_last_name}
    TypeText                    id_title                    Mr.
    TypeText                    id_email                    ${fake_user_email}
    TypeText                    id_company_name             ${eum_org_name}
    TypeText                    id_address                  Rue de Pix4D 5
    TypeText                    id_phone                    +41887776655
    TypeText                    id_city                     Lausanne
    TypeText                    id_zip                      1001
    DropDown                    id_country                  Switzerland                 anchor=Country
    TypeText                    id_vat_code                 CHE-123.456.789 TVA
    ClickText                   SAVE                        anchor=Cancel

Get_Billing_Info_Id_From_EUM_Org_Page
    GoTo                        ${eum_org_url}
    RefreshPage
    ScrollText                  Billing information
    ${billing_info_id}=         GetText                     //table[contains(@class, 'mdl-data-table')]/tbody/tr[1]/td[1]
    Set Suite Variable          ${billing_info_id}
    Log To Console              ${billing_info_id}

Link_The_User_To_The_Org_Billing_Info
    ${org_billing_info_url}     Set Variable                ${url_dev}/admin/user_account/billinginformation/${billing_info_id}/change/
    Log To Console              ${org_billing_info_url}
    Set Suite Variable          ${org_billing_info_url}
    Goto                        ${org_billing_info_url}
    VerifyAll                   Change billing information, BillingInformation[${billing_info_id}]:
    TypeText                    id_pixuser                  ${fake_user_id}
    ClickText                   Save and continue editing                               anchor=Save and add another
    VerifyText                  was changed successfully    timeout=4

Logout_From_Current_User
    Goto                        ${url_dev}/logout
    VerifyText                  Log in


2Checkout_Credit_Product_Order_With_Retrived_Billing_Info
    [Documentation]             2CO user journey starting with chosed product and credit
    Log                         buy prodcut url:${url_buy_product}                      console=True
    GoTo                        ${url_buy_product}          timeout=5
    VerifyAll                   Your order, You are logged in as: ${fake_user_email}, ${product_description}, ${credit_amount_ui} Credits
    ClickText                   Continue
    # Retrives ORG Billing info of the org
    VerifyAll                   Order summary, Billing Information, Payment details, ${product_description}
    VerifyInputValue            Email                       ${fake_user_email}
    TypeText                    Card number                 ${card_number}
    TypeText                    Card expiration date*:      ${card_expiration_date}
    TypeText                    Security code*:             ${card_security_code}
    TypeText                    Card holder name            ${cart_holder_name}
    Execute Javascript          document.getElementById('custom[9120]').click();
    ClickText                   Continue
    VerifyText                  Place order
    ClickText                   Place order
    Verify Text                 Thank you for your order!                               timeout=15
    VerifyText                  ${fake_user_email}

Verify_Puchased_Credit_From_Account_UI
    [Documentation]             Verify pruchased credits from account UI organization page
    GoTo                        ${org_account_page}         timeout=5
    ${creditAmount}             GetText                     //*[@data-test\='creditAmount']                         timeout=5
    Log To Console              Credit in account: ${creditAmount}, Expected credit: ${total_user_credit}
    Should Be Equal As Strings                              ${creditAmount}             ${total_user_credit}


Verify_Invoice_Generation_With_Correct_Product
    [Documentation]             Verify invoice geneartion with correct prodcut on admin panel organization page
    GoTo                        ${eum_org_url}
    VerifyInputValue            id_uuid                     ${eum_org_uuid}             anchor=UUID
    Log To Console              ${eum_org_uuid}
    ScrollTo                    Invoice number
    UseTable                    Invoice number
    ${invoice_product}=         Get Cell Text               r1c8
    Should Contain              ${invoice_product}          ${product_description}
    Should Contain              ${invoice_product}          ${credit_amount_ui}

GDPR_Deletion_Rondom_User
    [Documentation]             GDPR deletion of the test pixuser
    GoTo                        ${fake_user_url}
    VerifyAll                   ${fake_user_email}, Profile info, ${fake_user_uuid}
    ClickText                   GDPR Deletion               tag=button
    CloseAlert                  accept                      10s
    VerifyText                  Account disabled upon GDPR request from data subject

