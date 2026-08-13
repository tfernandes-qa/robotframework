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
    [Arguments]    ${email}    ${password}
    ${body}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    ${API_BASE_URL}/login    json=${body}    expected_status=200
    ${token}=    Set Variable    ${response.json()}[authorization]
    RETURN    ${token}

Create Product Via Api
    [Documentation]    Creates, via API, a product with the given fields,
    ...                using the given admin authorization token, and
    ...                returns the id of the created product.
    [Arguments]    ${name}    ${price}    ${description}    ${quantity}    ${admin_token}
    ${body}=    Create Dictionary
    ...    nome=${name}
    ...    preco=${price}
    ...    descricao=${description}
    ...    quantidade=${quantity}
    ${headers}=    Create Dictionary    Authorization=${admin_token}
    ${response}=    POST    ${API_BASE_URL}/produtos    json=${body}    headers=${headers}    expected_status=201
    ${product_id}=    Set Variable    ${response.json()}[_id]
    RETURN    ${product_id}

Delete Product Via Api
    [Documentation]    Removes, via API, the product created for the test,
    ...                using the given admin authorization token.
    [Arguments]    ${product_id}    ${admin_token}
    ${headers}=    Create Dictionary    Authorization=${admin_token}
    DELETE    ${API_BASE_URL}/produtos/${product_id}    headers=${headers}    expected_status=200
