*** Settings ***
Documentation    Page object for the store page.
Resource         ../variables/global.resource

*** Variables ***
${HOME_BUTTON}         [data-testid="paginaInicial"]
${INCREASE_BUTTON}     [data-testid="product-increase-quantity"]
${DECREASE_BUTTON}     [data-testid="product-decrease-quantity"]
${CLEAR_LIST_BUTTON}   [data-testid="limparLista"]
${CART_LIST_EMPTY}     [data-testid="shopping-cart-empty-message"]

*** Keywords ***
Back To Home
    [Documentation]    Clicks the "Página Inicial" button to return to the home page.
    Click    ${HOME_BUTTON}

Clear List
    [Documentation]    Clicks the button to clear the shopping list.
    Click    ${CLEAR_LIST_BUTTON}

Add Item To List
    [Documentation]    Finds the product card by its name and clicks the button to add it to the shopping list.
    [Arguments]    ${PRODUCT_NAME}
    ${CARD_XPATH}=    Set Variable
    ...    //h5[contains(@class,"card-title") and contains(normalize-space(.), "${PRODUCT_NAME}")]/ancestor::div[contains(concat(" ", normalize-space(@class), " "), " card ") or contains(@class, "col-3")][1]
    Click    xpath=${CARD_XPATH}//button[@data-testid="adicionarNaLista"]

Item Should Be In List
    [Documentation]    Verifies that the given product is visible in the shopping cart list.
    [Arguments]    ${PRODUCT_NAME}
    ${XPATH}=    Set Variable
    ...    //div[@data-testid="shopping-cart-product-name"][contains(normalize-space(.), "${PRODUCT_NAME}")]
    Wait For Elements State    xpath=${XPATH}    visible    timeout=10s

Increase Quantity of Item in List
    [Documentation]    Clicks the button to increase the quantity of an item already in the shopping list.
    Click    ${INCREASE_BUTTON}

Decrease Quantity of Item in List
    [Documentation]    Clicks the button to decrease the quantity of an item already in the shopping list.
    Click    ${DECREASE_BUTTON}

Item Should Be Increased
    [Documentation]    Verifies that the quantity of the given product has been increased in the shopping list.
    [Arguments]    ${PRODUCT_NAME}
    ${XPATH}=    Set Variable
    ...    //div[@id='root']/div[@class='App']/div/div[@class='jumbotron']/div[@class='container-fluid']/div/section[@class='row espacamento']/div[@class='card col-3'][1]/div[@class='card-body']/div[@class='row']/div[@class='col-3'][2]/p
    Wait For Elements State    xpath=${XPATH}    visible    timeout=10s
    ${QUANTITY_TXT}=    Get Text    xpath=${XPATH}
    ${QUANTITY}=    Convert To Integer    ${QUANTITY_TXT}
    Should be True    ${QUANTITY} > 1    msg=Expected quantity to be greater than 1, but got ${QUANTITY}.

Item Should Be Decreased
    [Documentation]    Verifies that the quantity of the given product has been decreased in the shopping list.
    [Arguments]    ${PRODUCT_NAME}
    ${XPATH}=    Set Variable
    ...    //div[@id='root']/div[@class='App']/div/div[@class='jumbotron']/div[@class='container-fluid']/div/section[@class='row espacamento']/div[@class='card col-3'][1]/div[@class='card-body']/div[@class='row']/div[@class='col-3'][2]/p
    Wait For Elements State    xpath=${XPATH}    visible    timeout=10s
    ${QUANTITY_TXT}=    Get Text    xpath=${XPATH}
    ${QUANTITY}=    Convert To Integer    ${QUANTITY_TXT}
    Should be True    ${QUANTITY} == 1    msg=Expected quantity to be 1, but got ${QUANTITY}.

Product Card Should Not Be In Catalog
    [Documentation]    Confirms that no product card in the catalog matches
    ...                the given product name (e.g. after it has been added
    ...                to the shopping list, which removes it from the
    ...                catalog grid).
    [Arguments]    ${PRODUCT_NAME}
    ${CARD_XPATH}=    Set Variable
    ...    //h5[contains(@class,"card-title") and contains(normalize-space(.), "${PRODUCT_NAME}")]
    Wait For Elements State    xpath=${CARD_XPATH}    hidden    timeout=10s

Double Click Increase Quantity Button
    [Documentation]    Double-clicks the button to increase the quantity of
    ...                an item already in the shopping list (submitting it
    ...                twice in rapid succession), to verify it registers
    ...                as two separate increments rather than one being
    ...                skipped or duplicated (race condition check).
    Click With Options    ${INCREASE_BUTTON}    left    clickCount=2

Item Quantity Should Be
    [Documentation]    Verifies that the quantity of the given product in
    ...                the shopping list matches the expected value.
    [Arguments]    ${PRODUCT_NAME}    ${EXPECTED_QUANTITY}
    ${XPATH}=    Set Variable
    ...    //div[@id='root']/div[@class='App']/div/div[@class='jumbotron']/div[@class='container-fluid']/div/section[@class='row espacamento']/div[@class='card col-3'][1]/div[@class='card-body']/div[@class='row']/div[@class='col-3'][2]/p
    Wait For Elements State    xpath=${XPATH}    visible    timeout=10s
    ${QUANTITY_TXT}=    Get Text    xpath=${XPATH}
    ${QUANTITY}=    Convert To Integer    ${QUANTITY_TXT}
    Should Be Equal As Integers    ${QUANTITY}    ${EXPECTED_QUANTITY}
    ...    msg=Expected quantity of "${PRODUCT_NAME}" to be ${EXPECTED_QUANTITY}, but got ${QUANTITY}.

Decrease Button Should Be Disabled
    [Documentation]    Confirms that the "decrease quantity" button is
    ...                disabled once the item's quantity is already at the
    ...                minimum (1), giving the user clear feedback that no
    ...                further decrease is possible.
    ${DISABLED}=    Get Property    ${DECREASE_BUTTON}    disabled
    Should Be True    ${DISABLED}
    ...    msg=Expected the decrease button to be disabled when quantity is already at the minimum (1), but it was still enabled.

List Should Be Empty
    [Documentation]    Verifies that the shopping list is empty.
    Wait For Elements State    ${CART_LIST_EMPTY}    visible    timeout=10s
