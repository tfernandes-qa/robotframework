*** Settings ***
Documentation    Page object for common actions.
Library          Browser
Resource         ../variables/global.resource
Resource         ../../resources/api/users_api.resource

*** Variables ***
${ALERT_MESSAGE}    .alert-dismissible > span


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

Prepare Admin Login Test
    [Documentation]    Creates a valid user via API and opens the login page,
    ...                leaving email/password/id available for the test and teardown.
    ${email}    ${password}    ${user_id}=    Create Admin User Via Api
    Set Test Variable    ${EMAIL}    ${email}
    Set Test Variable    ${PASSWORD}    ${password}
    Set Test Variable    ${USER_ID}    ${user_id}
    Open Login Page

Cleanup Login Test
    [Documentation]    Closes the browser and removes, via API, the user created in the setup.
    Close Browser
    Delete User Via Api    ${USER_ID}

Invalidate User Session Token
    [Documentation]    Clears the browser's local storage, invalidating the
    ...                logged in user's session token, to simulate an
    ...                expired or otherwise invalid session.
    LocalStorage Clear

Alert Message Should Be
    [Documentation]    Confirms that the alert message displayed on the
    ...                current page matches the expected one. Several forms
    ...                across the app (login, new user, new product, ...)
    ...                share this same generic dismissible alert component.
    [Arguments]    ${expected_message}
    Wait For Elements State    ${ALERT_MESSAGE}    visible
    ${actual_message}=    Get Text    ${ALERT_MESSAGE}
    Should Be Equal As Strings    ${actual_message}    ${expected_message}

Generate Random User
    [Documentation]    Return name, email and password using Faker (pt_BR)
    ${fake}=    Evaluate    faker.Faker('pt_BR')    modules=faker
    ${name}=       Evaluate    $fake.name()
    ${email}=      Evaluate    $fake.email()
    ${password}=   Generate Random Password
    RETURN    ${name}    ${email}    ${password}

Generate Random Password
    [Documentation]    Generates a random password with a default length of 10 characters.
    [Arguments]    ${length}=10
    ${password}=    Generate Random String    ${length}    [LOWER][UPPER][NUMBERS]
    RETURN    ${password}

Generate Random Product
    [Documentation]    Return name, price, description and quantity using Faker (pt_BR)
    ${fake}=            Evaluate    faker.Faker('pt_BR')    modules=faker
    ${productName}=     Evaluate    $fake.word()
    ${price}=           Evaluate    $fake.random_number(digits=5, fix_len=True)
    ${description}=     Evaluate    $fake.sentence()
    ${quantity}=        Evaluate    $fake.random_number(digits=2, fix_len=True)
    RETURN    ${productName}    ${price}    ${description}    ${quantity}