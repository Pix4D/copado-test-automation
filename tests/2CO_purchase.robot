*** Settings ***
Documentation                   E2e test for 2Checkout purchase flow
# Library                         QWeb
# Library                         BuiltIn
# Library                         String
Suite Setup                     Setup Browser
Suite Teardown                  CloseAllBrowsers
Resource                        ../resources/common.robot


*** Variables ***
${BROWSER}                      chrome
# # ${eum_org_name}               CXOps RoboticTesting CREDITS
# ${product_key}                  MAPPER-OTC1-DESKTOP
# ${product_description}          PIX4Dcloud Advanced, Monthly, Subscription
# # credit amount view ui variable
# ${credit_amount_ui}             1,000
# ${total_user_credit}            2200
# ${product_credit_1000}          CLOUD-CREDITS-1000,CLOUD-ADVANCED-MONTH-SUBS
# ${url_buy_product}              https://dev.account.pix4d.com/complete-purchase?PROD_KEYS=${product_credit_1000}
# ${url_dev}                      https://dev.cloud.pix4d.com
# ${url_account_dev}              https://dev.account.pix4d.com
# ${card_number}                  4111111111111111
# ${card_expiration_date}         0130
# ${card_security_code}           234
# ${cart_holder_name}             John Doe
# ${pandora_migration_task}       https://dev.cloud.pix4d.com/admin/common/admintask/63/change/?_changelist_filters=q%3Dpandora
# ${admin_tasks}                  https://dev.cloud.pix4d.com/admin/common/admintask/


*** Keywords ***
Setup Browser
    ${chrome_options}=          Evaluate                    sys.modules['selenium.webdriver'].ChromeOptions()       sys, selenium.webdriver
    Call Method                 ${chrome_options}           add_experimental_option     prefs                       {'profile.default_content_setting_values.notifications': 2}
    Open Browser                about:blank                 chrome                      options=${chrome_options}



*** Test Cases ***
2Checkout Credit Product Purchase E2E Test Flow
    [Documentation]             2Checkout credit product purchase e2e test flow
    Log                         2CO Test flow is starting                               console=True
    
    # Robot user login to staging admin panel 
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









