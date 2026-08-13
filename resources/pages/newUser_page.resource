*** Settings ***
Documentation    Page object for the admin create user page.
Resource         ../variables/global.resource

*** Variables ***
${NEW_USER_NAME}    [data-testid="nome"]
${NEW_USER_EMAIL}    [data-testid="email"]
${NEW_USER_PASSWORD}    [data-testid="password"]
${NEW_USER_CADASTRAR_BUTTON}    [data-testid="cadastrarUsuario"]

*** Keywords ***
Input New Name 
    [Documentation]    Fills in the name field on the new user registration form.
    [Arguments]    ${name}
    Fill Text    ${NEW_USER_NAME}    ${name}

Input New Email
    [Documentation]    Fills in the email field on the new user registration form.
    [Arguments]    ${email}
    Fill Text    ${NEW_USER_EMAIL}    ${email}

Input New Password
    [Documentation]    Fills in the password field on the new user registration form.
    [Arguments]    ${password}
    Fill Text    ${NEW_USER_PASSWORD}    ${password}

Click Cadastrar Button
    [Documentation]    Clicks the "Cadastrar" button to submit the new user registration form.
    Click    ${NEW_USER_CADASTRAR_BUTTON}

Double Click Cadastrar Button
    [Documentation]    Double-clicks the "Cadastrar" button on the new user
    ...                registration form (submitting it twice in rapid
    ...                succession), to verify the form does not create
    ...                duplicated users when submitted twice.
    Click With Options    ${NEW_USER_CADASTRAR_BUTTON}    left    clickCount=2

User Should Be Created
    [Documentation]    Confirms that the user was created successfully by
    ...                checking for a success message on the screen.
    [Arguments]    ${email}
    ${locator}=    Set Variable    ${USERS_TABLE}//td[normalize-space(text())='${email}']
    Wait For Elements State    ${locator}    visible    timeout=10s