*** Settings ***
Documentation    ServeRest Front login tests (${BASE_URL}).
Resource         ../../resources/variables/global.resource
Resource         ../../resources/pages/global_page.resource
Resource         ../../resources/pages/login_page.resource
Resource         ../../resources/pages/home_page.resource
Resource         ../../resources/api/users_api.resource
Test Setup       Prepare Login Test
Test Teardown    Cleanup Login Test


*** Test Cases ***
User With Valid Credentials Should Be Redirected To The Home
    [Documentation]    A user who enters a valid email and password and clicks
    ...                "Entrar" must be redirected to the home page.
    [Tags]    login    ui    smoke    regression    critical
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then this user must be redirected to the home page

Admin Can Access Admin Page
    [Documentation]    This test case verifies that an admin user can access the admin page.
    [Tags]    admin    login    ui    smoke    regression    critical
    Given the admin user wants to access the admin page
    When this admin user types the email and password
    Then the admin page should be displayed

User With Invalid Email Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    email.invalido@qa.com.br
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

User With Invalid Password Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And this user types the password    senhaInvalida123
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

User With Blank Email Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the password     ${PASSWORD}
    And clicks on Entrar
    Then the message "Email é obrigatório" must appear

User With Blank Password Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And clicks on Entrar
    Then the message "Password é obrigatório" must appear

User With Invalid Email Format Should See Error Message
    [Documentation]    A user who enters a valid email and password and clicks
    ...                "Entrar" must be redirected to the home page.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    teste@teste
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then the message "Email deve ser um email válido" must appear

User With Invalidated Session Should Be Redirected To The Login Page
    [Documentation]    A logged in user whose session token becomes invalid
    ...                and who then tries to reach the admin home page must
    ...                be redirected back to the login page.
    [Tags]    login    admin    ui    regression    high
    Given a logged in user is on the home page
    When the user session token is invalidated
    And the user navigates to the admin home page
    Then this user must be redirected to the login page

Regular User Should Not Be Able To Access The Admin Home Page
    [Documentation]    A logged in regular (non-admin) user who navigates
    ...                directly to the admin home URL must not see the admin
    ...                page and must be redirected to their own home page.
    ...                KNOWN ISSUE: the ServeRest front-end currently does
    ...                not enforce this restriction (see `Admin Page Should
    ...                Not Be Displayed`), so this test is expected to fail
    ...                until that authorization defect is fixed.
    [Tags]    login    admin    security    ui    regression    high    known-issue     skip
    Given a regular user is logged in
    When this user navigates directly to the admin home URL
    Then the admin page should not be displayed
    And this user must be redirected to the home page

*** Keywords ***
a user is trying to login
    No Operation

this user types the email
    [Arguments]    ${EMAIL}
    Input Email    ${EMAIL}

this user types the password
    [Arguments]    ${PASSWORD}
    Input Password    ${PASSWORD}

clicks on Entrar
    Click Entrar Button

this user must be redirected to the home page
    Home Page Should Be Displayed

the message "${MESSAGE}" must appear
    Login Error Message Should Be    ${MESSAGE}

the admin user wants to access the admin page
    Prepare Admin Login Test

this admin user types the email and password
    Input Email    ${EMAIL}
    Input Password    ${PASSWORD}
    Click Entrar Button

the admin page should be displayed
    Admin Page Should Be Displayed

a logged in user is on the home page
    Input Email    ${EMAIL}
    Input Password    ${PASSWORD}
    Click Entrar Button
    Home Page Should Be Displayed

the user session token is invalidated
    Invalidate User Session Token

the user navigates to the admin home page
    Navigate To Admin Home Page

this user must be redirected to the login page
    Login Page Should Be Displayed

a regular user is logged in
    a logged in user is on the home page

this user navigates directly to the admin home URL
    Navigate To Admin Home Page

the admin page should not be displayed
    Admin Page Should Not Be Displayed
