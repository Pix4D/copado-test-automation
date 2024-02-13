*** Settings ***

Documentation              New test suite
Library                    QWeb
Suite Setup                Open Browser                about:blank                 chrome
Suite Teardown             Close All Browsers
Resource                   ../resources/common.robot
Resource                   ../resources/licenses.robot
Resource                   ../resources/invoices.robot

*** Test Cases ***
    # Create pix4d User
    #                      [Documentation]
    #                      [Tags]
    #                      LoginApp
    #                      CreateUser

    # Validate User exist
    #                      [Documentation]             This will validate the user exist
    #                      GoTo                        ${url}/admin_panel/users/
    #                      TypeText                    username, name, email, company,                    Kwakman
    #                      ClickText                   SEARCH
    #                      UseTable                    xpath\=//table[@data-upgraded\=",MaterialDataTable"]
    #                      VerifyTable                 r1c6                        Kwakman


    # Create Invoice
    #                      [Documentation]             Test for creating invoice
    #                      LoginApp
    #                      CreateLicense2              cxops.robot@pix4d.work      MAPPER-OTC-DESKTOP: PIX4Dmapper Desktop, Perpetual license    Yes    TEST_CXOps_QA
    #                      Add Invoice                 Oem                         PCH - Pix4D SA (Switzerland)              Australia    ref_doc    AEC Software Bundle Yearly (PIX4Dmatic & PIX4Dsurvey & PIX4Dcloud Advanced) [MATIC-SURVEY-CLOUD-ADVANCED-YEAR]



User journay
    LoginApp
    CreateUser
    Hubspot sync verify
    CreateLicense
    CreateInvoice
    # license creation
    GoTo                   https://dev.cloud.pix4d.com/admin_panel/pixuser/796960/edit/
    # ClickText              playlist_add                # clicks license create button
    # DropDown               Product code                MAPPER-OTC1-DESKTOP: PIX4Dmapper Desktop, Single device, Perpetual license    # DropDown template
    # ClickText              Yes
    # TypeText               comment                     TEST_CXOps_QA
    # ClickText              Save
    # GoTo                   ${my_user_url}              # back to user page
    # VerifyText             Product key                 # ScrollText                Add-Ons can be use
    # UseTable               ID
    # ClickCell              r1c1                        # Go license page
    # ${license_key}         GetText                     //a[@title\='Download Licence']
    # Set Suite Variable     ${license_key}
    # Log To Console         ${license_key}
    # create invoice
    ClickText              Create invoice
    TypeText               Company or Client Name      ${email_address}
    TypeText               license id/sn               ${license_key}
    ClickText              ${license_key}              anchor=2
    ClickText              Save
    GoTo                   ${my_user_url}              # back to user page
    ClickText              GDPR Deletion
    CloseAlert             accept                      10s
    VerifyText             Account disabled upon GDPR request from data subject


