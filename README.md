# Automated Tests - ServeRest Front

Robot Framework tests (Page Object Model pattern) for <https://front.serverest.dev/>.

## Page Object Model (POM)

This project follows the **Page Object Model** design pattern. The idea is to
separate *what a test does* from *how the UI is automated*:

- **Tests** (`tests/`) describe business scenarios in plain, readable steps
  (Given/When/Then style keywords), with no locators or low-level browser
  calls in them.
- **Page objects** (`resources/pages/`) encapsulate the locators and the
  low-level interactions for a single screen (filling fields, clicking
  buttons, reading messages, asserting the screen that is displayed).
- **API resources** (`resources/api/`) encapsulate calls to the ServeRest
  REST API, used to set up and tear down test data instead of doing it
  through the UI (faster and more reliable).
- **Variables** (`resources/variables/`) centralize environment configuration
  (URLs, browser, headless mode) shared by every resource and test.

This separation means that if a locator or a screen interaction changes, only
the corresponding page object needs to be updated — the test cases themselves
stay untouched. It also keeps test cases focused on behavior, which makes
them easier to read and maintain.

## Structure

```text
robotframework/
├── requirements.txt
├── resources/
│   ├── api/
│   │   └── users_api.resource
│   ├── pages/
│   │   ├── home_page.resource
│   │   └── login_page.resource
│   └── variables/
│       └── global.resource
└── tests/
    └── login/
        └── login.robot
```

### `requirements.txt`

Python dependencies required to run the suite:

- `robotframework` — the test automation framework itself.
- `robotframework-browser` — Browser library (Playwright-based) used to
  drive the web UI.
- `robotframework-requests` — RequestsLibrary, used by the API resources to
  call the ServeRest REST API.

### `resources/variables/global.resource`

Global variables shared across the whole project:

- `${BASE_URL}` — base URL of the ServeRest front-end (`https://front.serverest.dev`).
- `${API_BASE_URL}` — base URL of the ServeRest REST API (`https://serverest.dev`).
- `${BROWSER}` — browser engine used by the Browser library (`chromium`).
- `${HEADLESS}` — whether the browser runs headless (`False` by default, so
  it opens visibly).

Also loads the `Browser` and `DebugLibrary` libraries, so any resource that
imports this file has access to them.

### `resources/pages/login_page.resource`

Page object for the login screen (`${BASE_URL}/login`). Contains:

- **Locators**: `${EMAIL_INPUT}`, `${PASSWORD_INPUT}`, `${LOGIN_BUTTON}`,
  `${LOGIN_ERROR_MESSAGE}`.
- **Keywords**:
  - `Open Login Page` — opens a new browser/context/page already on the
    login screen.
  - `Input Email` / `Input Password` — fill in the email/password fields.
  - `Click Entrar Button` — submits the login form.
  - `Login Error Message Should Be` — waits for and asserts the error
    message shown on the login screen.

### `resources/pages/home_page.resource`

Page object for the customer home page (`${BASE_URL}/home`), shown after a
successful login. Contains:

- **Locator**: `${LOGOUT_BUTTON}`.
- **Keyword**:
  - `Home Page Should Be Displayed` — confirms the user was redirected to
    the home page, by waiting for the logout button (visible only on this
    page) and checking the current URL. The wait is needed because the
    redirect happens client-side (SPA), asynchronously after clicking
    "Entrar".

### `resources/api/users_api.resource`

Support keywords that call the ServeRest REST API to prepare and clean up
test data used by the UI tests, avoiding the need to create/delete users
through the UI:

- `Create Standard User Via Api` — creates a standard (non-admin) user with
  a unique, randomly generated email, and returns the email, password, and
  id of the created user.
- `Delete User Via Api` — deletes the user (by id) created for the test,
  keeping the test environment clean.

### `tests/login/login.robot`

Test suite covering the login flow of the ServeRest front-end. It uses
`Test Setup`/`Test Teardown` to create a fresh user via the API before each
test and delete it afterwards, then drives the login page object to run
scenarios such as:

- Valid credentials redirect the user to the home page.
- Invalid email and/or password show an "invalid credentials" message.
- Blank email or blank password show the corresponding required-field
  message.
- Invalid email format shows a validation message.

The `*** Keywords ***` section of this file defines the Given/When/Then style
keywords used by the test cases (e.g. `this user types the email`,
`clicks on Entrar`, `the message "..." must appear`), which simply delegate
to the page object keywords described above.

## Setup

```bash
pip install -r requirements.txt
rfbrowser init
```

## Running the tests

```bash
robot -d results tests
```
