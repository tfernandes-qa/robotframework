*** Settings ***
Documentation    Page object for the admin create product page.
Resource         ../variables/global.resource

*** Variables ***
${NEW_PRODUCT_NAME}    [data-testid="nome"]
${NEW_PRODUCT_PRICE}    [data-testid="preco"]
${NEW_PRODUCT_DESCRIPTION}    [data-testid="descricao"]
${NEW_PRODUCT_QUANTITY}    [data-testid="quantity"]
${NEW_PRODUCT_CADASTRAR_BUTTON}    [data-testid="cadastarProdutos"]

*** Keywords ***
Input New Product Name
    [Documentation]    Fills in the name field on the new product registration form.
    [Arguments]    ${PRODUCT_NAME}
    Fill Text    ${NEW_PRODUCT_NAME}    ${PRODUCT_NAME}

Input New Product Price
    [Documentation]    Fills in the price field on the new product registration form.
    [Arguments]    ${PRICE}
    Fill Text    ${NEW_PRODUCT_PRICE}    ${PRICE}

Input New Product Description
    [Documentation]    Fills in the description field on the new product registration form.
    [Arguments]    ${DESCRIPTION}
    Fill Text    ${NEW_PRODUCT_DESCRIPTION}    ${DESCRIPTION}

Input New Product Quantity
    [Documentation]    Fills in the quantity field on the new product registration form.
    [Arguments]    ${QUANTITY}
    Fill Text    ${NEW_PRODUCT_QUANTITY}    ${QUANTITY}

Click Cadastrar Button on New Product Form
    [Documentation]    Clicks the "Cadastrar" button to submit the new product registration form.
    Click    ${NEW_PRODUCT_CADASTRAR_BUTTON}

Product Should Be Created
    [Documentation]    Verifies that the new product has been created successfully.
    [Arguments]    ${PRODUCT_NAME}
        ${LOCATOR}=    Set Variable    ${USERS_TABLE}//td[normalize-space(text())='${PRODUCT_NAME}']
    Wait For Elements State    ${LOCATOR}    visible    timeout=10s
    # Add verification steps here, such as checking for a success message or the presence of the new product in the product list.
