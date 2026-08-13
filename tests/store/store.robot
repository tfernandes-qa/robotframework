*** Settings ***
Resource         ../../resources/variables/global.resource
Resource         ../../resources/pages/global_page.resource
Resource         ../../resources/api/products_api.resource
Resource         ../../resources/api/users_api.resource
Resource         ../../resources/pages/home_page.resource
Resource         ../../resources/pages/login_page.resource
Resource         ../../resources/pages/store_page.resource
Test Setup       Open Browser To Home Page
Test Teardown    Cleanup Login Test

*** Test Cases ***
User Can Add 2 Items to List
    [Documentation]    This test case verifies that a user can add two items to the list.
    [Tags]    store    list    ui    smoke    regression    critical
    [Teardown]    Run Keywords    Delete Product Via Api    ${PRODUCT_ID_1}    ${ADMIN_TOKEN}
    ...            AND    Delete Product Via Api    ${PRODUCT_ID_2}    ${ADMIN_TOKEN}
    ...            AND    Delete User Via Api    ${ADMIN_ID}
    ...            AND    Cleanup Login Test
    Given the user wants to add 2 items to the list
    When the user adds the first item to the list   ${PRODUCT_NAME_1}
    And the user adds the second item to the list   ${PRODUCT_NAME_2}
    Then the list should contain 2 items

User Can Clear the List
    [Documentation]    This test case verifies that a user can clear the list.
    [Tags]    store    list    ui    regression    high
    [Teardown]    Run Keywords    Delete Product Via Api    ${PRODUCT_ID}    ${ADMIN_TOKEN}
    ...            AND    Delete User Via Api    ${ADMIN_ID}
    ...            AND    Cleanup Login Test
    Given the user wants to clear the list
    When the user adds an item to the list   ${PRODUCT_NAME}
    And the user clears the list
    Then the list should be empty

User Can Increase Quantity of an Item in the List
    [Documentation]    This test case verifies that a user can increase the quantity of an item in the list.
    [Tags]    store    list    ui    regression    high
    [Teardown]    Run Keywords    Delete Product Via Api    ${PRODUCT_ID}    ${ADMIN_TOKEN}
    ...            AND    Delete User Via Api    ${ADMIN_ID}
    ...            AND    Cleanup Login Test
    Given the user wants to increase item in the list
    When the user adds an item to the list   ${PRODUCT_NAME}
    And the user increases the quantity of the item in the list
    Then the quantity of the item in the list should be bigger than 1

User Can Decrease Quantity of an Item in the List
    [Documentation]    This test case verifies that a user can decrease the quantity of an item in the list.
    [Tags]    store    list    ui    regression    high
    [Teardown]    Run Keywords    Delete Product Via Api    ${PRODUCT_ID}    ${ADMIN_TOKEN}
    ...            AND    Delete User Via Api    ${ADMIN_ID}
    ...            AND    Cleanup Login Test
    Given the user wants to decrease item in the list
    When the user adds an item to the list   ${PRODUCT_NAME}
    And the user increases the quantity of the item in the list
    And the user decreases the quantity of the item in the list
    Then the quantity of the item in the list should be 1

*** Keywords ***
Open Browser To Home Page
    [Documentation]    Opens the browser and navigates to the home page.
    Prepare Login Test
    Input Email    ${EMAIL}
    Input Password    ${PASSWORD}
    Click Entrar Button
    Home Page Should Be Displayed

the user wants to add 2 items to the list
    ${NAME_1}    ${PRICE_1}    ${DESCRIPTION_1}    ${QUANTITY_1}=    Generate Random Product
    ${NAME_2}    ${PRICE_2}    ${DESCRIPTION_2}    ${QUANTITY_2}=    Generate Random Product
    ${SUFFIX_1}=    Generate Random String    6    [LOWER][NUMBERS]
    ${SUFFIX_2}=    Generate Random String    6    [LOWER][NUMBERS]
    ${NAME_1}=    Catenate    SEPARATOR=    ${NAME_1}    ${SUFFIX_1}
    ${NAME_2}=    Catenate    SEPARATOR=    ${NAME_2}    ${SUFFIX_2}
    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}    ${ADMIN_ID}=    Create Admin User Via Api
    ${ADMIN_TOKEN}=    Get Admin Auth Token    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${PRODUCT_ID_1}=    Create Product Via Api    ${NAME_1}    ${PRICE_1}    ${DESCRIPTION_1}    ${QUANTITY_1}    ${ADMIN_TOKEN}
    ${PRODUCT_ID_2}=    Create Product Via Api    ${NAME_2}    ${PRICE_2}    ${DESCRIPTION_2}    ${QUANTITY_2}    ${ADMIN_TOKEN}
    Set Test Variable    ${PRODUCT_NAME_1}    ${NAME_1}
    Set Test Variable    ${PRODUCT_NAME_2}    ${NAME_2}
    Set Test Variable    ${PRODUCT_ID_1}    ${PRODUCT_ID_1}
    Set Test Variable    ${PRODUCT_ID_2}    ${PRODUCT_ID_2}
    Set Test Variable    ${ADMIN_ID}    ${ADMIN_ID}
    Set Test Variable    ${ADMIN_TOKEN}    ${ADMIN_TOKEN}
    Reload

the user adds the first item to the list
    [Arguments]    ${PRODUCT_NAME}
    Add Item To List    ${PRODUCT_NAME}
    Back To Home

the user adds the second item to the list
    [Arguments]    ${PRODUCT_NAME}
    Add Item To List    ${PRODUCT_NAME}

the list should contain 2 items
    Item Should Be In List    ${PRODUCT_NAME_1}
    Item Should Be In List    ${PRODUCT_NAME_2}


the user wants to increase item in the list
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    ${SUFFIX}=    Generate Random String    6    [LOWER][NUMBERS]
    ${NAME}=    Catenate    SEPARATOR=    ${NAME}    ${SUFFIX}
    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}    ${ADMIN_ID}=    Create Admin User Via Api
    ${ADMIN_TOKEN}=    Get Admin Auth Token    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${PRODUCT_ID}=    Create Product Via Api    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}    ${ADMIN_TOKEN}
    Set Test Variable    ${PRODUCT_NAME}    ${NAME}
    Set Test Variable    ${PRODUCT_ID}    ${PRODUCT_ID}
    Set Test Variable    ${ADMIN_ID}    ${ADMIN_ID}
    Set Test Variable    ${ADMIN_TOKEN}    ${ADMIN_TOKEN}
    Reload

the user adds an item to the list
    [Arguments]    ${PRODUCT_NAME}
    Add Item To List    ${PRODUCT_NAME}

the user increases the quantity of the item in the list
    Increase Quantity of Item in List

the quantity of the item in the list should be bigger than 1
    Item Should Be Increased    ${PRODUCT_NAME}

the user wants to clear the list
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    ${SUFFIX}=    Generate Random String    6    [LOWER][NUMBERS]
    ${NAME}=    Catenate    SEPARATOR=    ${NAME}    ${SUFFIX}
    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}    ${ADMIN_ID}=    Create Admin User Via Api
    ${ADMIN_TOKEN}=    Get Admin Auth Token    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${PRODUCT_ID}=    Create Product Via Api    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}    ${ADMIN_TOKEN}
    Set Test Variable    ${PRODUCT_NAME}    ${NAME}
    Set Test Variable    ${PRODUCT_ID}    ${PRODUCT_ID}
    Set Test Variable    ${ADMIN_ID}    ${ADMIN_ID}
    Set Test Variable    ${ADMIN_TOKEN}    ${ADMIN_TOKEN}
    Reload

the user clears the list
    Clear List

the list should be empty
    List Should Be Empty

the user wants to decrease item in the list
    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}=    Generate Random Product
    ${SUFFIX}=    Generate Random String    6    [LOWER][NUMBERS]
    ${NAME}=    Catenate    SEPARATOR=    ${NAME}    ${SUFFIX}
    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}    ${ADMIN_ID}=    Create Admin User Via Api
    ${ADMIN_TOKEN}=    Get Admin Auth Token    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${PRODUCT_ID}=    Create Product Via Api    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}    ${ADMIN_TOKEN}
    Set Test Variable    ${PRODUCT_NAME}    ${NAME}
    Set Test Variable    ${PRODUCT_ID}    ${PRODUCT_ID}
    Set Test Variable    ${ADMIN_ID}    ${ADMIN_ID}
    Set Test Variable    ${ADMIN_TOKEN}    ${ADMIN_TOKEN}
    Reload

the user decreases the quantity of the item in the list
    Decrease Quantity of Item in List

the quantity of the item in the list should be 1
    Item Should Be Decreased    ${PRODUCT_NAME}
