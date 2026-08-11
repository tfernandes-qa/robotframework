*** Settings ***
Resource         ../../resources/variables/global.resource
Resource         ../../resources/pages/global_page.resource
Resource         ../../resources/pages/login_page.resource
Resource         ../../resources/pages/home_page.resource
Resource         ../../resources/pages/newUser_page.resource
Resource         ../../resources/pages/newProduct_page.resource
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