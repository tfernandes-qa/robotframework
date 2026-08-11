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

*** Keywords ***
a user is trying to login
    No Operation

this user types the email
    [Arguments]    ${email}
    Input Email    ${email}

this user types the password
    [Arguments]    ${password}
    Input Password    ${password}

clicks on Entrar
    Click Entrar Button

this user must be redirected to the home page
    Home Page Should Be Displayed

the message "${message}" must appear
    Login Error Message Should Be    ${message}

the admin user wants to access the admin page
    Prepare Admin Login Test

this admin user types the email and password
    Input Email    ${email}
    Input Password    ${password}
    Click Entrar Button

the admin page should be displayed
    Admin Page Should Be Displayed