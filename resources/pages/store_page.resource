*** Settings ***
Documentation    Page object for the store page.
Resource         ../variables/global.resource

*** Variables ***
${HOME_BUTTON}         [data-testid="paginaInicial"]
${ADD_TO_LIST_BUTTON}   [data-testid="product-increase-quantity"]
${CLEAR_LIST_BUTTON}    [data-testid="limparLista"]
${CART_LIST_EMPTY}    [data-testid="shopping-cart-empty-message"]

*** Keywords ***
Back To Home
    [Documentation]    Clicks the "Página Inicial" button to return to the home page.
    Click    ${HOME_BUTTON}

Clear List
    [Documentation]    Clicks the button to clear the shopping list.
    Click    ${CLEAR_LIST_BUTTON}

Add Item To List
    [Documentation]    Finds the product card by its name and clicks the button to add it to the shopping list.
    [Arguments]    ${product_name}
    ${card_xpath}=    Set Variable
    ...    //h5[contains(@class,"card-title") and contains(normalize-space(.), "${product_name}")]/ancestor::div[contains(concat(" ", normalize-space(@class), " "), " card ") or contains(@class, "col-3")][1]
    Click    xpath=${card_xpath}//button[@data-testid="adicionarNaLista"]

Item Should Be In List
    [Documentation]    Verifies that the given product is visible in the shopping cart list.
    [Arguments]    ${product_name}
    ${xpath}=    Set Variable
    ...    //div[@data-testid="shopping-cart-product-name"][contains(normalize-space(.), "${product_name}")]
    Wait For Elements State    xpath=${xpath}    visible    timeout=10s

Increase Quantity of Item in List
    [Documentation]    Clicks the button to increase the quantity of an item already in the shopping list.
    Click    ${ADD_TO_LIST_BUTTON}

Item Should Be Increased
    [Documentation]    Verifies that the quantity of the given product has been increased in the shopping list.
    [Arguments]    ${product_name}
    ${xpath}=    Set Variable
    ...    //div[@id='root']/div[@class='App']/div/div[@class='jumbotron']/div[@class='container-fluid']/div/section[@class='row espacamento']/div[@class='card col-3'][1]/div[@class='card-body']/div[@class='row']/div[@class='col-3'][2]/p
    Wait For Elements State    xpath=${xpath}    visible    timeout=10s
    ${quantity_txt}=    Get Text    xpath=${xpath}
    ${quantity}=    Convert To Integer    ${quantity_txt}
    Should be True    ${quantity} > 1    msg=Expected quantity to be greater than 1, but got ${quantity}.

List Should Be Empty
    [Documentation]    Verifies that the shopping list is empty.
    Wait For Elements State    ${CART_LIST_EMPTY}    visible    timeout=10s
