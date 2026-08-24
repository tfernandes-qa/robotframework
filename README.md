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
│   │   ├── products_api.resource
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
  - `Invalidate User Session Token` — clears the browser's local storage,
    simulating an expired or otherwise invalid session.
  - `Alert Message Should Be` — asserts the generic dismissible alert
    message shared by several forms across the app (login, new user, new
    product, ...).
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
  - `Click Editar Button For User` / `Click Excluir Button For User` — find
    the users table row matching a given email and click its "Editar" /
    "Excluir" button.
  - `User Row Should Not Be Displayed` — confirms no row in the users table
    matches a given email (e.g. after deleting that user).
  - `Some Editable Field Should Appear` — confirms at least one `<input>`
    element is present on the page, used to check whether clicking
    "Editar" produced any editable UI at all (shared by the user and
    product "Editar" known-issue tests).
  - `Click Editar Button For Product` / `Click Excluir Button For Product`
    — same idea as the user ones, but for a row in the products table.
  - `Product Row Should Not Be Displayed` — confirms no row in the
    products table matches a given product name.

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
  - `Create User Form Should Still Be Displayed` — confirms the form was
    not submitted (used when the browser's own field validation, e.g. an
    invalid email format, blocks submission).

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
  - `Create Product Form Should Still Be Displayed` — confirms the form
    was not submitted (used when the browser's own field validation, e.g.
    a decimal value in the whole-number quantity field, blocks
    submission).
  - `Type Non Numeric Text Into Price Field` / `Type Non Numeric Text Into
    Quantity Field` — simulate real keyboard typing of non-numeric text
    into the price/quantity fields (as opposed to setting the value
    directly), since both are `type="number"` inputs that silently ignore
    non-numeric keystrokes.
  - `Price Field Should Be Empty` / `Quantity Field Should Be Empty` —
    confirm a field's value is empty (used after attempting to type
    non-numeric text into it).

### `resources/pages/store_page.resource`

Page object for the store/home screen's shopping list feature. Contains:

- **Locators**: `${HOME_BUTTON}`, `${INCREASE_BUTTON}`, `${DECREASE_BUTTON}`,
  `${CLEAR_LIST_BUTTON}`, `${CART_LIST_EMPTY}`.
- **Keywords**:
  - `Back To Home` — clicks the "Página Inicial" button to return to the
    home page.
  - `Clear List` — clicks the button to clear the shopping list.
  - `Add Item To List` — finds a product card by its name (built as a
    dynamic XPath, no fixed locator) and clicks the button to add it to
    the shopping list.
  - `Item Should Be In List` — verifies that the given product is visible
    in the shopping cart list.
  - `Increase Quantity of Item in List` / `Decrease Quantity of Item in
    List` — click the buttons to increase/decrease the quantity of an item
    already in the shopping list.
  - `Item Should Be Increased` / `Item Should Be Decreased` — verify that
    the quantity of the given product went up/down accordingly in the
    shopping list.
  - `List Should Be Empty` — verifies that the shopping list is empty.
  - `Decrease Button Should Be Disabled` — confirms the decrease button is
    disabled once the item's quantity is already at the minimum (1).
  - `Product Card Should Not Be In Catalog` — confirms no catalog card
    matches a given product name (e.g. after it was added to the list).
  - `Double Click Increase Quantity Button` — double-clicks the increase
    button, to check for race conditions (skipped/duplicated clicks).
  - `Item Quantity Should Be` — verifies a product's quantity in the list
    matches an exact expected value.

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
- `Get Users By Email Via Api` — queries all users registered with a given
  email, returning how many were found and the matching records.
- `Delete All Users With Email Via Api` — deletes every user registered
  with a given email. Used to clean up after tests that intentionally
  create duplicated users (e.g. the double-click and duplicated-email
  tests), where the id isn't known upfront.

### `resources/api/products_api.resource`

Support keywords that call the ServeRest REST API to prepare and clean up
test data (products) used by the UI tests. Unlike the user routes, the
product routes require an admin authorization token:

- `Get Admin Auth Token` — logs in with the given admin credentials and
  returns the authorization token required by the product creation/deletion
  routes.
- `Create Product Via Api` — creates a product with the given fields, using
  the given admin token, and returns the id of the created product.
- `Delete Product Via Api` — deletes the product (by id) created for the
  test, using the given admin token.
- `Get Products By Name Via Api` — queries all products registered with a
  given name, returning how many were found and the matching records.
- `Delete All Products With Name Via Api` — deletes every product
  registered with a given name, using the given admin token. Used to clean
  up after tests that intentionally create duplicated products.
- `Cleanup Product By Name Via Api` — obtains a fresh admin token with the
  given credentials and removes every product registered with a given
  name. Used to clean up after tests that create a product through the UI,
  where no product id is known.

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
- Leading/trailing whitespace around an otherwise valid email/password is
  not trimmed by the app, so it is treated as invalid credentials.
- An uppercased version of an otherwise valid email fails to log in — the
  app treats the email comparison as case-sensitive.
- An excessively long email/password (500+ characters, no front-end
  maxlength on either field) is rejected by the app's own email format
  validation.
- Special characters in the email field (e.g. an XSS payload) never reach
  the app: the browser's native email input validation blocks the form
  from submitting, so the user stays on the login page.
- An XSS/emoji/unicode payload in the password field (with an otherwise
  valid email) reaches the app and is safely rejected as invalid
  credentials, with no script execution or console errors.
- A logged in user's session survives a page reload (F5) — the app persists
  the session (e.g. in local storage), so the user stays on the home page.
- Logging out in one browser tab ends the session in another tab sharing
  the same browser context, once that other tab is refreshed.
- A logged in user clicking logout is redirected back to the login page.
- After logout, navigating back with the browser's back button does not
  restore the session (login page is shown, not home).
- After logout, navigating directly to the home page URL redirects back to
  the login page.

The `*** Keywords ***` section of this file defines the Given/When/Then style
keywords used by the test cases (e.g. `this user types the email`,
`clicks on Entrar`, `the message "..." must appear`), which simply delegate
to the page object keywords described above.

### `tests/store/store.robot`

Test suite covering the shopping list on the ServeRest store/home page. It
reuses `Prepare Login Test` (via `Open Browser To Home Page`) to log in as a
fresh API-created shopper user before each test, then drives the store page
object to run scenarios such as:

- Adding two items to the shopping list.
- Clearing the shopping list.
- Increasing/decreasing the quantity of an item already in the list.
- **Known issue**: the "decrease quantity" button never gets a `disabled`
  state, even once an item's quantity is already at the minimum (1) — it
  stays clickable with no visual feedback that the action has no effect.
  The underlying logic is correct (quantity never drops to 0 or below, and
  the item is never removed), only the missing disabled state is the
  defect. `Decrease Button Should Be Disabled When Quantity Is At The
  Minimum` documents the expected, correct behavior and is tagged
  `known-issue`/`skip`.
- Adding a product to the list removes its card from the catalog grid —
  the app's way of preventing the same item from being added twice; there
  is no way to duplicate a line through the UI.
- Adding a product registered with zero stock (quantity) to the list
  works with no restriction — the app does not enforce a stock check when
  adding items.
- Double-clicking the "increase quantity" button registers as two
  separate clicks (quantity goes from 1 to 3), with no race condition
  that skips or duplicates a click.
- Clearing the list removes every item, not just the first one added — a
  more thorough check of the "Limpar Lista" button than the single-item
  clear test.

Each `Given` step creates its own product(s) via the API (`Create Admin
User Via Api` + `Get Admin Auth Token` + `Create Product Via Api`, with a
Faker word name suffixed with a random string for uniqueness) instead of
relying on fixed catalog items, since the ServeRest catalog is a public,
shared demo environment where fixed product names can collide with
clutter created by other students/QA courses (this was observed in
practice: a duplicated "Logitech MX Vertical" card broke a locator in
strict mode). Because the store/home page has already loaded before the
`Given` step runs, it calls Browser library's `Reload` afterwards so the
newly created product's card appears before the `When` steps interact
with it.

Each test case defines its own `[Teardown]`, chained with `AND` onto
`Cleanup Login Test`, to delete the product(s) and the temporary admin
user created for setup — a local `[Teardown]` replaces the suite's `Test
Teardown` rather than running in addition to it, so `Cleanup Login Test`
must be included explicitly in every custom teardown, or the browser
never closes and the shopper user is never deleted.

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
- An admin user being able to access the regular user's home page (store)
  directly, without being blocked.
- The admin not being able to create a user or a product with a name/email
  that already exists (negative cases), asserting the corresponding error
  message.
- The admin not being able to create a user with a blank name, a blank
  password, or an invalid email format (negative/validation cases).
- Double-clicking the submit button on the new user form not creating two
  duplicated users.
- An admin deleting an existing user from the users list via the
  "Excluir" button, confirming the user is removed both from the table and
  from the backend.
- **Known issue**: the "Editar" button on the users list has no wired
  behavior (clicking it produces no visible change on the page — no input
  field, no navigation, no modal), so there is currently no way to edit an
  existing user through the UI. `Admin Should Be Able To Edit An Existing
  User` documents the expected, correct behavior and is tagged
  `known-issue`/`skip`, so it is expected to fail until that defect is
  fixed — the same pattern used for the RBAC known issue in
  `tests/login/login.robot`.
- An admin deleting an existing product from the products list via the
  "Excluir" button, confirming the product is removed both from the table
  and from the backend. **Known issue**: same as users, the products
  list's "Editar" button also has no wired behavior —
  `Admin Should Be Able To Edit An Existing Product` documents this and is
  tagged `known-issue`/`skip`.
- The admin not being able to create a product with a negative or zero
  price (`Preco deve ser um número positivo`) or a negative quantity
  (`Quantidade deve ser maior ou igual a 0`), or with a blank name
  (`Nome é obrigatório`) or blank description (`Descricao é
  obrigatório`).
- The price and quantity fields are HTML `type="number"` inputs with no
  explicit `step`, so the browser itself — not the app — rejects any
  non-numeric keystroke (the field stays empty) and blocks submission of
  any decimal value (e.g. `10.12` or `2.5`) via native validation.
- The price field accepts scientific notation (e.g. `1e3`), which the app
  treats as a valid positive number and creates the product with — and a
  quantity of zero is accepted (an out-of-stock product), consistent with
  the negative-quantity message wording ("maior ou igual a 0"). Both are
  captured as boundary-case regression tests.

The eleven tests above that create extra data (new user, new product, the
two "cannot create duplicated ..." cases, the double-click case, the
delete/edit-user and delete/edit-product cases, and the two accepted
boundary-price/quantity cases) each define their own `[Teardown]`, chained
with `AND` onto `Cleanup Login Test`, to delete that data via the API
(e.g. `Delete User Via Api`, `Delete All Users With Email Via Api`,
`Cleanup Product By Name Via Api`). A local `[Teardown]` replaces the
suite's `Test Teardown`
instead of running in addition to it, so `Cleanup Login Test` has to be
included explicitly every time — and because `Run Keywords` only chains
multiple keywords when they're separated with `AND` (a single keyword
passed to it gets its arguments misread as more keyword names to run), a
teardown that runs just one cleanup keyword must call it directly instead
of wrapping it in `Run Keywords`.

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
| **Execution set**  | `smoke`, `regression`             | `regression` is on every test (the full suite). `smoke` marks the small, fast subset of critical happy paths — currently 5 of the 53 tests — meant to run on every PR for quick feedback. |
| **Criticality**    | `critical`, `high`, `medium`      | `critical` = core journeys the app is unusable without (login, admin create user/product, add to cart). `high` = important supporting flows (listing, quantity, clearing). `medium` = negative/validation edge cases. |
| **Layer**          | `ui`                               | All current tests drive the browser end-to-end (API is only used for setup/teardown). Kept as an explicit tag so future API-only suites can be filtered out (`--exclude ui`) or in (`--include ui`) separately. |
| **Compatibility**  | `compat`                          | A small, deliberately curated cross-browser subset (currently 12 of the 53 tests) run against Chromium, Firefox, and WebKit — see [Cross-Browser Compatibility](#cross-browser-compatibility) below. Not run on every PR (only Chromium is); this tag drives a separate, less frequent job. |

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

## Cross-Browser Compatibility

The suite runs on Chromium by default (`${BROWSER}` in
`resources/variables/global.resource`), driven by the Browser library
(Playwright), which also supports Firefox and WebKit out of the box —
`rfbrowser init` downloads all three engines already, even though only
Chromium was actually being exercised until this was added.

### Why not just run every test on all three browsers

Running all 53 tests × 3 engines on every PR would triple CI time and load
on the shared public ServeRest demo backend (which already shows occasional
flakiness under normal single-browser load). Instead, a small, deliberately
curated subset is tagged `compat` (12 of the 53 tests) — the `critical`
happy paths plus every test whose outcome depends on browser-native
behavior (HTML5 constraint validation on `type="email"`/`type="number"`
inputs, whitespace handling), which is exactly the kind of test most
likely to diverge between engines. Everything else keeps running on
Chromium only, since it doesn't depend on engine-specific behavior.

### Spike results (2026-08-24)

Before adopting this, the full suite was run once against Firefox and once
against WebKit (`--variable BROWSER:firefox` / `webkit`) to validate the
approach with real data instead of assumptions:

| Engine | Result | Known-issues (expected failures) | Genuine compatibility findings |
|---|---|---|---|
| Chromium (baseline) | 53/53 (excl. known-issues) | 4/4 | — |
| Firefox | 47/53 | 4/4 reproduced identically | **1** (see below) |
| WebKit | 48/53 | 4/4 reproduced identically | 0 (1 failure was transient flakiness, confirmed by re-running in isolation) |

The 4 known-issue tests (`Admin Should Be Able To Edit An Existing User`,
`Admin Should Be Able To Edit An Existing Product`, `Regular User Should
Not Be Able To Access The Admin Home Page`, `Decrease Button Should Be
Disabled When Quantity Is At The Minimum`) failed identically on all three
engines — good evidence they're genuine app defects, not test artifacts.

None of the tests that rely on browser-native `type="email"`/`type="number"`
validation (XSS payload in email, decimal price/quantity, non-numeric
keystrokes) diverged on any engine — asserting on *outcome* (page stayed
put, field stayed empty) rather than the browser's own (localized,
engine-specific) validation message text turned out to matter here.

**One genuine finding**: `Login With Padded Email And Password Should
Fail` fails consistently on Firefox only. Root cause, confirmed with
`Get Property`/`Wait For Response` diagnostics: Firefox silently trims
leading/trailing whitespace from `type="email"` inputs (Chromium and
WebKit don't), so the email arrives clean while the password stays
padded — and that specific combination never even fires the login network
request on Firefox (no console error either). This is tracked as a known
limitation in the test's own `[Documentation]` rather than fixed yet; a
straightforward fix would be padding only the password field, since no
engine sanitizes `type="password"` inputs.

### Running compat tests locally

```bash
robot --include compat --variable BROWSER:firefox tests/
robot --include compat --variable BROWSER:webkit tests/
```

## Setup

```bash
pip install -r requirements.txt
rfbrowser init
```

## Running the tests

```bash
robot -d results tests
```

## Running the tests in parallel (Pabot)

[`pabot`](https://pabot.org) (`robotframework-pabot`, included in
`requirements.txt`) runs each **suite** in its own process. In this project a
"suite" is one directory under `tests/` — `tests/admin`, `tests/login`,
`tests/store` — each holding a single `.robot` file, so by default pabot
parallelizes exactly at that granularity:

- `admin.robot`, `login.robot`, and `store.robot` run **concurrently**, in
  separate processes — they don't share state (each test creates and tears
  down its own user/product via the API), so running them side by side is
  safe.
- The test cases **inside** each `.robot` file keep running **sequentially**,
  one after another in that suite's single process.

```bash
pabot --processes 3 --outputdir results tests
```

`--processes 3` matches the current number of suites (one process per
suite is enough since pabot doesn't split further); raising it doesn't buy
more parallelism today but won't break anything either — it just leaves the
extra processes idle. Any other `robot` flag (`--include smoke`,
`--variable HEADLESS:True`, `--listener allure_robotframework:allure-results`,
...) works the same way with `pabot`.

### Test-level splitting (`--testlevelsplit`)

`--testlevelsplit` makes pabot split *inside* each suite too, so individual
test cases (not just whole suites) get scheduled onto the process pool. Each
split test still runs in its own pabot subprocess — its own Python
interpreter and its own Browser/Playwright driver — so it's just as isolated
from its sibling tests as suites already are from each other: nothing about
this project's tests (each of which creates and tears down its own
user/product via the API) makes them unsafe to run concurrently.

That was verified empirically, not just assumed: across 13 separate
`--testlevelsplit` runs (all 21 tests split, mixed freely across `admin`,
`login`, and `store`, at process counts from 3 to 8, several repeated to
check for flakiness) the only failure that ever showed up was `Regular User
Should Not Be Able To Access The Admin Home Page`, the pre-existing
`known-issue` test — the exact same, single failure `--processes 3` alone
also produces. No data race, no session bleed, no flaky failure caused by
concurrency ever appeared.

**But it isn't a reliable speed win today, so it isn't the default.** With
only 3 suites and 4-9 tests each, `--processes 3` already parallelizes as
much as matters, and splitting further mostly adds per-test process
start-up overhead (a fresh interpreter + Browser driver per test instead of
per suite) plus contention between more concurrent Chromium instances than
the machine has cores for. Measured on an 8-core machine, running the full
`tests/` tree:

| Command | Runs | Elapsed time (avg) | Spread |
| --- | --- | --- | --- |
| `pabot --processes 3 tests` (default, no split) | 4 | **54.1s** | 52.4s – 55.4s (±1.1s) |
| `pabot --testlevelsplit --processes 3 tests` | 1 | 70.0s | — |
| `pabot --testlevelsplit --processes 5 tests` | 2 | 64.8s | 56.7s – 72.9s |
| `pabot --testlevelsplit --processes 6 tests` | 2 | 52.6s | 52.3s – 52.9s |
| `pabot --testlevelsplit --processes 8 tests` | 4 | 50.8s | 44.9s – 60.9s (±6.4s) |

No process count tested consistently beat the plain `--processes 3` default
by a reliable margin — the best individual runs did (as fast as 44.9s at
`--processes 8`), but so did the worst (60.9s, also at `--processes 8`), and
the average across every split variant (56.5s) actually landed slightly
*behind* the default's 54.1s. The variance looks driven by the shared,
third-party ServeRest demo backend's response times more than by local CPU
contention, which local process-count tuning can't fix. The default's tight
±1.1s spread makes it the more predictable choice for CI, where a
consistent run time matters as much as the average.

**When `--testlevelsplit` would earn its keep:** if a single suite grows
large enough that it — not the number of suites — becomes the bottleneck
(e.g. `admin.robot` growing from today's 8 tests to 25+), suite-level
parallelism stays capped at 3 processes no matter how many cores are
available, while test-level splitting can spread that one suite's tests
across every core. At that point, split *only* the oversized suite instead
of the whole `tests/` tree, so the other suites keep running in their own
dedicated process and you don't reintroduce the run-to-run variance seen
above:

```bash
pabot --testlevelsplit --processes 4 --outputdir results tests/admin
```

For finer control — e.g. splitting just the large suite while still running
the other suites in the same pabot invocation — pabot supports an
`--ordering` file that mixes `--suite` lines (suite stays whole) with
`--test` lines (that suite's tests get split individually), see the
[pabot docs](https://pabot.org) for the exact syntax.

## Viewing results with Allure

CI already publishes an [Allure](https://allurereport.org/) report for every
run (see [Continuous Integration](#continuous-integration)); the same report
can be generated locally.

`allure-robotframework` (already in `requirements.txt`) provides the
`allure_robotframework` **listener**, which writes Allure's raw result files
as the suite runs. Turning it on just means adding `--listener` to the
`robot`/`pabot` command already in use:

```bash
robot --listener allure_robotframework:allure-results -d results tests
```

Rendering those raw results into an HTML report additionally requires the
Allure **command-line tool**, a separate Java-based install (not a Python
package, so it's not in `requirements.txt`):

```bash
npm install -g allure-commandline
```

Then, to build and open the report:

```bash
# generates the report into allure-report/ and opens it in the browser
allure serve allure-results
```

`allure serve` is the quickest option for a one-off local look (it uses a
temp folder under the hood). To keep the generated report as a file instead
— e.g. to share it — generate and open it explicitly:

```bash
allure generate allure-results --clean -o allure-report
allure open allure-report
```

Every `robot`/`pabot` run appends new results into `allure-results/` rather
than replacing it, so a report generated without `--clean` shows the
accumulated history of every local run, not just the latest one; delete
`allure-results/` first (or keep using `--clean` when generating) for a
report scoped to a single run.

The listener works the same way together with `pabot` — each subprocess
writes its own result files into the same `allure-results/` folder (Allure
uses one file per test, so parallel writers don't conflict):

```bash
pabot --processes 3 --listener allure_robotframework:allure-results --outputdir results tests
allure serve allure-results
```
