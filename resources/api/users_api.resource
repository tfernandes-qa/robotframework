*** Settings ***
Documentation    Support keywords that use the ServeRest API to prepare
...              and clean up test data used by the UI tests.
Library          RequestsLibrary
Library          Collections
Library          String
Resource         ../variables/global.resource


*** Keywords ***
Create Standard User Via Api
    [Documentation]    Creates, via API, a standard (non-admin) user with a
    ...                unique email and returns the email, password, and id
    ...                of the created user, to be used in the UI login test.
    ${name}    ${email}    ${password}=    Generate Random User
    ${body}=    Create Dictionary
    ...    nome=${name}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=false
    ${response}=    POST    ${API_BASE_URL}/usuarios    json=${body}    expected_status=201
    ${user_id}=    Set Variable    ${response.json()}[_id]
    RETURN    ${email}    ${password}    ${user_id}

Create Admin User Via Api
    [Documentation]    Creates, via API, an admin user with a
    ...                unique email and returns the email, password, and id
    ...                of the created user, to be used in the UI login test.
    ${name}    ${email}    ${password}=    Generate Random User
    ${body}=    Create Dictionary
    ...    nome=${name}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=true
    ${response}=    POST    ${API_BASE_URL}/usuarios    json=${body}    expected_status=201
    ${user_id}=    Set Variable    ${response.json()}[_id]
    RETURN    ${email}    ${password}    ${user_id}

Delete User Via Api
    [Documentation]    Removes, via API, the user created for the test, keeping
    ...                the environment's test data clean.
    [Arguments]    ${user_id}
    DELETE    ${API_BASE_URL}/usuarios/${user_id}    expected_status=200
