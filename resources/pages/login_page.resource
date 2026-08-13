*** Settings ***
Documentation    Page object for the login screen (${BASE_URL}/login).
Resource         ../variables/global.resource

*** Variables ***
${EMAIL_INPUT}             [data-testid="email"]
${PASSWORD_INPUT}          [data-testid="senha"]
${LOGIN_BUTTON}            [data-testid="entrar"]
${LOGIN_ERROR_MESSAGE}     .alert-dismissible > span


*** Keywords ***
Input Email
    [Documentation]    Fills in the email field.
    [Arguments]    ${EMAIL}
    Fill Text    ${EMAIL_INPUT}    ${EMAIL}

Input Password
    [Documentation]    Fills in the password field.
    [Arguments]    ${PASSWORD}
    Fill Text    ${PASSWORD_INPUT}    ${PASSWORD}

Click Entrar Button
    [Documentation]    Clicks the "Entrar" button to submit the login form.
    Click    ${LOGIN_BUTTON}

Login Error Message Should Be
    [Documentation]    Confirms that the error message displayed on the login screen
    ...                matches the expected one.
    [Arguments]    ${EXPECTED_MESSAGE}
    Wait For Elements State    ${LOGIN_ERROR_MESSAGE}    visible
    ${ACTUAL_MESSAGE}=    Get Text    ${LOGIN_ERROR_MESSAGE}
    Should Be Equal As Strings    ${ACTUAL_MESSAGE}    ${EXPECTED_MESSAGE}

Login Page Should Be Displayed
    [Documentation]    Confirms that the user was redirected to the login
    ...                page (e.g. after trying to access a protected page
    ...                with an expired or invalid session), by waiting for
    ...                the email field and checking the current URL.
    Wait For Elements State    ${EMAIL_INPUT}    visible
    ${CURRENT_URL}=    Get Url
    Should Be Equal As Strings    ${CURRENT_URL}    ${BASE_URL}/login
