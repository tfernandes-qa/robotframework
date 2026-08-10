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
    [Arguments]    ${email}
    Fill Text    ${EMAIL_INPUT}    ${email}

Input Password
    [Documentation]    Fills in the password field.
    [Arguments]    ${password}
    Fill Text    ${PASSWORD_INPUT}    ${password}

Click Entrar Button
    [Documentation]    Clicks the "Entrar" button to submit the login form.
    Click    ${LOGIN_BUTTON}

Login Error Message Should Be
    [Documentation]    Confirms that the error message displayed on the login screen
    ...                matches the expected one.
    [Arguments]    ${expected_message}
    Wait For Elements State    ${LOGIN_ERROR_MESSAGE}    visible
    ${actual_message}=    Get Text    ${LOGIN_ERROR_MESSAGE}
    Should Be Equal As Strings    ${actual_message}    ${expected_message}
