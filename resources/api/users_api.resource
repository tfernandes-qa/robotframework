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
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    ${BODY}=    Create Dictionary
    ...    nome=${NAME}
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    ...    administrador=false
    ${RESPONSE}=    POST    ${API_BASE_URL}/usuarios    json=${BODY}    expected_status=201
    ${USER_ID}=    Set Variable    ${RESPONSE.json()}[_id]
    RETURN    ${EMAIL}    ${PASSWORD}    ${USER_ID}

Create Admin User Via Api
    [Documentation]    Creates, via API, an admin user with a
    ...                unique email and returns the email, password, and id
    ...                of the created user, to be used in the UI login test.
    ${NAME}    ${EMAIL}    ${PASSWORD}=    Generate Random User
    ${BODY}=    Create Dictionary
    ...    nome=${NAME}
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    ...    administrador=true
    ${RESPONSE}=    POST    ${API_BASE_URL}/usuarios    json=${BODY}    expected_status=201
    ${USER_ID}=    Set Variable    ${RESPONSE.json()}[_id]
    RETURN    ${EMAIL}    ${PASSWORD}    ${USER_ID}

Delete User Via Api
    [Documentation]    Removes, via API, the user created for the test, keeping
    ...                the environment's test data clean.
    [Arguments]    ${USER_ID}
    DELETE    ${API_BASE_URL}/usuarios/${USER_ID}    expected_status=200

Get Users By Email Via Api
    [Documentation]    Queries, via API, all users registered with the given
    ...                email, returning how many were found and the list of
    ...                matching user records.
    [Arguments]    ${EMAIL}
    ${PARAMS}=    Create Dictionary    email=${EMAIL}
    ${RESPONSE}=    GET    ${API_BASE_URL}/usuarios    params=${PARAMS}    expected_status=200
    ${QUANTITY}=    Set Variable    ${RESPONSE.json()}[quantidade]
    ${USERS}=    Set Variable    ${RESPONSE.json()}[usuarios]
    RETURN    ${QUANTITY}    ${USERS}

Delete All Users With Email Via Api
    [Documentation]    Removes, via API, every user registered with the given
    ...                email. Used to clean up after tests that intentionally
    ...                try to create duplicated users.
    [Arguments]    ${EMAIL}
    ${QUANTITY}    ${USERS}=    Get Users By Email Via Api    ${EMAIL}
    FOR    ${USER}    IN    @{USERS}
        Delete User Via Api    ${USER}[_id]
    END
