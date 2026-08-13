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
    [Tags]    admin    ui    smoke    regression    critical
    ${name}    ${email}    ${password}=    Generate Random User
    Given the admin wants to create a new user   
    When the admin clicks on the "Cadastrar" button on the Cadastro de Usuário card
    And the admin fills in the user details with valid information      ${name}    ${email}    ${password}
    And the admin clicks on the "Cadastrar" button to submit the form
    Then the new user should be created successfully

Admin Wants To See The List Of Users
    [Documentation]    This test case verifies that an admin can see the list of users.
    [Tags]    admin    ui    regression    high
    Given the admin wants to see the list of users
    When the admin clicks on the "Listar" button on the Listar Usuários card
    Then the list of users should be displayed

Admin Wants To Create A New Product
    [Documentation]    This test case verifies that an admin can create a new product.
    [Tags]    admin    ui    smoke    regression    critical
    ${productName}      ${price}    ${description}      ${quantity}=    Generate Random Product
    Given the admin wants to create a new product
    When the admin clicks on the "Cadastrar" button on the Cadastrar Produtos card
    And the admin fills in the product details with valid information       ${productName}      ${price}    ${description}      ${quantity}
    And the admin clicks on the "Cadastrar" button to submit the product form
    Then the new product should be created successfully    ${productName}

Admin Wants To List All Products
    [Documentation]    This test case verifies that an admin can see the list of products.
    [Tags]    admin    ui    regression    high
    Given the admin wants to see the list of products
    When the admin clicks on the "Listar" button on the Listar Produtos card
    Then the list of products should be displayed

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

Admin Cannot Create Product With Duplicated Name
    [Documentation]    This test case verifies that the admin cannot create
    ...                a new product using a name that is already registered.
    [Tags]    admin    ui    regression    high    negative
    [Teardown]    Run Keywords    Delete Product Via Api    ${DUPLICATE_PRODUCT_ID}    ${ADMIN_TOKEN}
    ...            AND    Cleanup Login Test
    Given a product already exists with a known name
    When the admin tries to create a new product with the same name
    Then the message "Já existe produto com esse nome" must appear

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
    Input Email    ${email}
    Input Password    ${password}
    Click Entrar Button
    Admin Page Should Be Displayed

the admin wants to create a new user 
    No Operation

the admin clicks on the "Cadastrar" button on the Cadastro de Usuário card
    Click Cadastrar Button On Cadastro De Usuario Card

the admin fills in the user details with valid information
    [Arguments]    ${name}     ${email}    ${password}    
    Input New Name    ${name}
    Input New Email    ${email}
    Input New Password    ${password}
    

the admin clicks on the "Cadastrar" button to submit the form
    Click Cadastrar Button

the new user should be created successfully
    User Should Be Created    ${email}

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
    [Arguments]    ${productName}      ${price}    ${description}      ${quantity}    
    Input New Product Name    ${productName}
    Input New Product Price    ${price}
    Input New Product Description    ${description}
    Input New Product Quantity    ${quantity}

the admin clicks on the "Cadastrar" button to submit the product form
    Click Cadastrar Button on New Product Form

the new product should be created successfully
    [Arguments]    ${productName}
    Product Should Be Created    ${productName}

the admin wants to see the list of products
    No Operation

the admin clicks on the "Listar" button on the Listar Produtos card
    Click Listar Button On Listar Produtos Card

Then the list of products should be displayed
    Products Table Should Be Displayed

an admin user is logged in
    No Operation

this admin user navigates directly to the regular home URL
    Navigate To Home Page

the home page should be displayed
    Home Page Should Be Displayed

a user already exists with a known email
    ${duplicate_email}    ${duplicate_password}    ${duplicate_user_id}=    Create Standard User Via Api
    Set Test Variable    ${DUPLICATE_EMAIL}    ${duplicate_email}
    Set Test Variable    ${DUPLICATE_USER_ID}    ${duplicate_user_id}

the admin tries to create a new user with the same email
    ${name}    ${email}    ${password}=    Generate Random User
    Click Cadastrar Button On Cadastro De Usuario Card
    Input New Name    ${name}
    Input New Email    ${DUPLICATE_EMAIL}
    Input New Password    ${password}
    Click Cadastrar Button

a product already exists with a known name
    ${name}    ${price}    ${description}    ${quantity}=    Generate Random Product
    ${admin_token}=    Get Admin Auth Token    ${EMAIL}    ${PASSWORD}
    ${product_id}=    Create Product Via Api    ${name}    ${price}    ${description}    ${quantity}    ${admin_token}
    Set Test Variable    ${DUPLICATE_PRODUCT_NAME}    ${name}
    Set Test Variable    ${DUPLICATE_PRODUCT_ID}    ${product_id}
    Set Test Variable    ${ADMIN_TOKEN}    ${admin_token}

the admin tries to create a new product with the same name
    ${other_name}    ${price}    ${description}    ${quantity}=    Generate Random Product
    Click Cadastrar Button On Cadastrar Produtos Card
    Input New Product Name    ${DUPLICATE_PRODUCT_NAME}
    Input New Product Price    ${price}
    Input New Product Description    ${description}
    Input New Product Quantity    ${quantity}
    Click Cadastrar Button on New Product Form

the message "${message}" must appear
    Alert Message Should Be    ${message}

the admin fills in valid user details
    ${name}    ${email}    ${password}=    Generate Random User
    Click Cadastrar Button On Cadastro De Usuario Card
    Input New Name    ${name}
    Input New Email    ${email}
    Input New Password    ${password}
    Set Test Variable    ${NEW_USER_EMAIL}    ${email}

the admin double clicks the submit button
    Double Click Cadastrar Button

only one user should be created with that email
    User Should Be Created    ${NEW_USER_EMAIL}
    ${quantity}    ${users}=    Get Users By Email Via Api    ${NEW_USER_EMAIL}
    Should Be Equal As Integers    ${quantity}    1