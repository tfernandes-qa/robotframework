*** Settings ***
Documentation    Page object for common actions.
Library          Browser
Library          String
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
    ${EMAIL}    ${PASSWORD}    ${USER_ID}=    Create Standard User Via Api
    Set Test Variable    ${EMAIL}    ${EMAIL}
    Set Test Variable    ${PASSWORD}    ${PASSWORD}
    Set Test Variable    ${USER_ID}    ${USER_ID}
    Open Login Page

Prepare Admin Login Test
    [Documentation]    Creates a valid user via API and opens the login page,
    ...                leaving email/password/id available for the test and teardown.
    ${EMAIL}    ${PASSWORD}    ${USER_ID}=    Create Admin User Via Api
    Set Test Variable    ${EMAIL}    ${EMAIL}
    Set Test Variable    ${PASSWORD}    ${PASSWORD}
    Set Test Variable    ${USER_ID}    ${USER_ID}
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
    [Arguments]    ${EXPECTED_MESSAGE}
    Wait For Elements State    ${ALERT_MESSAGE}    visible
    ${ACTUAL_MESSAGE}=    Get Text    ${ALERT_MESSAGE}
    Should Be Equal As Strings    ${ACTUAL_MESSAGE}    ${EXPECTED_MESSAGE}

Generate Random User
    [Documentation]    Return name, email and password using Faker (pt_BR)
    ${FAKE}=    Evaluate    faker.Faker('pt_BR')    modules=faker
    ${NAME}=       Evaluate    $FAKE.name()
    ${EMAIL}=      Evaluate    $FAKE.email()
    ${PASSWORD}=   Generate Random Password
    RETURN    ${NAME}    ${EMAIL}    ${PASSWORD}

Generate Random Password
    [Documentation]    Generates a random password with a default length of 10 characters.
    [Arguments]    ${LENGTH}=10
    ${PASSWORD}=    Generate Random String    ${LENGTH}    [LOWER][UPPER][NUMBERS]
    RETURN    ${PASSWORD}

Generate Random Product
    [Documentation]    Return name, price, description and quantity using Faker (pt_BR)
    ${FAKE}=            Evaluate    faker.Faker('pt_BR')    modules=faker
    ${PRODUCT_NAME}=     Evaluate    $FAKE.word()
    ${PRICE}=           Evaluate    $FAKE.random_number(digits=5, fix_len=True)
    ${DESCRIPTION}=     Evaluate    $FAKE.sentence()
    ${QUANTITY}=        Evaluate    $FAKE.random_number(digits=2, fix_len=True)
    RETURN    ${PRODUCT_NAME}    ${PRICE}    ${DESCRIPTION}    ${QUANTITY}
