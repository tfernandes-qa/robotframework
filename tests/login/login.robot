*** Settings ***
Documentation    ServeRest Front login tests (${BASE_URL}).
Resource         ../../resources/variables/global.resource
Resource         ../../resources/pages/global_page.resource
Resource         ../../resources/pages/login_page.resource
Resource         ../../resources/pages/home_page.resource
Resource         ../../resources/api/users_api.resource
Test Setup       Prepare Login Test
Test Teardown    Cleanup Login Test


*** Test Cases ***
User With Valid Credentials Should Be Redirected To The Home
    [Documentation]    A user who enters a valid email and password and clicks
    ...                "Entrar" must be redirected to the home page.
    [Tags]    login    ui    smoke    regression    critical    compat
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then this user must be redirected to the home page

Admin Can Access Admin Page
    [Documentation]    This test case verifies that an admin user can access the admin page.
    [Tags]    admin    login    ui    smoke    regression    critical    compat
    Given the admin user wants to access the admin page
    When this admin user types the email and password
    Then the admin page should be displayed

User With Invalid Email Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    email.invalido@qa.com.br
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

User With Invalid Password Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And this user types the password    senhaInvalida123
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

User With Blank Email Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the password     ${PASSWORD}
    And clicks on Entrar
    Then the message "Email é obrigatório" must appear

User With Blank Password Should See Error Message
    [Documentation]    A user who enters an invalid email and/or password and clicks
    ...                "Entrar" must see a message informing that the
    ...                credentials are invalid.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And clicks on Entrar
    Then the message "Password é obrigatório" must appear

User With Invalid Email Format Should See Error Message
    [Documentation]    A user who enters a valid email and password and clicks
    ...                "Entrar" must be redirected to the home page.
    [Tags]    login    ui    regression    medium
    Given a user is trying to login
    When this user types the email    teste@teste
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then the message "Email deve ser um email válido" must appear

Login With Padded Email And Password Should Fail
    [Documentation]    A user who enters otherwise valid credentials, but
    ...                with leading and trailing whitespace around the email
    ...                and password, must not be logged in. The app does not
    ...                trim these fields, so the padded values must be
    ...                treated as invalid credentials, same as any other
    ...                mismatch.
    ...                CROSS-BROWSER NOTE: this test is known to fail on
    ...                Firefox — Firefox silently trims leading/trailing
    ...                whitespace from `type="email"` inputs (Chromium and
    ...                WebKit do not), so the email arrives clean while the
    ...                password stays padded; the resulting mismatched
    ...                login then never even fires its network request on
    ...                Firefox. Tracked for a future fix (e.g. pad only the
    ...                password) rather than addressed now.
    [Tags]    login    ui    regression    medium    compat
    Given a user is trying to login
    When this user types the email    ${SPACE}${SPACE}${EMAIL}${SPACE}${SPACE}
    And this user types the password    ${SPACE}${SPACE}${PASSWORD}${SPACE}${SPACE}
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

Login With Uppercased Email Should Fail
    [Documentation]    A user who enters otherwise valid credentials, but
    ...                with the email's case changed (e.g. all uppercase),
    ...                must not be logged in. The app treats the email
    ...                comparison as case-sensitive, so the uppercased
    ...                value must be treated as invalid credentials.
    [Tags]    login    ui    regression    medium
    ${UPPERCASED_EMAIL}=    Convert To Upper Case    ${EMAIL}
    Given a user is trying to login
    When this user types the email    ${UPPERCASED_EMAIL}
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

Login With Excessively Long Email And Password Should Show Validation Error
    [Documentation]    A user who enters an excessively long email (500+
    ...                characters) and password must not be able to log in.
    ...                Neither field enforces a maxlength on the front-end
    ...                (confirmed: the full value is accepted into the
    ...                input), but the app's own email format validation
    ...                rejects a local part that long.
    [Tags]    login    ui    regression    medium
    ${LONG_LOCAL_PART}=    Evaluate    "a" * 500
    ${LONG_EMAIL}=    Catenate    SEPARATOR=${EMPTY}    ${LONG_LOCAL_PART}    @x.com
    Given a user is trying to login
    When this user types the email    ${LONG_EMAIL}
    And this user types the password    ${LONG_EMAIL}
    And clicks on Entrar
    Then the message "Email deve ser um email válido" must appear

Login With Special Characters In Email Should Not Authenticate The User
    [Documentation]    A user who enters special/disallowed characters (such
    ...                as "<" and ">", used here to attempt an XSS payload)
    ...                in the email field must not be authenticated: the
    ...                browser's own email input validation blocks the form
    ...                from being submitted at all, so the user must remain
    ...                on the login page.
    [Tags]    login    security    ui    regression    medium    compat
    Given a user is trying to login
    When this user types the email    <script>alert(1)</script>@x.com
    And this user types the password    ${PASSWORD}
    And clicks on Entrar
    Then this user must remain on the login page

Login With XSS And Unicode Payload In Password Should Fail Safely
    [Documentation]    A user who enters a valid email but a password
    ...                containing script tags, emoji and unicode characters
    ...                must not be authenticated, must see the normal
    ...                invalid-credentials message (proving the payload
    ...                reached the app/API and was rejected as a wrong
    ...                password, not executed as script), and the app must
    ...                not crash or throw any console errors.
    [Tags]    login    security    ui    regression    medium
    Given a user is trying to login
    When this user types the email    ${EMAIL}
    And this user types the password    😀unicode_ção<script>alert(1)</script>
    And clicks on Entrar
    Then the message "Email e/ou senha inválidos" must appear

User With Invalidated Session Should Be Redirected To The Login Page
    [Documentation]    A logged in user whose session token becomes invalid
    ...                and who then tries to reach the admin home page must
    ...                be redirected back to the login page.
    [Tags]    login    admin    ui    regression    high
    Given a logged in user is on the home page
    When the user session token is invalidated
    And the user navigates to the admin home page
    Then this user must be redirected to the login page

Session Should Persist After Page Reload
    [Documentation]    A logged in user who reloads the page (F5) must
    ...                remain authenticated and see the home page — the
    ...                session is not lost on reload.
    [Tags]    login    ui    regression    high
    Given a logged in user is on the home page
    When the user reloads the page
    Then this user must be redirected to the home page

Logout In One Tab Should End The Session In Other Tabs
    [Documentation]    A user logged in on the home page, who opens a second
    ...                browser tab (tabs in the same browser context share
    ...                the same session storage) and logs out there, must no
    ...                longer be authenticated on the first tab either, once
    ...                it is refreshed.
    [Tags]    login    ui    regression    high
    Given a logged in user is on the home page
    When the user logs out from a second tab
    And the user switches back to the original tab and reloads it
    Then this user must be redirected to the login page

User Can Logout And Be Redirected To The Login Page
    [Documentation]    A logged in user who clicks the logout button must be
    ...                signed out and redirected back to the login page.
    [Tags]    login    ui    regression    critical    compat
    Given a logged in user is on the home page
    When the user clicks on Logout
    Then this user must be redirected to the login page

After Logout Browser Back Should Not Restore The Session
    [Documentation]    A user who logs out and then navigates back using the
    ...                browser's back button must not have their session
    ...                restored — they must still see the login page, not
    ...                the home page.
    [Tags]    login    security    ui    regression    high
    Given a logged in user is on the home page
    When the user clicks on Logout
    And the user's browser navigates back
    Then this user must be redirected to the login page

After Logout Direct Navigation To Home Should Redirect To The Login Page
    [Documentation]    A user who logs out and then tries to reach the home
    ...                page directly by URL must be redirected back to the
    ...                login page instead of seeing the home page.
    [Tags]    login    security    ui    regression    high
    Given a logged in user is on the home page
    When the user clicks on Logout
    And this user navigates directly to the home page
    Then this user must be redirected to the login page

Regular User Should Not Be Able To Access The Admin Home Page
    [Documentation]    A logged in regular (non-admin) user who navigates
    ...                directly to the admin home URL must not see the admin
    ...                page and must be redirected to their own home page.
    ...                KNOWN ISSUE: the ServeRest front-end currently does
    ...                not enforce this restriction (see `Admin Page Should
    ...                Not Be Displayed`), so this test is expected to fail
    ...                until that authorization defect is fixed.
    [Tags]    login    admin    security    ui    regression    high    known-issue    skip
    Given a regular user is logged in
    When this user navigates directly to the admin home URL
    Then the admin page should not be displayed
    And this user must be redirected to the home page

*** Keywords ***
a user is trying to login
    No Operation

this user types the email
    [Arguments]    ${EMAIL}
    Input Email    ${EMAIL}

this user types the password
    [Arguments]    ${PASSWORD}
    Input Password    ${PASSWORD}

clicks on Entrar
    Click Entrar Button

this user must be redirected to the home page
    Home Page Should Be Displayed

the message "${MESSAGE}" must appear
    Login Error Message Should Be    ${MESSAGE}

this user must remain on the login page
    Login Page Should Be Displayed

the user reloads the page
    Reload

the user logs out from a second tab
    ${PAGE_IDS}=    Get Page Ids
    Set Test Variable    ${FIRST_TAB_ID}    ${PAGE_IDS}[0]
    New Page    ${BASE_URL}/home
    Home Page Should Be Displayed
    Click Logout Button

the user switches back to the original tab and reloads it
    Switch Page    ${FIRST_TAB_ID}
    Reload

the admin user wants to access the admin page
    Prepare Admin Login Test

this admin user types the email and password
    Input Email    ${EMAIL}
    Input Password    ${PASSWORD}
    Click Entrar Button

the admin page should be displayed
    Admin Page Should Be Displayed

a logged in user is on the home page
    Input Email    ${EMAIL}
    Input Password    ${PASSWORD}
    Click Entrar Button
    Home Page Should Be Displayed

the user session token is invalidated
    Invalidate User Session Token

the user navigates to the admin home page
    Navigate To Admin Home Page

this user must be redirected to the login page
    Login Page Should Be Displayed

a regular user is logged in
    a logged in user is on the home page

the user clicks on Logout
    Click Logout Button

the user's browser navigates back
    Go Back

this user navigates directly to the home page
    Navigate To Home Page

this user navigates directly to the admin home URL
    Navigate To Admin Home Page

the admin page should not be displayed
    Admin Page Should Not Be Displayed
