*** Settings ***
Documentation                   E2e test for 2Checkout purchase flow
Suite Setup                     Open Browser                about:blank                 ${BROWSER}
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot


*** Variables ***
${BROWSER}                      chrome


*** Test Cases ***
2Checkout Credit Product Purchase E2E Test Flow
    [Documentation]             2Checkout credit product purchase e2e test flow
    Log                         2CO credit product purchase e2e test flow is starting                               console=True
    # Robot user login to staging
    Robot_Login_To_Staging_AP
    # Verify user and get necessary org value
    Robot_User_Verify_And_Save_Data
    # Create fake rondom user: Generate rondom data, fill the form and store data
    Create_New_Rondom_User
    # Migrate user to pandora: You'll get EUM org
    Migrate_User_To_Pandora_Verify_Execution
    # Back to user page and verifies the migration from user page
    Verify_EUM_Org_Migration_From_User_Page
    # From user to org page and get uuid and set
    Get_EUM_Org_uuid_And_Set_Acount_UI_path
    # Set EUM org billling info from org page
    Set_EUM_Org_Billing_Info
    # Get Billing info ID from ORG page
    Get_Billing_Info_Id_From_EUM_Org_Page
    # Link user to the ORG billing info: from org page to admin
    Link_The_User_To_The_Org_Billing_Info
    # Logout from Robot user to login as user
    Logout_From_Current_User
    # Login as fake user
    Login_As_User
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
