*** Settings ***
Resource         ../../resources/variables/global.resource
Resource         ../../resources/pages/global_page.resource
Resource         ../../resources/pages/home_page.resource
Resource         ../../resources/pages/login_page.resource
Resource         ../../resources/pages/store_page.resource
Test Setup       Open Browser To Home Page
Test Teardown    Cleanup Login Test

*** Test Cases ***
User Can Add 2 Items to List
    [Documentation]    This test case verifies that a user can add two items to the list.
    [Tags]    store    list    ui    smoke    regression    critical
    Given the user wants to add 2 items to the list   
    When the user adds the first item to the list   Logitech MX Vertical
    And the user adds the second item to the list   Samsung 60 polegadas
    Then the list should contain 2 items

User Can Increase Quantity of an Item in the List
    [Documentation]    This test case verifies that a user can increase the quantity of an item in the list.
    [Tags]    store    list    ui    regression    high
    Given the user wants to increase item in the list   
    When the user adds an item to the list   Logitech MX Vertical
    And the user increases the quantity of the item in the list
    Then the quantity of the item in the list should be bigger than 1

User Can Clear the List
    [Documentation]    This test case verifies that a user can clear the list.
    [Tags]    store    list    ui    regression    high
    Given the user wants to clear the list   
    When the user adds an item to the list   Logitech MX Vertical
    And the user clears the list
    Then the list should be empty

*** Keywords ***
Open Browser To Home Page
    [Documentation]    Opens the browser and navigates to the home page.
    Prepare Login Test
    Input Email    ${email}
    Input Password    ${password}
    Click Entrar Button
    Home Page Should Be Displayed

the user wants to add 2 items to the list  
    No Operation

the user adds the first item to the list
    [Arguments]    ${product_name}
    Add Item To List    ${product_name}
    Back To Home
    
the user adds the second item to the list
    [Arguments]    ${product_name}
    Add Item To List    ${product_name}

the list should contain 2 items
    Item Should Be In List    Logitech MX Vertical
    Item Should Be In List    Samsung 60 polegadas


the user wants to increase item in the list  
    No Operation

the user adds an item to the list
    [Arguments]    ${product_name}
    Add Item To List    ${product_name}

the user increases the quantity of the item in the list
    Increase Quantity of Item in List

the quantity of the item in the list should be bigger than 1
    Item Should Be Increased    Logitech MX Vertical

the user wants to clear the list
    No Operation

the user clears the list
    Clear List

the list should be empty
    List Should Be Empty  