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
├── .github/
│   └── workflows/
│       └── robot-tests.yml
├── requirements.txt
├── resources/
│   ├── api/
│   │   └── users_api.resource
│   ├── pages/
│   │   ├── global_page.resource
│   │   ├── home_page.resource
│   │   ├── login_page.resource
│   │   ├── newProduct_page.resource
│   │   ├── newUser_page.resource
│   │   └── store_page.resource
│   └── variables/
│       └── global.resource
└── tests/
    ├── admin/
    │   └── admin.robot
    ├── login/
    │   └── login.robot
    └── store/
        └── store.robot
```

### `requirements.txt`

Python dependencies required to run the suite:

- `robotframework` — the test automation framework itself.
- `robotframework-browser` — Browser library (Playwright-based) used to
  drive the web UI.
- `robotframework-requests` — RequestsLibrary, used by the API resources to
  call the ServeRest REST API.
- `Faker` — generates random user and product data (names, emails,
  passwords, prices, descriptions) used by the tests, via `Evaluate`
  calls in `global_page.resource`.

### `resources/variables/global.resource`

Global variables shared across the whole project:

- `${BASE_URL}` — base URL of the ServeRest front-end (`https://front.serverest.dev`).
- `${API_BASE_URL}` — base URL of the ServeRest REST API (`https://serverest.dev`).
- `${BROWSER}` — browser engine used by the Browser library (`chromium`).
- `${HEADLESS}` — whether the browser runs headless (`False` by default, so
  it opens visibly).

Also loads the `Browser` library, so any resource that imports this file has
access to it.

### `resources/pages/global_page.resource`

Shared setup/teardown keywords used by more than one test suite (login,
store, and admin), gluing together the API resource and the page objects to
open the browser and prepare/clean up test data, plus helpers to generate
random test data via Faker (`pt_BR` locale):

- **Keywords**:
  - `Open Login Page` — opens a new browser/context/page already on the
    login screen.
  - `Prepare Login Test` — creates a valid (non-admin) user via the API and
    opens the login page, leaving `${EMAIL}`, `${PASSWORD}`, and `${USER_ID}`
    available as test variables for the test and its teardown.
  - `Prepare Admin Login Test` — same as above, but creates an admin user via
    the API, for tests that need to reach the admin area.
  - `Cleanup Login Test` — closes the browser and removes, via the API, the
    user created in the setup.
  - `Generate Random User` — returns a random name, email, and password
    (via `Generate Random Password`), using Faker.
  - `Generate Random Password` — generates a random alphanumeric password
    (default length 10).
  - `Generate Random Product` — returns a random product name, price,
    description, and quantity, using Faker.

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

Page object for the customer home page (`${BASE_URL}/home`) and the admin
home page (`${BASE_URL}/admin/home`), shown after a successful login.
Contains:

- **Locators**: `${LOGOUT_BUTTON}`, `${CREATE_USER_BUTTON}`,
  `${LIST_USERS_BUTTON}`, `${USERS_TABLE}`, `${CREATE_PRODUCT_BUTTON}`,
  `${LIST_PRODUCTS_BUTTON}`, `${PRODUCTS_TABLE}`.
- **Keywords**:
  - `Home Page Should Be Displayed` — confirms the user was redirected to
    the home page, by waiting for the logout button (visible only on this
    page) and checking the current URL. The wait is needed because the
    redirect happens client-side (SPA), asynchronously after clicking
    "Entrar".
  - `Admin Page Should Be Displayed` — same idea, but asserts the URL is
    `${BASE_URL}/admin/home`.
  - `Click Cadastrar Button On Cadastro De Usuario Card` / `Click Listar
    Button On Listar Usuarios Card` — open the "create user" / "list users"
    admin cards.
  - `Users Table Should Be Displayed` — confirms the users table is visible.
  - `Click Cadastrar Button On Cadastrar Produtos Card` / `Click Listar
    Button On Listar Produtos Card` — open the "create product" / "list
    products" admin cards.
  - `Products Table Should Be Displayed` — confirms the products table is
    visible.

### `resources/pages/newUser_page.resource`

Page object for the admin's "create user" screen. Contains:

- **Locators**: `${NEW_USER_NAME}`, `${NEW_USER_EMAIL}`,
  `${NEW_USER_PASSWORD}`, `${NEW_USER_CADASTRAR_BUTTON}`.
- **Keywords**:
  - `Input New Name` / `Input New Email` / `Input New Password` — fill in
    the corresponding fields on the new user form.
  - `Click Cadastrar Button` — submits the new user form.
  - `User Should Be Created` — asserts the created user's email is visible
    in the users table.

### `resources/pages/newProduct_page.resource`

Page object for the admin's "create product" screen. Contains:

- **Locators**: `${NEW_PRODUCT_NAME}`, `${NEW_PRODUCT_PRICE}`,
  `${NEW_PRODUCT_DESCRIPTION}`, `${NEW_PRODUCT_QUANTITY}`,
  `${NEW_PRODUCT_CADASTRAR_BUTTON}`.
- **Keywords**:
  - `Input New Product Name` / `Input New Product Price` / `Input New
    Product Description` / `Input New Product Quantity` — fill in the
    corresponding fields on the new product form.
  - `Click Cadastrar Button on New Product Form` — submits the new product
    form.
  - `Product Should Be Created` — asserts the created product's name is
    visible in the products table.

### `resources/pages/store_page.resource`

Page object for the store/home screen's shopping list feature. Contains:

- **Locators**: `${HOME_BUTTON}`, `${ADD_TO_LIST_BUTTON}`,
  `${CLEAR_LIST_BUTTON}`, `${CART_LIST_EMPTY}`.
- **Keywords**:
  - `Back To Home` — clicks the "Página Inicial" button to return to the
    home page.
  - `Clear List` — clicks the button to clear the shopping list.
  - `Add Item To List` — finds a product card by its name and clicks the
    button to add it to the shopping list.
  - `Item Should Be In List` — verifies that the given product is visible
    in the shopping cart list.
  - `Increase Quantity of Item in List` — clicks the button to increase the
    quantity of an item already in the shopping list.
  - `Item Should Be Increased` — verifies that the quantity of the given
    product has been increased in the shopping list.
  - `List Should Be Empty` — verifies that the shopping list is empty.

### `resources/api/users_api.resource`

Support keywords that call the ServeRest REST API to prepare and clean up
test data used by the UI tests, avoiding the need to create/delete users
through the UI:

- `Create Standard User Via Api` — creates a standard (non-admin) user with
  a unique, randomly generated email, and returns the email, password, and
  id of the created user.
- `Create Admin User Via Api` — same as above, but creates the user with
  `administrador=true`, so it can log in and reach the admin area.
- `Delete User Via Api` — deletes the user (by id) created for the test,
  keeping the test environment clean.

### `tests/login/login.robot`

Test suite covering the login flow of the ServeRest front-end. It uses
`Test Setup`/`Test Teardown` to create a fresh user via the API before each
test and delete it afterwards, then drives the login page object to run
scenarios such as:

- Valid credentials redirect the user to the home page.
- An admin user's valid credentials redirect them to the admin page.
- Invalid email and/or password show an "invalid credentials" message.
- Blank email or blank password show the corresponding required-field
  message.
- Invalid email format shows a validation message.

The `*** Keywords ***` section of this file defines the Given/When/Then style
keywords used by the test cases (e.g. `this user types the email`,
`clicks on Entrar`, `the message "..." must appear`), which simply delegate
to the page object keywords described above.

### `tests/store/store.robot`

Test suite covering the shopping list on the ServeRest store/home page. It
reuses `Prepare Login Test`/`Cleanup Login Test` (via `Open Browser To Home
Page`) to log in as a fresh API-created user before each test, then drives
the store page object to run scenarios such as:

- Adding two items to the shopping list.
- Increasing the quantity of an item already in the list.
- Clearing the shopping list.

The `*** Keywords ***` section of this file defines the Given/When/Then
style keywords used by the test cases (e.g. `the user adds the first item to
the list`, `the user clears the list`), which simply delegate to the store
page object keywords described above.

### `tests/admin/admin.robot`

Test suite covering the admin area of the ServeRest front-end. It uses
`Test Setup`/`Test Teardown` to create a fresh admin user via the API,
log in, and land on the admin page before each test (delegating to
`Prepare Admin Login Test`), then drives the admin page objects to run
scenarios such as:

- Creating a new user with randomly generated data (via `Generate Random
  User`) and confirming it appears in the users table.
- Listing all users and confirming the users table is displayed.
- Creating a new product with randomly generated data (via `Generate
  Random Product`) and confirming it appears in the products table.
- Listing all products and confirming the products table is displayed.

The `*** Keywords ***` section of this file defines the Given/When/Then
style keywords used by the test cases (e.g. `the admin fills in the user
details with valid information`, `the admin clicks on the "Cadastrar"
button on the Cadastro de Usuário card`), which simply delegate to the
`newUser_page.resource` / `newProduct_page.resource` / `home_page.resource`
keywords described above.

## Tags

Every test case carries three kinds of `[Tags]`, so the suite can be sliced
without touching test code:

| Dimension        | Tags                              | Meaning |
|-------------------|------------------------------------|---------|
| **Execution set**  | `smoke`, `regression`             | `regression` is on every test (the full suite). `smoke` marks the small, fast subset of critical happy paths — currently 5 of the 14 tests — meant to run on every PR for quick feedback. |
| **Criticality**    | `critical`, `high`, `medium`      | `critical` = core journeys the app is unusable without (login, admin create user/product, add to cart). `high` = important supporting flows (listing, quantity, clearing). `medium` = negative/validation edge cases. |
| **Layer**          | `ui`                               | All current tests drive the browser end-to-end (API is only used for setup/teardown). Kept as an explicit tag so future API-only suites can be filtered out (`--exclude ui`) or in (`--include ui`) separately. |

Module tags (`login`, `admin`, `store`/`list`) are also kept so a single
feature area can be run in isolation, e.g. `robot --include admin tests/`.

Tags are combinable, e.g. run every critical test regardless of area:

```bash
robot --include critical tests/
```

Robot Framework's `report.html` automatically breaks down pass/fail stats
per tag ("Statistics by Tag") with no extra flags required — once the tags
above are applied, that view already gives a success rate by criticality
(`critical`/`high`/`medium`) for free, which is what gets reported to
stakeholders.

## Continuous Integration

`.github/workflows/robot-tests.yml` runs the suite on GitHub Actions, using
tags to control how much of it runs per trigger:

- **Triggers**:
  - `pull_request` to `main` → runs `--include smoke` only, for fast PR
    feedback.
  - `push` to `main` and a nightly `schedule` (03:00 UTC) → run
    `--include regression`, the full suite.
  - `workflow_dispatch` → manual run with a `tag` input (`smoke` or
    `regression`, defaults to `regression`).
  - Runs are cancelled/deduped per branch (`concurrency`).
- Sets up Python and Node.js (the Browser library driver needs Node),
  installs `requirements.txt`, and runs `rfbrowser init` (with the
  downloaded Playwright browsers cached across runs).
- Executes `robot --include <tag> --outputdir results --xunit xunit.xml
  tests/`; the job fails if any test fails.
- Uploads `log.html`, `report.html`, and `output.xml` as the
  `robot-framework-results` artifact, and `xunit.xml` as the
  `robot-junit-report` artifact (both kept for 15 days), and writes a short
  summary to the GitHub Actions run.

## Setup

```bash
pip install -r requirements.txt
rfbrowser init
```

## Running the tests

```bash
robot -d results tests
```
