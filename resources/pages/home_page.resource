*** Settings ***
Documentation    Page object for the customer home page (${BASE_URL}/home).
Resource         ../variables/global.resource


*** Variables ***
${LOGOUT_BUTTON}    [data-testid="logout"]


*** Keywords ***
Home Page Should Be Displayed
    [Documentation]    Confirms that the user was redirected to the customer
    ...                home page after login (URL and an element exclusive
    ...                to the home page, such as the logout button, visible).
    ...                Waits for the logout button because the redirect
    ...                is done via SPA (client-side), asynchronously after
    ...                clicking "Entrar".
    Wait For Elements State    ${LOGOUT_BUTTON}    visible
    ${current_url}=    Get Url
    Should Be Equal As Strings    ${current_url}    ${BASE_URL}/home
