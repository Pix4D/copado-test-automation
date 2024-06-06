*** Settings ***
Library                         QWeb
Library                         String
Library                         FakerLibrary


*** Variables ***
${url_dev}                      https://dev.cloud.pix4d.com
${email_domain}                 pix4d.work
${country}                      Switzerland
${company_name}                 CXOps_TEST_AUTOMATION
${industries}                   Engineering



*** Keywords ***
Create_Account_Email
    [Documentation]             Create account email with Uuid4.
    ${uuid}=                    FakerLibrary.Uuid4
    Log To Console              ${uuid}
    ${user_email}=              Set Variable                ${uuid}@pix4d.work
    Log To Console              ${user_email}
    Set Suite Variable          ${user_email}

Fill_User_Email_And_Verify
    [Documentation]             Fill the user email and verify. Retry up to 3 times if verification fails.
    ${retries}=                 Set Variable                3
    FOR                         ${index}                    IN RANGE                    ${retries}
        Create_Account_Email
        GoTo                    ${url_dev}/signup
        VerifyAll               Create your account, Enter email
        Type Text               Enter email                 ${user_email}
        Click Text              Continue
        ${status}=              Is Text                     First Name                  timeout=5
        IF                      ${status}
            Log To Console      Email is not in use verified.
            Return From Keyword
        ELSE
            Log To Console      Email in use or something else, retrying...
            Refresh Page
            Sleep               2                           # Wait for 2 seconds before retrying
        END
    END
    Fail                        Email registery could not be verify after: ${retries} retries.

Create_Random_User_Data
    [Documentation]             Creating random user data
    ${user_first_name}=         FakerLibrary.first_name
    Set Suite Variable          ${user_first_name}
    ${user_last_name}=          FakerLibrary.last_name
    Set Suite Variable          ${user_last_name}
    ${user_password}=           FakerLibrary.Password       special_chars=False
    Set Suite Variable          ${user_password}
    Log To Console              Created user, name: ${user_first_name} ${user_last_name}, username: ${user_email}, password: ${user_password}
    Return From Keyword

Fill_User_Form_And_Verify
    [Documentation]             Fill the user creation form and verify.
    VerifyText                  Yes, I agree to the Pix4D Terms Of Service, and Software EULA.
    VerifyText                  ${user_email}
    Create_Random_User_Data
    Type Text                   Password                    ${user_password}
    Type Text                   Fist Name                   ${user_first_name}
    Type Text                   Last Name                   ${user_last_name}
    DropDown                    Country                     ${country}                  anchor=Country
    DropDown                    Prefered language           English
    TypeText                    Company                     ${company_name}
    DropDown                    Industries                  Engineering
    ClickText                   Yes, I agree to the Pix4D Terms Of Service, and Software EULA.
    ClickText                   Yes, I agree to Pix4D's Privacy Policy.
    Click Text                  Continue                    anchor=Back


Fill_Communication_Preference
    [Documentation]             Fill the user communication preference form and verify.
    VerifyText                  We take your data very seriously                        timeout=5
    # ClickCheckbox               Migrate to Pandora          on                          anchor=63
    ClickText                   Yes                         anchor=1
    ClickText                   Yes                         anchor=2
    ClickText                   Yes                         anchor=3
    ClickText                   Save                        anchor=Cancel
    VerifyText                  You are almost done!        timeout=5


Robot_Login_To_Staging_AP
    [Documentation]             Robot loging to staging Admin Panel
    GoTo                        ${url_dev}/admin_panel/     timeout=5
    TypeText                    Enter email                 ${robot_username}
    ClickText                   Continue
    VerifyText                  Log in
    TypeText                    Enter password              ${robot_password}
    ClickText                   Log in                      anchor=Back


Find_The_User
    [Documentation]             Find the user



GDPR_Deletion_Rondom_User
    [Documentation]             GDPR deletion of the test pixuser
    GoTo                        ${fake_user_url}            timeout=5
    VerifyAll                   ${fake_user_email}, Profile info, ${fake_user_uuid}     timeout=5
    ClickText                   GDPR Deletion               tag=button
    CloseAlert                  accept                      10s
    VerifyText                  Account disabled upon GDPR request from data subject

# ----------------------------------------------------------------------------------------

# Get_User_Data_And_Save
#     [Documentation]             Get user url, id, uuid and store to variable
#     VerifyAll                   ${fake_user_email}, Profile info
#     ${fake_user_url}            GetUrl
#     Set Suite Variable          ${fake_user_url}
#     Log To Console              ${fake_user_url}
#     @{url_parts}=               Split String                ${fake_user_url}            /
#     ${fake_user_id}=            Set Variable                ${url_parts}[5]
#     Log To Console              ${fake_user_id}
#     Set Suite Variable          ${fake_user_id}
#     ${full_uuid_text}           GetText                     //div[contains(@class, 'mdl-cell-full') and contains(., 'UUID:')]
#     Log To Console              ${full_uuid_text}
#     @{split_text}=              Split String                ${full_uuid_text}           UUID:
#     ${fake_user_uuid}=          Strip String                ${split_text}[1]
#     Log To Console              ${fake_user_uuid}
#     Set Suite Variable          ${fake_user_uuid}

# Add_QA_Comment_And_Save
#     TypeText                    id_comment                  TEST_CXOps_QA
#     ClickText                   SAVE PROFILE

Create_New_Rondom_User
    [Documentation]             This will create a new user in the Admin Panel application
    GoTo                        ${url_dev}/admin_panel/pixuser/new/
    Sleep                       3
    Fill_User_Form_And_Verify
    Refresh Page
    Get_User_Data_And_Save
    Add_QA_Comment_And_Save

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
    Sleep                       3


Verify_EUM_Org_Migration_From_User_Page
    [Documentation]             Back to the user page and verify EUM org migration from user page
    GoTo                        ${fake_user_url}            timeout=3
    ${eum_org_name}             Set Variable                ${fake_user_first_name} ${fake_user_last_name} space
    Log To Console              ${eum_org_name}
    Set Suite Variable          ${eum_org_name}
    RefreshPage
    VerifyAll                   ${fake_user_uuid}, Already part of EUM, ${eum_org_name}


Get_EUM_Org_uuid_And_Set_Partner_Account_UI_path
    [Documentation]             Get and set org variables for future execution
    ClickText                   ${eum_org_name}
    ${eum_org_uuid}             GetAttribute                id_uuid                     tag=input                   attribute=value
    Set Suite Variable          ${eum_org_uuid}
    Log To Console              ${eum_org_uuid}
    ${eum_org_url}              GetUrl
    Set Suite Variable          ${eum_org_url}
    Log To Console              ${eum_org_url}
    ${partner_store_url}        Set Variable                ${partner_account_base_url}/organization/${eum_org_uuid}/store-product/all
    Set Suite Variable          ${partner_store_url}
    Log To Console              ${partner_store_url}
    ${partner_home_url}         Set Variable                ${partner_account_base_url}/organization/${eum_org_uuid}/home
    Set Suite Variable          ${partner_home_url}
    Log To Console              ${partner_home_url}


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
    [Documentation]             Get billing info id from AP org page
    GoTo                        ${eum_org_url}
    RefreshPage
    ScrollText                  Billing information
    ${billing_info_id}=         GetText                     //table[contains(@class, 'mdl-data-table')]/tbody/tr[1]/td[1]
    Set Suite Variable          ${billing_info_id}
    Log To Console              ${billing_info_id}

Link_The_User_To_The_Org_Billing_Info
    [Documentation]             Link org user to org billing info
    ${org_billing_info_url}     Set Variable                ${url_dev}/admin/user_account/billinginformation/${billing_info_id}/change/
    Log To Console              ${org_billing_info_url}
    Set Suite Variable          ${org_billing_info_url}
    GoTo                        ${org_billing_info_url}
    VerifyAll                   Change billing information, BillingInformation[${billing_info_id}]:
    TypeText                    id_pixuser                  ${fake_user_id}
    ClickText                   Save and continue editing                               anchor=Save and add another
    VerifyText                  was changed successfully    timeout=4

Convert_EUM_Org_To_Partner
    [Documentation]             Covert EUM Org to partner Org
    GoTo                        ${eum_org_url}              timeout=5
    VerifyInputValue            id_uuid                     ${eum_org_uuid}
    VerifyText                  Convert to partner          anchor=Credits
    ClickText                   Convert to partner

Set_The_Partner_Org
    [Documentation]             Set newly created partner org details from admin page
    ${partner_org_url}          GetUrl
    Set Suite Variable          ${partner_org_url}
    Log To Console              ${partner_org_url}
    @{partner_org_url_parts}=                               Split String                ${partner_org_url}          /
    ${partner_org_id}=          Set Variable                ${partner_org_url_parts}[5]
    Log To Console              ${partner_org_id}
    Set Suite Variable          ${partner_org_id}
    ${partner_org_admin_url}    Set Variable                ${url_dev}/admin/partner/partnerorganization/${partner_org_id}/change/
    Set Suite Variable          ${partner_org_admin_url}
    Log To Console              ${partner_org_admin_url}
    GoTo                        ${partner_org_admin_url}    timeout=3
    VerifyText                  Change partner organization                             timeout=3
    DropDown                    Partner type:               Premier Reseller
    TypeText                    id_reference_user           ${fake_user_id}
    DropDown                    Access profile:             Store Premium
    DropDown                    Currency code:              CHF
    TypeText                    id_pix4d_manager            ${fake_user_id}
    ClickText                   Save and continue editing                               anchor=Save and add another
    VerifyText                  was changed successfully    timeout=4

Logout_From_Current_User
    [Documentation]             Logout from current user
    GoTo                        ${url_dev}/logout
    VerifyText                  Log in


Order_Product_from_Partner_Store
    [Documentation]             Place an order from new partner store
    Sleep                       3
    GoTo                        ${partner_store_url}        timeout=5
    Log To Console              ${partner_store_url}
    VerifyAll                   All products, Store Products                            timeout=5
    TypeText                    Search by name              ${product_credits}
    VerifyText                  ${product_credits}
    ClickText                   Add to cart                 anchor=2,500 Credits
    TypeText                    Search by name              ${product_cloud_advanced}
    VerifyText                  ${product_cloud_advanced}                               anchor=Product
    ClickText                   Add to cart                 anchor=PIX4Dcloud Advanced, Yearly, rental
    ClickText                   Show cart                   anchor=Subtotal:
    VerifyText                  Complete purchase
    ClickText                   Complete purchase           anchor=Close
    VerifyText                  Summary
    ClickText                   Complete purchase


2Checkout_Order_Summary_With_Retrived_Billing_Info
    [Documentation]             2Checkout order summary page for Partner
    VerifyAll                   Order summary, Billing Information, Payment details
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
    Sleep                       5                           # Give time to backend execution

Retry Until Invoice Elements Visible
    ${attempt}=                 Set Variable                1
    FOR                         ${index}                    IN RANGE                    3
        Refresh Page
        ClickText               Invoices                    anchor=Home                 timeout=5
        ${is_visible}=          Run Keyword And Return Status                           VerifyAll                   Issued date, Payment date, Amount, Status    timeout=5
        Log                     is_visible: ${is_visible}                               console=True
        Exit For Loop If        ${is_visible}
        ${attempt}=             Evaluate                    ${attempt}+1
        Run Keyword If          ${attempt} > 3              Fail                        "Elements not visible after 3 attempts."
    END

Invoice_And_License_Generation_Verication_On_Partner_Page
    [Documentation]             Verify pruchase from partner account UI
    GoTo                        ${partner_home_url}         timeout=5
    Sleep                       5
    # Switch to Invoice tab, verify invoice, store invoice number
    Retry Until Invoice Elements Visible                    # Try 3 times to see invoice
    UseTable                    //*[@data-test\='table']    anchor=Invoices             timeout=5
    ${invoice_paid}=            Get Cell Text               r1c6
    ${credit_text}=             Get Text                    //*[@data-test\='table']//tr[1]/td[2]//p4d-table-product-cell/p[1]
    ${product_text}=            Get Text                    //*[@data-test\='table']//tr[1]/td[2]//p4d-table-product-cell/p[2]
    Log To Console              ${credit_text}
    Log To Console              ${product_text}
    Should Contain              ${credit_text}              ${product_credits}
    Should Contain              ${product_text}             ${product_cloud_advanced}
    Should Contain              ${invoice_paid}             PAID
    ${invoice_number_account_UI}=                           Get Cell Text               r1c1
    Set Suite Variable          ${invoice_number_account_UI}
    Log To Console              ${invoice_number_account_UI}
    # Switch to licence tab verify product, set lisence key to variable
    ClickText                   Licenses                    anchor=Organization management                          timeout=3
    VerifyAll                   Software code, Creation date, Activation date           timeout=10
    UseTable                    //*[@data-test\='table']    anchor=Licenses             timeout=3
    ${license_product_generated}=                           Get Cell Text               r1c2                        anchor=Software code    timeout=3
    Log To Console              ${license_product_generated}, ${expected_license_product_description}
    Should Contain              ${license_product_generated}                            ${expected_license_product_description}
    ${license_key}=             Get Cell Text               r1c1
    Set Suite Variable          ${license_key}
    Log To Console              ${license_key}

AP_Verify_Invoice_Generation_With_Correct_Product
    [Documentation]             Verify invoice geneartion with correct prodcut on admin panel organization page
    Sleep                       3
    GoTo                        ${eum_org_url}              timeout=5
    VerifyInputValue            id_uuid                     ${eum_org_uuid}             anchor=UUID                 timeout=5
    Log To Console              ${eum_org_uuid}
    ScrollTo                    Invoice number
    UseTable                    Invoice number
    ${invoice_number_in_AP}=    Get Text                    //*[@title\='Edit invoice']
    ${invoice_product_AP}=      Get Cell Text               r1c8
    Log To Console              ${invoice_number_in_AP}
    Should Contain              ${invoice_number_in_AP}     ${invoice_number_account_UI}
    Should Be Equal As Strings                              ${invoice_number_in_AP}     ${invoice_number_account_UI}
    Should Contain              ${invoice_product_AP}       ${product_cloud_advanced}
    Should Contain              ${invoice_product_AP}       ${product_credits}


GDPR_Deletion_Rondom_User
    [Documentation]             GDPR deletion of the test pixuser
    GoTo                        ${fake_user_url}            timeout=5
    VerifyAll                   ${fake_user_email}, Profile info, ${fake_user_uuid}     timeout=5
    ClickText                   GDPR Deletion               tag=button
    CloseAlert                  accept                      10s
    VerifyText                  Account disabled upon GDPR request from data subject

