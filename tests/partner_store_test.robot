*** Settings ***
Documentation                   E2e test for 2Checkout purchase flow
Suite Setup                     Open Browser                about:blank                 ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot


*** Variables ***
${BROWSER}                      chrome


*** Test Cases ***
Partner_Store_Test
    [Documentation]             New Partner portal e2e test flow
    Log                         New Partner portal e2e test flow is starting                 console=True

    # Robot user login to staging admin panel
    Robot_Login_To_Staging_AP

    # Verify user and get necessary org value
    Robot_User_Verify_And_Save_Data

    # Create fake rondom user: Generate rondom data, fill the form and store data
    # Temporary user marked as staff otherwise not working. Waiting to fix this bug from backend
    Create_New_Rondom_User

    # Migrate user to pandora: You'll get EUM org
    Migrate_User_To_Pandora_Verify_Execution

    # Back to user page and verifies the migration from user page
    Verify_EUM_Org_Migration_From_User_Page

    # From user to org page and get uuid and set
    # is it necessary ? Since wont visit
    Get_EUM_Org_uuid_And_Set_Partner_Account_UI_path

    # Set EUM org billling info from org page
    Set_EUM_Org_Billing_Info

    # Get Billing info ID from ORG page
    Get_Billing_Info_Id_From_EUM_Org_Page

    # Link user to the ORG billing info: from org page to admin
    Link_The_User_To_The_Org_Billing_Info

    # Convert Org to Partner og
    Convert_EUM_Org_To_Partner
    # GoTo                        ${eum_org_url}              timeout=5
    # VerifyInputValue            id_uuid                     ${eum_org_uuid}
    # VerifyText                  Convert to partner          anchor=Credits
    # ClickText                   Convert to partner

    # Set partner ORG
    Set_The_Partner_Org
    # ${partner_org_url}          GetUrl
    # Set Suite Variable          ${partner_org_url}
    # Log To Console              ${partner_org_url}
    # @{partner_org_url_parts}=                               Split String                ${partner_org_url}    /
    # ${partner_org_id}=          Set Variable                ${partner_org_url_parts}[5]
    # Log To Console              ${partner_org_id}
    # Set Suite Variable          ${partner_org_id}
    # ${partner_org_admin_url}    Set Variable                ${url_dev}/admin/partner/partnerorganization/${partner_org_id}/change/
    # Set Suite Variable          ${partner_org_admin_url}
    # Log To Console              ${partner_org_admin_url}
    # GoTo                        ${partner_org_admin_url}    timeout=3
    # VerifyText                  Change partner organization                             timeout=3
    # DropDown                    Partner type:               Premier Reseller
    # TypeText                    id_reference_user           ${fake_user_id}
    # DropDown                    Access profile:             Store Premium
    # DropDown                    Currency code:              CHF
    # TypeText                    id_pix4d_manager            ${fake_user_id}
    # ClickText                   Save and continue editing                               anchor=Save and add another
    # VerifyText                  was changed successfully    timeout=4


    # Logout from Robot user to login as user
    Logout_From_Current_User

    # Login as fake user
    Login_As_User


    # Go partner store page select products and comlate order
    # Order_Product_from_Partner_Store
    # GoTo                        ${partner_store_url}        timeout=5
    # VerifyAll                   All products, Store Products
    # TypeText                    Search by name              ${product_credits}
    # VerifyText                  ${product_credits}
    # ClickText                   Add to cart                 anchor=2,500 Credits
    # TypeText                    Search by name              ${product_cloud_advanced}
    # VerifyText                  ${product_cloud_advanced}                               anchor=Product
    # ClickText                   Add to cart                 anchor=PIX4Dcloud Advanced, Yearly, rental
    # ClickText                   Show cart                   anchor=Subtotal:
    # VerifyText                  Complete purchase
    # ClickText                   Complete purchase           anchor=Close
    # VerifyText                  Summary
    # ClickText                   Complete purchase

    # Go partner store page select products and comlate order
    Order_Product_from_Partner_Store


    # Order summary page, verify order, card input
    2Checkout_Order_Summary_With_Retrived_Billing_Info

    # Check credits from Account UI
    Invoice_And_License_Generation_Verication_On_Partner_Page
    # [Documentation]             Verify pruchase from account UI organization page
    # GoTo                        ${partner_home_url}         timeout=5
    # # Verify Invoice product and set invoice variable to variables
    # ClickText                   Invoices                    anchor=Home
    # UseTable                    //*[@data-test\='table']    anchor=Invoices             timeout=3
    # ${invoice_products}=        Get Cell Text               r1c2
    # ${invoice_paid}=            Get Cell Text               r1c6
    # Should Contain              ${invoice_products}         ${product_credits}
    # Should Contain              ${invoice_products}         ${product_cloud_advanced}
    # Should Contain              ${invoice_paid}             PAID
    # ${invoice_number_account_UI}=                           Get Cell Text               r1c1
    # Set Suite Variable          ${invoice_number_account_UI}
    # Log To Console              ${invoice_number_account_UI}
    # # Switch to licence tab verify product, set lisence key to variable
    # ClickText                   Licenses                    anchor=Organization management
    # UseTable                    //*[@data-test\='table']    anchor=Licenses             timeout=3
    # ${license_product}=         Get Cell Text               r1c2
    # Should Contain              ${license_product}          ${license_product_description}
    # ${license_key}=             Get Cell Text               r1c1
    # Set Suite Variable          ${license_key}
    # Log To Console              ${license_key}

    # Logout from User account
    Logout_From_Current_User

    # Login with Robot user to check invoice from Admin Panel
    Robot_Login_To_Staging_AP

    # Verify invoice geneartion with correct product and credit from org page in admin panel
    Verify_Invoice_Generation_With_Correct_Product

    # Back to fake user page and delete user
    GDPR_Deletion_Rondom_User
