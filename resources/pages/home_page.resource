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
    ${current_url}=    Get Url
    Should Be Equal As Strings    ${current_url}    ${BASE_URL}/home

Admin Page Should Be Displayed
    [Documentation]    Confirms that the user was redirected to the admin
    ...                home page after login (URL and an element exclusive
    ...                to the admin page, such as the logout button, visible).
    ...                Waits for the logout button because the redirect
    ...                is done via SPA (client-side), asynchronously after
    ...                clicking "Entrar".
    Wait For Elements State    ${LOGOUT_BUTTON}    visible
    ${current_url}=    Get Url
    Should Be Equal As Strings    ${current_url}    ${BASE_URL}/admin/home

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
    ${current_url}=    Get Url
    Should Not Be Equal As Strings    ${current_url}    ${BASE_URL}/admin/home