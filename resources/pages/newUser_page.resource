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
    [Arguments]    ${NAME}
    Fill Text    ${NEW_USER_NAME}    ${NAME}

Input New Email
    [Documentation]    Fills in the email field on the new user registration form.
    [Arguments]    ${EMAIL}
    Fill Text    ${NEW_USER_EMAIL}    ${EMAIL}

Input New Password
    [Documentation]    Fills in the password field on the new user registration form.
    [Arguments]    ${PASSWORD}
    Fill Text    ${NEW_USER_PASSWORD}    ${PASSWORD}

Click Cadastrar Button
    [Documentation]    Clicks the "Cadastrar" button to submit the new user registration form.
    Click    ${NEW_USER_CADASTRAR_BUTTON}

Double Click Cadastrar Button
    [Documentation]    Double-clicks the "Cadastrar" button on the new user
    ...                registration form (submitting it twice in rapid
    ...                succession), to verify the form does not create
    ...                duplicated users when submitted twice.
    Click With Options    ${NEW_USER_CADASTRAR_BUTTON}    left    clickCount=2

Create User Form Should Still Be Displayed
    [Documentation]    Confirms that the new user form was not submitted —
    ...                the admin never left the create-user page (used when
    ...                the browser's own field validation blocks submission).
    Wait For Elements State    ${NEW_USER_NAME}    visible    timeout=5s
    ${CURRENT_URL}=    Get Url
    Should Be Equal As Strings    ${CURRENT_URL}    ${BASE_URL}/admin/cadastrarusuarios

User Should Be Created
    [Documentation]    Confirms that the user was created successfully by
    ...                checking for a success message on the screen.
    [Arguments]    ${EMAIL}
    ${LOCATOR}=    Set Variable    ${USERS_TABLE}//td[normalize-space(text())='${EMAIL}']
    Wait For Elements State    ${LOCATOR}    visible    timeout=10s