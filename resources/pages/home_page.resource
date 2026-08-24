*** Settings ***
Documentation    Page object for the customer home page (${BASE_URL}/home).
Resource         ../variables/global.resource


*** Variables ***
${LOGOUT_BUTTON}        [data-testid="logout"]
${CREATE_USER_BUTTON}   [data-testid="cadastrarUsuarios"]
${LIST_USERS_BUTTON}    [data-testid="listarUsuarios"]
${USERS_TABLE}          xpath=//table[contains(@class,'table-striped')]
${CREATE_PRODUCT_BUTTON}    [data-testid="cadastrarProdutos"]
${LIST_PRODUCTS_BUTTON}     [data-testid="listarProdutos"]
${PRODUCTS_TABLE}           xpath=//table[contains(@class,'table-striped')]

*** Keywords ***
Home Page Should Be Displayed
    [Documentation]    Confirms that the user was redirected to the customer
    ...                home page after login (URL and an element exclusive
    ...                to the home page, such as the logout button, visible).
    ...                Waits for the logout button because the redirect
    ...                is done via SPA (client-side), asynchronously after
    ...                clicking "Entrar".
    Wait For Elements State    ${LOGOUT_BUTTON}    visible
    ${CURRENT_URL}=    Get Url
    Should Be Equal As Strings    ${CURRENT_URL}    ${BASE_URL}/home

Admin Page Should Be Displayed
    [Documentation]    Confirms that the user was redirected to the admin
    ...                home page after login (URL and an element exclusive
    ...                to the admin page, such as the logout button, visible).
    ...                Waits for the logout button because the redirect
    ...                is done via SPA (client-side), asynchronously after
    ...                clicking "Entrar".
    Wait For Elements State    ${LOGOUT_BUTTON}    visible
    ${CURRENT_URL}=    Get Url
    Should Be Equal As Strings    ${CURRENT_URL}    ${BASE_URL}/admin/home

Click Logout Button
    [Documentation]    Clicks the logout button to end the current user's session.
    Click    ${LOGOUT_BUTTON}

Click Editar Button For User
    [Documentation]    Clicks the "Editar" button on the users table row
    ...                matching the given email.
    [Arguments]    ${EMAIL}
    ${ROW}=    Set Variable    ${USERS_TABLE}//tr[td[normalize-space(text())='${EMAIL}']]
    Wait For Elements State    ${ROW}    visible    timeout=10s
    Click    ${ROW}//button[normalize-space(text())='Editar']

Click Excluir Button For User
    [Documentation]    Clicks the "Excluir" button on the users table row
    ...                matching the given email.
    [Arguments]    ${EMAIL}
    ${ROW}=    Set Variable    ${USERS_TABLE}//tr[td[normalize-space(text())='${EMAIL}']]
    Wait For Elements State    ${ROW}    visible    timeout=10s
    Click    ${ROW}//button[normalize-space(text())='Excluir']

User Row Should Not Be Displayed
    [Documentation]    Confirms that no row in the users table matches the
    ...                given email (e.g. after deleting that user).
    [Arguments]    ${EMAIL}
    ${ROW}=    Set Variable    ${USERS_TABLE}//tr[td[normalize-space(text())='${EMAIL}']]
    Wait For Elements State    ${ROW}    hidden    timeout=10s

Some Editable Field Should Appear
    [Documentation]    Confirms that clicking "Editar" produced some way to
    ...                edit the user — at least one input field must be
    ...                present on the page (e.g. inline editable fields, or
    ...                a form/modal with inputs).
    ${INPUTS}=    Get Elements    //input
    ${COUNT}=    Get Length    ${INPUTS}
    Should Be True    ${COUNT} > 0
    ...    msg=Expected at least one editable input field to appear after clicking "Editar", but found none.

Click Cadastrar Button On Cadastro De Usuario Card
    [Documentation]    Clicks the "Cadastrar" button on the "Cadastro de Usuario"
    ...                card, which is only visible to admin users.
    Click    ${CREATE_USER_BUTTON}

Click Listar Button On Listar Usuarios Card
    [Documentation]    Clicks the "Listar" button on the "Listar Usuarios"
    ...                card, which is only visible to admin users.
    Click    ${LIST_USERS_BUTTON}

Users Table Should Be Displayed
    [Documentation]    Confirms that the users table is displayed on the page.
    Wait For Elements State    ${USERS_TABLE}    visible

Click Editar Button For Product
    [Documentation]    Clicks the "Editar" button on the products table row
    ...                matching the given product name.
    [Arguments]    ${PRODUCT_NAME}
    ${ROW}=    Set Variable    ${PRODUCTS_TABLE}//tr[td[normalize-space(text())='${PRODUCT_NAME}']]
    Wait For Elements State    ${ROW}    visible    timeout=10s
    Click    ${ROW}//button[normalize-space(text())='Editar']

Click Excluir Button For Product
    [Documentation]    Clicks the "Excluir" button on the products table row
    ...                matching the given product name.
    [Arguments]    ${PRODUCT_NAME}
    ${ROW}=    Set Variable    ${PRODUCTS_TABLE}//tr[td[normalize-space(text())='${PRODUCT_NAME}']]
    Wait For Elements State    ${ROW}    visible    timeout=10s
    Click    ${ROW}//button[normalize-space(text())='Excluir']

Product Row Should Not Be Displayed
    [Documentation]    Confirms that no row in the products table matches
    ...                the given product name (e.g. after deleting it).
    [Arguments]    ${PRODUCT_NAME}
    ${ROW}=    Set Variable    ${PRODUCTS_TABLE}//tr[td[normalize-space(text())='${PRODUCT_NAME}']]
    Wait For Elements State    ${ROW}    hidden    timeout=10s

Click Cadastrar Button On Cadastrar Produtos Card
    [Documentation]    Clicks the "Cadastrar" button on the "Cadastrar Produtos"
    ...                card, which is only visible to admin users.
    Click    ${CREATE_PRODUCT_BUTTON}

Click Listar Button On Listar Produtos Card
    [Documentation]    Clicks the "Listar" button on the "Listar Produtos"
    ...                card, which is only visible to admin users.
    Click    ${LIST_PRODUCTS_BUTTON}

Products Table Should Be Displayed
    [Documentation]    Confirms that the products table is displayed on the page.
    Wait For Elements State    ${PRODUCTS_TABLE}    visible

Navigate To Admin Home Page
    [Documentation]    Navigates directly to the admin home page URL, without
    ...                going through the login form.
    Go To    ${BASE_URL}/admin/home

Navigate To Home Page
    [Documentation]    Navigates directly to the regular user home page URL,
    ...                without going through the login form.
    Go To    ${BASE_URL}/home

Admin Page Should Not Be Displayed
    [Documentation]    Confirms that the admin home page is NOT accessible:
    ...                an admin-only element (the "Cadastrar Usuários" button)
    ...                must not be visible, and the current URL must not be
    ...                the admin home URL.
    ...                KNOWN ISSUE: as of this writing, the ServeRest
    ...                front-end does not enforce role-based access control —
    ...                any authenticated user (not only admins) can reach
    ...                /admin/home. This keyword documents the expected,
    ...                correct behavior, so it currently fails until that
    ...                authorization defect is fixed.
    Wait For Elements State    ${CREATE_USER_BUTTON}    hidden    timeout=5s
    ${CURRENT_URL}=    Get Url
    Should Not Be Equal As Strings    ${CURRENT_URL}    ${BASE_URL}/admin/home