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

Create Product Form Should Still Be Displayed
    [Documentation]    Confirms that the new product form was not submitted —
    ...                the admin never left the create-product page (used
    ...                when the browser's own field validation, e.g. a
    ...                decimal value typed into the whole-number quantity
    ...                field, blocks submission).
    Wait For Elements State    ${NEW_PRODUCT_NAME}    visible    timeout=5s
    ${CURRENT_URL}=    Get Url
    Should Be Equal As Strings    ${CURRENT_URL}    ${BASE_URL}/admin/cadastrarprodutos

Type Non Numeric Text Into Price Field
    [Documentation]    Simulates real keyboard typing (as opposed to
    ...                directly setting the value) of non-numeric text into
    ...                the price field, since the field only accepts numbers
    ...                (type="number") and silently ignores non-numeric
    ...                keystrokes.
    [Arguments]    ${TEXT}
    Type Text    ${NEW_PRODUCT_PRICE}    ${TEXT}

Type Non Numeric Text Into Quantity Field
    [Documentation]    Simulates real keyboard typing (as opposed to
    ...                directly setting the value) of non-numeric text into
    ...                the quantity field, since the field only accepts
    ...                numbers (type="number") and silently ignores
    ...                non-numeric keystrokes.
    [Arguments]    ${TEXT}
    Type Text    ${NEW_PRODUCT_QUANTITY}    ${TEXT}

Price Field Should Be Empty
    [Documentation]    Confirms the price field's value is empty (used after
    ...                attempting to type non-numeric text into it).
    ${VALUE}=    Get Property    ${NEW_PRODUCT_PRICE}    value
    Should Be Empty    ${VALUE}

Quantity Field Should Be Empty
    [Documentation]    Confirms the quantity field's value is empty (used
    ...                after attempting to type non-numeric text into it).
    ${VALUE}=    Get Property    ${NEW_PRODUCT_QUANTITY}    value
    Should Be Empty    ${VALUE}
