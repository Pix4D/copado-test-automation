*** Settings ***
Documentation                   E2e test for 2Checkout purchase flow
Suite Setup                     Open Browser                about:blank                 ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot


*** Variables ***
${BROWSER}                      chrome
${partner_dev_base_url}         https://dev.partner.pix4d.com

*** Test Cases ***
2Checkout Credit Product Purchase E2E Test Flow
    [Documentation]             2Checkout credit product purchase e2e test flow
    Log                         2CO credit product purchase e2e test flow is starting                 console=True
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
    Get_EUM_Org_uuid_And_Set_Acount_UI_path

    # Set EUM org billling info from org page
    Set_EUM_Org_Billing_Info

    # Get Billing info ID from ORG page
    Get_Billing_Info_Id_From_EUM_Org_Page

    # Link user to the ORG billing info: from org page to admin
    Link_The_User_To_The_Org_Billing_Info

    # Convert Org to Partner og
    # Set store etc
    # https://dev.cloud.pix4d.com/admin/partner/partnerorganization/715/change/
    GoTo                        ${eum_org_url}              timeout=5
    VerifyInputValue            id_uuid                     ${eum_org_uuid}
    VerifyText                  Convert to partner          anchor=Credits
    ClickText                   Convert to partner
    ${partner_org_url}          GetUrl
    Set Suite Variable          ${partner_org_url}
    Log To Console              ${partner_org_url}
    @{partner_org_url_parts}=                               Split String                ${partner_org_url}    /
    ${partner_org_id}=          Set Variable                ${partner_org_url_parts}[5]
    Log To Console              ${partner_org_id}
    Set Suite Variable          ${partner_org_id}
    # Admin partner page: https://dev.cloud.pix4d.com/admin/partner/partnerorganization/716/change/
    ${partner_org_admin_url}    Set Variable                ${url_dev}/admin/partner/partnerorganization/${partner_org_id}/change/
    Set Suite Variable          ${partner_org_admin_url}
    Log To Console              ${partner_org_admin_url}
    # admin now
    GoTo                        ${partner_org_admin_url}    timeout=3
    VerifyText                  Change partner organization                             timeout=3
    DropDown                    Partner type:               Premier Reseller
    TypeText                    id_reference_user           ${fake_user_id}
    DropDown                    Access profile:             Store Premium
    DropDown                    Currency code:              CHF
    TypeText                    id_pix4d_manager            ${fake_user_id}
    ClickText                   Save and continue editing                               anchor=Save and add another
    VerifyText                  was changed successfully    timeout=4
    # we're still on partner admin page
    # ===>

    # logout first
    # login as partner user
    # then go store for purchase => https://dev.partner.pix4d.com/organization/1806fb1a-8356-4eb3-be15-f2c0d75127b6/store-product/all
    # partner store page
    # put in variable => ${partner_dev_base_url}            https://dev.partner.pix4d.com

    # PARTNER STORE
    # ${partner_store_url}      Set Variable                ${partner_dev_base_url}/organization/${eum_org_uuid}/store-product/all
    ${partner_store_url}        Set Variable                https://dev.partner.pix4d.com/organization/${eum_org_uuid}/store-product/all
    Set Suite Variable          ${partner_store_url}
    Log To Console              ${partner_store_url}



    # Logout from Robot user to login as user
    Logout_From_Current_User

    # Login as fake user
    Login_As_User
    
    # HERE ==> 
    
    # Go partner store page
    GoTo                        ${partner_store_url}        timeout=5
    VerifyAll                   All products, Store Products
    TypeText                    Search by name              2,500 Credits              
    VerifyText                  2,500 Credits
    ClickText                   Add to cart                 anchor=2,500 Credits       
    TypeText                    Search by name              PIX4Dcloud Advanced, Yearly, rental
    VerifyText                  PIX4Dcloud Advanced, Yearly, rental                     anchor=Product
    ClickText                   Add to cart                 anchor=PIX4Dcloud Advanced, Yearly, rental 
    ClickText                   Show cart                   anchor=Subtotal:
    VerifyText                  Complete purchase
    ClickText                   Complete purchase           anchor=Close
    VerifyText                  Summary



    # -----
    # 2CO user journey starting with chosed product and credit
    2Checkout_Credit_Product_Order_With_Retrived_Billing_Info

    # Check credits from Account UI
    Verify_Puchased_Credit_From_Account_UI

    # Logout from User account
    Logout_From_Current_User

    # Login with Robot user to check invoice from Admin Panel
    Robot_Login_To_Staging_AP

    # Verify invoice geneartion with correct product and credit from org page in admin panel
    Verify_Invoice_Generation_With_Correct_Product

    # Back to fake user page and delete user
    GDPR_Deletion_Rondom_User
