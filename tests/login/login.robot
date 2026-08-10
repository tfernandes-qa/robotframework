*** Settings ***
Documentation    ServeRest Front login tests (${BASE_URL}).
Resource         ../../resources/variables/global.resource
Resource         ../../resources/pages/login_page.resource
Resource         ../../resources/pages/home_page.resource
Resource         ../../resources/api/users_api.resource
Test Setup       Prepare Login Test
Test Teardown    Cleanup Login Test


*** Test Cases ***
Usuario Com Credenciais Validas Deve Ser Redirecionado Para A Home
    [Documentation]    A user who enters a valid email and password and clicks
    ...                "Entrar" must be redirected to the home page.
    [Tags]    login    smoke
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then this user must be redirected to the home page

Usuario Com Email Invalido Deve Ver Mensagem De Erro
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login
    Given a user is trying to login
    When this user types the email    email.invalido@qa.com.br
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

Usuario Com Senha Invalida Deve Ver Mensagem De Erro
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And this user types the password    senhaInvalida123
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

Usuario Com Email Em Branco Deve Ver Mensagem De Erro
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login
    Given a user is trying to login
    When this user types the password     ${PASSWORD}
    And clicks on Entrar
    Then the message "Email é obrigatório" must appear

Usuario Com Senha Em Branco Deve Ver Mensagem De Erro
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And clicks on Entrar
    Then the message "Password é obrigatório" must appear

Usuario Com Email De Formato Invalido Deve Ver Mensagem De Erro
    [Documentation]    A user who enters a valid email and password and clicks
    ...                "Entrar" must be redirected to the home page.
    [Tags]    login    smoke
    Given a user is trying to login
    When this user types the email    teste@teste
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then the message "Email deve ser um email válido" must appear

*** Keywords ***
Prepare Login Test
    [Documentation]    Creates a valid user via API and opens the login page,
    ...                leaving email/password/id available for the test and teardown.
    ${email}    ${password}    ${user_id}=    Create Standard User Via Api
    Set Test Variable    ${EMAIL}    ${email}
    Set Test Variable    ${PASSWORD}    ${password}
    Set Test Variable    ${USER_ID}    ${user_id}
    Open Login Page

Cleanup Login Test
    [Documentation]    Closes the browser and removes, via API, the user created in the setup.
    Close Browser
    Delete User Via Api    ${USER_ID}

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
