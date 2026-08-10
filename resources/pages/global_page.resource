*** Settings ***
Documentation    Page object for the customer home page (${BASE_URL}/home).
Library          Browser
Resource         ../variables/global.resource
Resource         ../../resources/api/users_api.resource

*** Variables ***


*** Keywords ***
Open Login Page
    [Documentation]    Opens a new browser/context/page already on the login screen.
    New Browser    browser=${BROWSER}    headless=${HEADLESS}
    New Context
    New Page    ${BASE_URL}/login

Prepare Login Test
    [Documentation]    Creates a valid user via API and opens the login page,
    ...                leaving email/password/id available for the test and teardown.
    ${email}    ${password}    ${user_id}=    Create Standard User Via Api
    Set Test Variable    ${EMAIL}    ${email}
    Set Test Variable    ${PASSWORD}    ${password}
    Set Test Variable    ${USER_ID}    ${user_id}
    Open Login Page

Cleanup Login Test
    [Documentation]    Closes the browser and removes, via API, the user created in the setup.
    Close Browser
    Delete User Via Api    ${USER_ID}
