*** Settings ***
Resource         ../../resources/variables/global.resource
Resource         ../../resources/pages/global_page.resource
Resource         ../../resources/pages/login_page.resource
Resource         ../../resources/pages/home_page.resource
Resource         ../../resources/pages/newUser_page.resource
Resource         ../../resources/pages/newProduct_page.resource
Resource         ../../resources/api/users_api.resource
Resource         ../../resources/api/products_api.resource
Test Setup       Open Browser To Admin Page
Test Teardown    Cleanup Login Test

*** Test Cases ***
Admin Wants To Create a New User
    [Documentation]    This test case verifies that an admin can create a new user.
    [Tags]    admin    ui    smoke    regression    critical    compat
    [Teardown]    Run Keywords    Delete All Users With Email Via Api    ${EMAIL}
    ...            AND    Cleanup Login Test
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    Given the admin wants to create a new user
    When the admin clicks on the "Cadastrar" button on the Cadastro de Usuário card
    And the admin fills in the user details with valid information      ${NAME}    ${EMAIL}    ${PASSWORD}
    And the admin clicks on the "Cadastrar" button to submit the form
    Then the new user should be created successfully

Admin Wants To See The List Of Users
    [Documentation]    This test case verifies that an admin can see the list of users.
    [Tags]    admin    ui    regression    high
    Given the admin wants to see the list of users
    When the admin clicks on the "Listar" button on the Listar Usuários card
    Then the list of users should be displayed

Admin Can Delete A User From The Users List
    [Documentation]    This test case verifies that an admin can delete an
    ...                existing user from the users list, and that the user
    ...                is actually removed (not just hidden in the UI).
    [Tags]    admin    ui    regression    high
    [Teardown]    Run Keywords    Delete User Via Api    ${TARGET_USER_ID}
    ...            AND    Cleanup Login Test
    Given a user already exists to be managed from the list
    When the admin clicks on the "Listar" button on the Listar Usuários card
    And the admin clicks the "Excluir" button for that user
    Then that user should no longer be listed
    And that user should no longer exist

Admin Should Be Able To Edit An Existing User
    [Documentation]    This test case verifies that an admin can edit an
    ...                existing user by clicking the "Editar" button on the
    ...                users table.
    ...                KNOWN ISSUE: as of this writing, the "Editar" button
    ...                on the ServeRest front-end's user list has no wired
    ...                behavior — clicking it produces no visible change on
    ...                the page (no input field appears, no navigation, no
    ...                modal), so there is currently no way to edit an
    ...                existing user through the UI, even though the button
    ...                is present. This test documents the expected,
    ...                correct behavior, so it currently fails until that
    ...                defect is fixed.
    [Tags]    admin    ui    regression    medium    known-issue    skip
    [Teardown]    Run Keywords    Delete User Via Api    ${TARGET_USER_ID}
    ...            AND    Cleanup Login Test
    Given a user already exists to be managed from the list
    When the admin clicks on the "Listar" button on the Listar Usuários card
    And the admin clicks the "Editar" button for that user
    Then some editable field for that user should appear

Admin Wants To Create A New Product
    [Documentation]    This test case verifies that an admin can create a new product.
    [Tags]    admin    ui    smoke    regression    critical    compat
    [Teardown]    Run Keywords    Cleanup Product By Name Via Api    ${PRODUCT_NAME}    ${EMAIL}    ${PASSWORD}
    ...            AND    Cleanup Login Test
    ${PRODUCT_NAME}      ${PRICE}    ${DESCRIPTION}      ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${PRODUCT_NAME}      ${PRICE}    ${DESCRIPTION}      ${QUANTITY}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the new product should be created successfully    ${PRODUCT_NAME}

Admin Wants To List All Products
    [Documentation]    This test case verifies that an admin can see the list of products.
    [Tags]    admin    ui    regression    high
    Given the admin wants to see the list of products
    When the admin clicks on the "Listar" button on the Listar Produtos card
    Then the list of products should be displayed

Admin Can Delete A Product From The Products List
    [Documentation]    This test case verifies that an admin can delete an
    ...                existing product from the products list, and that
    ...                the product is actually removed (not just hidden in
    ...                the UI).
    [Tags]    admin    ui    regression    high
    [Teardown]    Run Keywords    Cleanup Product By Name Via Api    ${TARGET_PRODUCT_NAME}    ${EMAIL}    ${PASSWORD}
    ...            AND    Cleanup Login Test
    Given a product already exists to be managed from the list
    When the admin clicks on the "Listar" button on the Listar Produtos card
    And the admin clicks the "Excluir" button for that product
    Then that product should no longer be listed
    And that product should no longer exist

Admin Should Be Able To Edit An Existing Product
    [Documentation]    This test case verifies that an admin can edit an
    ...                existing product by clicking the "Editar" button on
    ...                the products table.
    ...                KNOWN ISSUE: as of this writing, the "Editar" button
    ...                on the ServeRest front-end's product list has no
    ...                wired behavior — clicking it produces no visible
    ...                change on the page (no input field appears, no
    ...                navigation, no modal), so there is currently no way
    ...                to edit an existing product through the UI, even
    ...                though the button is present. Same defect as the
    ...                users list's "Editar" button. This test documents
    ...                the expected, correct behavior, so it currently
    ...                fails until that defect is fixed.
    [Tags]    admin    ui    regression    medium    known-issue    skip
    [Teardown]    Run Keywords    Cleanup Product By Name Via Api    ${TARGET_PRODUCT_NAME}    ${EMAIL}    ${PASSWORD}
    ...            AND    Cleanup Login Test
    Given a product already exists to be managed from the list
    When the admin clicks on the "Listar" button on the Listar Produtos card
    And the admin clicks the "Editar" button for that product
    Then some editable field for that product should appear

Admin Can Access The Regular User Home Page
    [Documentation]    This test case verifies that an admin user, who holds
    ...                higher privileges, can also access the regular user's
    ...                home page (store) directly, without being blocked.
    [Tags]    admin    login    ui    regression    high
    Given an admin user is logged in
    When this admin user navigates directly to the regular home URL
    Then the home page should be displayed

Admin Cannot Create User With Duplicated Email
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new user using an email that is already registered.
    [Tags]    admin    ui    regression    high    negative
    [Teardown]    Run Keywords    Delete User Via Api    ${DUPLICATE_USER_ID}
    ...            AND    Cleanup Login Test
    Given a user already exists with a known email
    When the admin tries to create a new user with the same email
    Then the message "Este email já está sendo usado" must appear

Admin Cannot Create User With Blank Name
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new user when the name field is left blank.
    [Tags]    admin    ui    regression    medium    negative
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    Given the admin wants to create a new user
    When the admin clicks on the "Cadastrar" button on the Cadastro de Usuário card
    And the admin fills in the user email and password only    ${EMAIL}    ${PASSWORD}
    And the admin clicks on the "Cadastrar" button to submit the form
    Then the message "Nome é obrigatório" must appear

Admin Cannot Create User With Blank Password
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new user when the password field is left blank.
    [Tags]    admin    ui    regression    medium    negative
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    Given the admin wants to create a new user
    When the admin clicks on the "Cadastrar" button on the Cadastro de Usuário card
    And the admin fills in the user name and email only    ${NAME}    ${EMAIL}
    And the admin clicks on the "Cadastrar" button to submit the form
    Then the message "Password é obrigatório" must appear

Admin Cannot Create User With Invalid Email Format
    [Documentation]    This test case verifies that the admin cannot submit
    ...                the new user form with an invalid email format. The
    ...                browser's own email input validation blocks the form
    ...                from being submitted at all, same as on the login
    ...                screen.
    [Tags]    admin    ui    regression    medium    negative    compat
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    Given the admin wants to create a new user
    When the admin clicks on the "Cadastrar" button on the Cadastro de Usuário card
    And the admin fills in the user details with valid information      ${NAME}    not-an-email    ${PASSWORD}
    And the admin clicks on the "Cadastrar" button to submit the form
    Then the admin should remain on the create user form

Admin Cannot Create Product With Duplicated Name
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new product using a name that is already registered.
    [Tags]    admin    ui    regression    high    negative
    [Teardown]    Run Keywords    Delete Product Via Api    ${DUPLICATE_PRODUCT_ID}    ${ADMIN_TOKEN}
    ...            AND    Cleanup Login Test
    Given a product already exists with a known name
    When the admin tries to create a new product with the same name
    Then the message "Já existe produto com esse nome" must appear

Admin Cannot Create Product With Negative Price
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new product with a negative price. Price is a
    ...                financial field, so this is a critical validation to
    ...                have covered.
    [Tags]    admin    ui    regression    critical    negative
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${NAME}    -50    ${DESCRIPTION}    ${QUANTITY}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the message "Preco deve ser um número positivo" must appear

Admin Cannot Create Product With Zero Price
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new product with a price of zero — the app treats
    ...                zero as not a positive number.
    [Tags]    admin    ui    regression    critical    negative
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${NAME}    0    ${DESCRIPTION}    ${QUANTITY}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the message "Preco deve ser um número positivo" must appear

Admin Cannot Type Non-Numeric Characters Into Price Or Quantity Fields
    [Documentation]    This test case verifies that the price and quantity
    ...                fields, being number inputs, structurally reject any
    ...                non-numeric keystrokes — typing letters into either
    ...                field leaves it empty rather than accepting literal
    ...                text.
    [Tags]    admin    ui    regression    medium    negative    compat
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin types non-numeric text into the price and quantity fields    abc
    Then the price and quantity fields should remain empty

Admin Cannot Create Product With Decimal Price
    [Documentation]    This test case verifies that the admin cannot submit
    ...                the new product form with an excessively precise
    ...                decimal price (e.g. more decimal places than a
    ...                cent). The price field has no explicit "step"
    ...                attribute, so the browser defaults to whole numbers
    ...                only — any fractional value is blocked by the
    ...                browser's own field validation before the form can
    ...                be submitted.
    [Tags]    admin    ui    regression    medium    negative    compat
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${NAME}    10.123456789    ${DESCRIPTION}    ${QUANTITY}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the admin should remain on the create product form

Admin Can Create Product With Price In Scientific Notation
    [Documentation]    This test case documents that the price field
    ...                accepts scientific notation (e.g. "1e3"), which the
    ...                app treats as a valid positive number and creates
    ...                the product with — a boundary case worth having
    ...                under regression, since it could otherwise slip
    ...                through as unintended input.
    [Tags]    admin    ui    regression    medium
    [Teardown]    Run Keywords    Cleanup Product By Name Via Api    ${PRODUCT_NAME}    ${EMAIL}    ${PASSWORD}
    ...            AND    Cleanup Login Test
    ${PRODUCT_NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${PRODUCT_NAME}    1e3    ${DESCRIPTION}    ${QUANTITY}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the new product should be created successfully    ${PRODUCT_NAME}

Admin Cannot Create Product With Negative Quantity
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new product with a negative quantity.
    [Tags]    admin    ui    regression    medium    negative
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${NAME}    ${PRICE}    ${DESCRIPTION}    -5
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the message "Quantidade deve ser maior ou igual a 0" must appear

Admin Can Create Product With Zero Quantity
    [Documentation]    This test case documents that a quantity of zero is
    ...                accepted (an out-of-stock product) — consistent
    ...                with the negative-quantity message wording ("maior
    ...                ou igual a 0").
    [Tags]    admin    ui    regression    medium
    [Teardown]    Run Keywords    Cleanup Product By Name Via Api    ${PRODUCT_NAME}    ${EMAIL}    ${PASSWORD}
    ...            AND    Cleanup Login Test
    ${PRODUCT_NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${PRODUCT_NAME}    ${PRICE}    ${DESCRIPTION}    0
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the new product should be created successfully    ${PRODUCT_NAME}

Admin Cannot Create Product With Decimal Quantity
    [Documentation]    This test case verifies that the admin cannot submit
    ...                the new product form with a decimal quantity. The
    ...                quantity field has no explicit "step" attribute, so
    ...                the browser defaults to whole numbers only — any
    ...                fractional value is blocked by the browser's own
    ...                field validation before the form can be submitted.
    [Tags]    admin    ui    regression    medium    negative    compat
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${NAME}    ${PRICE}    ${DESCRIPTION}    2.5
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the admin should remain on the create product form

Admin Cannot Create Product With Blank Name
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new product when the name field is left blank.
    [Tags]    admin    ui    regression    medium    negative
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product price, description and quantity only    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the message "Nome é obrigatório" must appear

Admin Cannot Create Product With Blank Description
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new product when the description field is left
    ...                blank.
    [Tags]    admin    ui    regression    medium    negative
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product name, price and quantity only    ${NAME}    ${PRICE}    ${QUANTITY}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the message "Descricao é obrigatório" must appear

Double Click On Submit Should Not Create Duplicated User
    [Documentation]    This test case verifies that double-clicking the
    ...                "Cadastrar" button on the new user registration form
    ...                does not create two users with the same data.
    [Tags]    admin    ui    regression    medium    negative
    [Teardown]    Run Keywords    Delete All Users With Email Via Api    ${NEW_USER_EMAIL}
    ...            AND    Cleanup Login Test
    Given the admin fills in valid user details
    When the admin double clicks the submit button
    Then only one user should be created with that email

*** Keywords ***
Open Browser To Admin Page
    [Documentation]    Opens the browser and navigates to the admin page.
    Prepare Admin Login Test
    Input Email    ${EMAIL}
    Input Password    ${PASSWORD}
    Click Entrar Button
    Admin Page Should Be Displayed

the admin wants to create a new user
    No Operation

the admin clicks on the "Cadastrar" button on the Cadastro de Usuário card
    Click Cadastrar Button On Cadastro De Usuario Card

the admin fills in the user details with valid information
    [Arguments]    ${NAME}     ${EMAIL}    ${PASSWORD}
    Input New Name    ${NAME}
    Input New Email    ${EMAIL}
    Input New Password    ${PASSWORD}

the admin clicks on the "Cadastrar" button to submit the form
    Click Cadastrar Button

the new user should be created successfully
    User Should Be Created    ${EMAIL}

the admin wants to see the list of users
    No Operation

the admin clicks on the "Listar" button on the Listar Usuários card
    Click Listar Button On Listar Usuarios Card

Then the list of users should be displayed
    Users Table Should Be Displayed

the admin wants to create a new product
    No Operation

the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    Click Cadastrar Button On Cadastrar Produtos Card

the admin fills in the product details with valid information
    [Arguments]    ${PRODUCT_NAME}      ${PRICE}    ${DESCRIPTION}      ${QUANTITY}
    Input New Product Name    ${PRODUCT_NAME}
    Input New Product Price    ${PRICE}
    Input New Product Description    ${DESCRIPTION}
    Input New Product Quantity    ${QUANTITY}

the admin clicks on the "Cadastrar" button to submit the product form
    Click Cadastrar Button on New Product Form

the new product should be created successfully
    [Arguments]    ${PRODUCT_NAME}
    Product Should Be Created    ${PRODUCT_NAME}

the admin wants to see the list of products
    No Operation

the admin clicks on the "Listar" button on the Listar Produtos card
    Click Listar Button On Listar Produtos Card

Then the list of products should be displayed
    Products Table Should Be Displayed

the admin types non-numeric text into the price and quantity fields
    [Arguments]    ${TEXT}
    Type Non Numeric Text Into Price Field    ${TEXT}
    Type Non Numeric Text Into Quantity Field    ${TEXT}

the price and quantity fields should remain empty
    Price Field Should Be Empty
    Quantity Field Should Be Empty

the admin should remain on the create product form
    Create Product Form Should Still Be Displayed

the admin fills in the product price, description and quantity only
    [Arguments]    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}
    Input New Product Price    ${PRICE}
    Input New Product Description    ${DESCRIPTION}
    Input New Product Quantity    ${QUANTITY}

the admin fills in the product name, price and quantity only
    [Arguments]    ${NAME}    ${PRICE}    ${QUANTITY}
    Input New Product Name    ${NAME}
    Input New Product Price    ${PRICE}
    Input New Product Quantity    ${QUANTITY}

a product already exists to be managed from the list
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    ${TOKEN}=    Get Admin Auth Token    ${EMAIL}    ${PASSWORD}
    ${PRODUCT_ID}=    Create Product Via Api    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}    ${TOKEN}
    Set Test Variable    ${TARGET_PRODUCT_NAME}    ${NAME}

the admin clicks the "Excluir" button for that product
    Click Excluir Button For Product    ${TARGET_PRODUCT_NAME}

the admin clicks the "Editar" button for that product
    Click Editar Button For Product    ${TARGET_PRODUCT_NAME}

that product should no longer be listed
    Product Row Should Not Be Displayed    ${TARGET_PRODUCT_NAME}

that product should no longer exist
    ${QUANTITY}    ${PRODUCTS}=    Get Products By Name Via Api    ${TARGET_PRODUCT_NAME}
    Should Be Equal As Integers    ${QUANTITY}    0

some editable field for that product should appear
    Some Editable Field Should Appear

an admin user is logged in
    No Operation

this admin user navigates directly to the regular home URL
    Navigate To Home Page

the home page should be displayed
    Home Page Should Be Displayed

a user already exists with a known email
    ${DUPLICATE_EMAIL}    ${DUPLICATE_PASSWORD}    ${DUPLICATE_USER_ID}=    Create Standard User Via Api
    Set Test Variable    ${DUPLICATE_EMAIL}    ${DUPLICATE_EMAIL}
    Set Test Variable    ${DUPLICATE_USER_ID}    ${DUPLICATE_USER_ID}

the admin tries to create a new user with the same email
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    Click Cadastrar Button On Cadastro De Usuario Card
    Input New Name    ${NAME}
    Input New Email    ${DUPLICATE_EMAIL}
    Input New Password    ${PASSWORD}
    Click Cadastrar Button

the admin fills in the user email and password only
    [Arguments]    ${EMAIL}    ${PASSWORD}
    Input New Email    ${EMAIL}
    Input New Password    ${PASSWORD}

the admin fills in the user name and email only
    [Arguments]    ${NAME}    ${EMAIL}
    Input New Name    ${NAME}
    Input New Email    ${EMAIL}

the admin should remain on the create user form
    Create User Form Should Still Be Displayed

a user already exists to be managed from the list
    ${TARGET_EMAIL}    ${TARGET_PASSWORD}    ${TARGET_USER_ID}=    Create Standard User Via Api
    Set Test Variable    ${TARGET_EMAIL}    ${TARGET_EMAIL}
    Set Test Variable    ${TARGET_USER_ID}    ${TARGET_USER_ID}

the admin clicks the "Excluir" button for that user
    Click Excluir Button For User    ${TARGET_EMAIL}

the admin clicks the "Editar" button for that user
    Click Editar Button For User    ${TARGET_EMAIL}

that user should no longer be listed
    User Row Should Not Be Displayed    ${TARGET_EMAIL}

that user should no longer exist
    ${QUANTITY}    ${USERS}=    Get Users By Email Via Api    ${TARGET_EMAIL}
    Should Be Equal As Integers    ${QUANTITY}    0

some editable field for that user should appear
    Some Editable Field Should Appear

a product already exists with a known name
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    ${ADMIN_TOKEN}=    Get Admin Auth Token    ${EMAIL}    ${PASSWORD}
    ${PRODUCT_ID}=    Create Product Via Api    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}    ${ADMIN_TOKEN}
    Set Test Variable    ${DUPLICATE_PRODUCT_NAME}    ${NAME}
    Set Test Variable    ${DUPLICATE_PRODUCT_ID}    ${PRODUCT_ID}
    Set Test Variable    ${ADMIN_TOKEN}    ${ADMIN_TOKEN}

the admin tries to create a new product with the same name
    ${OTHER_NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    Click Cadastrar Button On Cadastrar Produtos Card
    Input New Product Name    ${DUPLICATE_PRODUCT_NAME}
    Input New Product Price    ${PRICE}
    Input New Product Description    ${DESCRIPTION}
    Input New Product Quantity    ${QUANTITY}
    Click Cadastrar Button on New Product Form

the message "${MESSAGE}" must appear
    Alert Message Should Be    ${MESSAGE}

the admin fills in valid user details
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    Click Cadastrar Button On Cadastro De Usuario Card
    Input New Name    ${NAME}
    Input New Email    ${EMAIL}
    Input New Password    ${PASSWORD}
    Set Test Variable    ${NEW_USER_EMAIL}    ${EMAIL}

the admin double clicks the submit button
    Double Click Cadastrar Button

only one user should be created with that email
    User Should Be Created    ${NEW_USER_EMAIL}
    ${QUANTITY}    ${USERS}=    Get Users By Email Via Api    ${NEW_USER_EMAIL}
    Should Be Equal As Integers    ${QUANTITY}    1
