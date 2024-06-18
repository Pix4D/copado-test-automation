*** Settings ***
Library                     QWeb

*** Variables ***
${partner_account_base_url}                             https://dev.partner.pix4d.com
${url_account_dev}          https://dev.account.pix4d.com
${url_credit}               https://dev.account.pix4d.com/credits
${url_download}             https://dev.account.pix4d.com/download-software
${eum_org_name}             TestCXops EumRedirection space



*** Keywords ***
EUM_User_Login_To_Partner_Dev
    [Documentation]         Robot loging to staging Admin Panel
    GoTo                    ${partner_account_base_url}                             timeout=5
    TypeText                Enter email                 ${ui_test_username}
    ClickText               Continue
    VerifyText              Log in
    TypeText                Enter password              ${ui_test_password}
    ClickText               Log in                      anchor=Back




Redirect_Credit_And_Verify_Org_Selection
    VerifyText              Log in                      timeout=5
    GoTo                    ${url_credit}               timeout=5
    VerifyAll               Select an organization to continue, ${eum_org_name}



Select_Org_and_Verify_Credit_Page_Component
    # GoTo                  ${url_credit}               timeout=5
    VerifyAll               Select an organization to continue, ${eum_org_name}
    ClickText               ${eum_org_name}
    ClickText               Continue                    anchor=Go Home              timeout=5
    VerifyText              Credit transactions         anchor=Home
    VerifyText              Credits                     anchor=//[@class\='credits-label']
    # VerifyText            Estimate how many credits you need                      anchor=//[@title\='Estimate how many credits you need']
    VerifyText              Credit history              anchor=See how many credits you have used in the past


Redirect_Download_And_Verify_Org_Selection
    GoTo                    ${url_download}             timeout=5
    VerifyAll               Select an organization to continue, ${eum_org_name}


Download_Page_Component
    # VerifyText            Download software           anchor=Home
    # ClickText             Download software           anchor=Home
    # VerifyAll             Select an organization to continue, ${eum_org_name}
    ClickText               ${eum_org_name}
    ClickText               Continue                    anchor=Go Home              timeout=5
    # VerifyAll             Select an organization to continue, ${eum_org_name}
    VerifyText              Your products
    VerifyText              PIX4Dreact                  index=1
    VerifyText              PIX4Dfields                 index=1
    ScrollText              Discover more products
    VerifyText              Discover more products

