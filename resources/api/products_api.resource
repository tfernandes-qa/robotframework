*** Settings ***
Documentation    Support keywords that use the ServeRest API to prepare
...              and clean up test data (products) used by the UI tests.
...              Unlike the user routes, the product routes require an admin
...              authorization token.
Library          RequestsLibrary
Library          Collections
Resource         ../variables/global.resource


*** Keywords ***
Get Admin Auth Token
    [Documentation]    Logs in, via API, with the given admin credentials and
    ...                returns the authorization token required by the
    ...                product creation/deletion routes.
    [Arguments]    ${EMAIL}    ${PASSWORD}
    ${BODY}=    Create Dictionary    email=${EMAIL}    password=${PASSWORD}
    ${RESPONSE}=    POST    ${API_BASE_URL}/login    json=${BODY}    expected_status=200
    ${TOKEN}=    Set Variable    ${RESPONSE.json()}[authorization]
    RETURN    ${TOKEN}

Create Product Via Api
    [Documentation]    Creates, via API, a product with the given fields,
    ...                using the given admin authorization token, and
    ...                returns the id of the created product.
    [Arguments]    ${NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}    ${ADMIN_TOKEN}
    ${BODY}=    Create Dictionary
    ...    nome=${NAME}
    ...    preco=${PRICE}
    ...    descricao=${DESCRIPTION}
    ...    quantidade=${QUANTITY}
    ${HEADERS}=    Create Dictionary    Authorization=${ADMIN_TOKEN}
    ${RESPONSE}=    POST    ${API_BASE_URL}/produtos    json=${BODY}    headers=${HEADERS}    expected_status=201
    ${PRODUCT_ID}=    Set Variable    ${RESPONSE.json()}[_id]
    RETURN    ${PRODUCT_ID}

Delete Product Via Api
    [Documentation]    Removes, via API, the product created for the test,
    ...                using the given admin authorization token.
    [Arguments]    ${PRODUCT_ID}    ${ADMIN_TOKEN}
    ${HEADERS}=    Create Dictionary    Authorization=${ADMIN_TOKEN}
    DELETE    ${API_BASE_URL}/produtos/${PRODUCT_ID}    headers=${HEADERS}    expected_status=200

Get Products By Name Via Api
    [Documentation]    Queries, via API, all products registered with the given
    ...                name, returning how many were found and the list of
    ...                matching product records.
    [Arguments]    ${NAME}
    ${PARAMS}=    Create Dictionary    nome=${NAME}
    ${RESPONSE}=    GET    ${API_BASE_URL}/produtos    params=${PARAMS}    expected_status=200
    ${QUANTITY}=    Set Variable    ${RESPONSE.json()}[quantidade]
    ${PRODUCTS}=    Set Variable    ${RESPONSE.json()}[produtos]
    RETURN    ${QUANTITY}    ${PRODUCTS}

Delete All Products With Name Via Api
    [Documentation]    Removes, via API, every product registered with the given
    ...                name, using the given admin authorization token. Used to
    ...                clean up after tests that intentionally try to create
    ...                duplicated products.
    [Arguments]    ${NAME}    ${ADMIN_TOKEN}
    ${QUANTITY}    ${PRODUCTS}=    Get Products By Name Via Api    ${NAME}
    FOR    ${PRODUCT}    IN    @{PRODUCTS}
        Delete Product Via Api    ${PRODUCT}[_id]    ${ADMIN_TOKEN}
    END

Cleanup Product By Name Via Api
    [Documentation]    Obtains a fresh admin token with the given credentials
    ...                and removes, via API, every product registered with the
    ...                given name. Used to clean up after tests that create a
    ...                product via the UI, where no product id is known.
    [Arguments]    ${NAME}    ${EMAIL}    ${PASSWORD}
    ${ADMIN_TOKEN}=    Get Admin Auth Token    ${EMAIL}    ${PASSWORD}
    Delete All Products With Name Via Api    ${NAME}    ${ADMIN_TOKEN}
