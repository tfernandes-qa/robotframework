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

Get Users By Email Via Api
    [Documentation]    Queries, via API, all users registered with the given
    ...                email, returning how many were found and the list of
    ...                matching user records.
    [Arguments]    ${email}
    ${params}=    Create Dictionary    email=${email}
    ${response}=    GET    ${API_BASE_URL}/usuarios    params=${params}    expected_status=200
    ${quantity}=    Set Variable    ${response.json()}[quantidade]
    ${users}=    Set Variable    ${response.json()}[usuarios]
    RETURN    ${quantity}    ${users}

Delete All Users With Email Via Api
    [Documentation]    Removes, via API, every user registered with the given
    ...                email. Used to clean up after tests that intentionally
    ...                try to create duplicated users.
    [Arguments]    ${email}
    ${quantity}    ${users}=    Get Users By Email Via Api    ${email}
    FOR    ${user}    IN    @{users}
        Delete User Via Api    ${user}[_id]
    END
