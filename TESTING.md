# QuickBite – Test Plan & Manual Test Execution Log

This document records the comprehensive manual and automated test execution results for the **QuickBite Campus Food Ordering App** developed using Flutter and Dart.

---

## Summary of Test Results

| Total Test Cases | Passed | Failed | Blocked | Execution Status |
| :--- | :---: | :---: | :---: | :---: |
| **8 Cases (Manual) + 9 Automated Specs** | **8 / 8** | **0** | **0** | **100% PASS** |

---

## Detailed Test Cases

### TC01 - Splash to Login Navigation
* **Test Description:** Verify that the QuickBite splash screen initializes, displays branding elements, and automatically transitions to the Login/Guest screen after a short delay.
* **Pre-conditions:** App is launched from cold start.
* **Steps:**
  1. Launch the `QuickBite` application.
  2. Observe the splash screen branding ("QuickBite", logo animation, and tagline).
  3. Wait 2.4 seconds or tap "Get Started".
* **Expected Result:** App smoothly navigates to the Login screen without visual glitches or RenderFlex overflows.
* **Actual Result:** Splash animation played smoothly and automatically navigated to `/login`.
* **Status:** `PASS`

---

### TC02 - Guest Access & Login Form Validation
* **Test Description:** Verify form validation for empty/invalid fields and verify one-tap guest login functionality.
* **Pre-conditions:** User is on the Login Screen (`/login`).
* **Steps:**
  1. Clear all input fields and tap "SIGN IN TO ORDER". Verify error messages appear for Full Name and Student Email.
  2. Enter invalid email (e.g., `notanemail`) and verify email format validation.
  3. Enter valid details ("Kasun Bandara", "kasun.b@campus.ac.lk", "STU-2026-4412") and click "SIGN IN TO ORDER".
  4. Alternatively, tap "Continue as Guest".
* **Expected Result:** Validation errors display when inputs are invalid. Tapping "Continue as Guest" initializes a guest profile ("Guest Student") and navigates to `/home`.
* **Actual Result:** Form validation correctly caught empty and invalid fields. Guest login immediately created a guest session and opened Home.
* **Status:** `PASS`

---

### TC03 - Home Screen Search and Category Filtering
* **Test Description:** Verify real-time search functionality and category filter pills (All, Meals, Beverages, Snacks).
* **Pre-conditions:** User is on Home Screen (`/home`).
* **Steps:**
  1. Tap on the "Meals" category chip.
  2. Observe that only Meal items (Rice & Curry, Fried Rice, Kottu, Noodles) are shown with accurate counts.
  3. Tap on "Beverages" and "Snacks".
  4. Type "Fried Rice" into the search bar.
  5. Clear search query using the "X" button.
* **Expected Result:** Item list updates dynamically without lag. Selecting categories and typing search queries filters the menu items in real-time.
* **Actual Result:** Category filtering and search query matching functioned instantly and accurately.
* **Status:** `PASS`

---

### TC04 - Add Item to Cart & Quantity Update
* **Test Description:** Verify adding items from Home/Detail screens, adjusting quantities, and state persistence.
* **Pre-conditions:** User selects an item (e.g., "Chicken Fried Rice").
* **Steps:**
  1. Tap on "Chicken Fried Rice" card to open Item Detail screen.
  2. Adjust quantity using `[+]` button to 2.
  3. Enter optional note: "Extra chili paste".
  4. Tap "ADD TO CART".
  5. Verify SnackBar confirmation and cart badge count on the top AppBar.
  6. Navigate to Cart screen (`/cart`).
  7. Increment and decrement item quantities.
* **Expected Result:** Quantity updates smoothly. Minimum quantity is 1 (or removes if zero). Subtotals and badge counts recalculate dynamically.
* **Actual Result:** Item was added with custom note, badge count increased to 2, and unit/subtotal prices calculated accurately (LKR 1,300.00).
* **Status:** `PASS`

---

### TC05 - Simulated Checkout & Order Creation
* **Test Description:** Verify simulated checkout flow, pickup options, and order placement.
* **Pre-conditions:** Cart contains at least one food item.
* **Steps:**
  1. On the Cart screen, tap "CHECKOUT".
  2. Select Pickup Counter (e.g., "Main Canteen - Counter 1").
  3. Select Pickup Time (e.g., "ASAP (10-15 mins)").
  4. Verify prefilled student contact information.
  5. Tap "PLACE ORDER".
* **Expected Result:** Simulated checkout executes without errors, clears the active cart tray, and navigates to Order Confirmation with a dynamic order number (e.g., `QB-XXXX`).
* **Actual Result:** Unique order reference was generated, cart was cleared, and confirmation screen rendered all order breakdown details.
* **Status:** `PASS`

---

### TC06 - Order Tracking Status Progression
* **Test Description:** Verify real-time tracking timeline across all defined stages: Placed -> Preparing -> Ready for pickup.
* **Pre-conditions:** Order confirmation screen is open.
* **Steps:**
  1. Tap "TRACK ORDER STATUS" to open `/order-tracking`.
  2. Verify initial status is "Placed".
  3. Tap "Simulate Kitchen ➔ Preparing".
  4. Verify timeline indicator shifts to "Preparing" with highlighted state.
  5. Tap "Simulate Kitchen ➔ Ready for Pickup".
  6. Verify stage updates to "Ready for Pickup".
* **Expected Result:** Stepper updates visually across stages without page reload, reflecting live simulated canteen progress.
* **Actual Result:** Status moved seamlessly through Placed ➔ Preparing ➔ Ready for pickup.
* **Status:** `PASS`

---

### TC07 - Responsive Phone Layout
* **Test Description:** Verify UI presentation, touch targets, and typography on mobile screen dimensions (360px - 480px width).
* **Pre-conditions:** Device / viewport configured to phone resolution (e.g. 390 x 844).
* **Steps:**
  1. Navigate through all screens: Splash, Login, Home, Detail, Cart, Checkout, Confirmation, Tracking, Profile.
  2. Inspect layout boundaries for any yellow/black RenderFlex overflow bars.
* **Expected Result:** Layout stacks vertically, food grid adapts to 1 or 2 columns, action buttons are easily tappable, no overflows occur.
* **Actual Result:** Zero layout overflows; spacing and typography adapted smoothly on mobile viewport.
* **Status:** `PASS`

---

### TC08 - Responsive Tablet Layout
* **Test Description:** Verify expanded 2-pane / multi-column grid layout on tablet screen dimensions (650px - 1024px+ width).
* **Pre-conditions:** Device / viewport configured to tablet resolution (e.g. 800 x 1280).
* **Steps:**
  1. Open Home Screen and verify 3-4 column grid.
  2. Open Cart / Checkout Screen and verify side-by-side split layout (Form / Order list on left, Summary Card on right).
  3. Open Profile Screen and verify split layout (User Card on left, Order History list on right).
* **Expected Result:** Application takes advantage of wider screen real estate with elegant dual-column layouts and adaptive content containers.
* **Actual Result:** Split views rendered cleanly with optimal whitespace and zero RenderFlex issues.
* **Status:** `PASS`

---

## Automated Test Execution Log

```
00:00 +0: loading C:/New folder (2)/quickbite_app/test/app_state_test.dart
00:00 +0: AppState Business Logic Tests Initial state contains mock food items and empty cart
00:00 +1: AppState Business Logic Tests Authentication and Guest mode work correctly
00:00 +2: AppState Business Logic Tests Category filtering and search work accurately
00:00 +3: AppState Business Logic Tests Add to Cart, Increment, Decrement, and Subtotal calculations
00:00 +4: AppState Business Logic Tests Order placement and tracking state advancement
00:00 +5: Widget Tests: App startup and Splash screen smoke test
00:01 +6: Widget Tests: LoginScreen form validation and Guest login
00:01 +7: Widget Tests: HomeScreen renders categories and menu items
00:02 +8: Widget Tests: CartScreen displays items and calculates totals
00:02 +9: All tests passed!
```
