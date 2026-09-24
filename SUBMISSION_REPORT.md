# QuickBite – Campus Food Ordering App
## Cross-Platform Mobile Application Development & Testing In-Class Activity Report

---

### 1. Project Title
**QuickBite – Smart Campus Food Ordering & Queue Reduction Mobile Application**

* **Framework:** Flutter (Dart)
* **Target Platforms:** Android & iOS (Single Cross-Platform Codebase)
* **Author / Student Developer:** Kobi Perera
* **Course:** Cross-Platform Mobile App Development & Testing

---

### 2. Introduction
University canteens face severe congestion and long queues during short intervals between lectures. Students often spend 15 to 25 minutes waiting in line, leading to missed meals or arriving late to lecture halls. 

**QuickBite** is a lightweight, responsive mobile application designed to streamline campus dining by allowing students to browse the daily canteen menu, customize their meal selections, place pre-orders with estimated pickup times, and track order preparation status in real-time.

---

### 3. Objectives
* Design and implement an MVP cross-platform food ordering application for Android and iOS using a single Flutter codebase.
* Provide seamless menu browsing with instant category filtering (Meals, Beverages, Snacks) and real-time search.
* Enable robust cart state management using `Provider` / `ChangeNotifier` that persists across all application screens.
* Implement simulated order placement with dynamic order ID generation (`QB-XXXX`) and multi-stage status tracking (Placed ➔ Preparing ➔ Ready for pickup).
* Ensure adaptive responsiveness across various device form factors (Mobile phones and Tablets) without UI overflow errors.
* Execute comprehensive automated and manual test cases covering functional, non-functional, and usability requirements.

---

### 4. Functional Requirements

| Requirement ID | Module / Feature | Description |
| :--- | :--- | :--- |
| **FR-01** | **Splash Screen** | Display QuickBite branding with animated canteen logo and automated transition to the authentication screen. |
| **FR-02** | **Authentication & Guest Mode** | Allow registered student login with validation and instant one-tap guest access ("Guest Student"). |
| **FR-03** | **Menu & Category Filtering** | Display canteen items organized by Meals, Beverages, and Snacks with prices in Sri Lankan Rupees (LKR), ratings, and prep times. |
| **FR-04** | **Real-Time Search** | Filter menu items instantly as the user types queries in the search bar. |
| **FR-05** | **Item Details & Customization** | Detailed item view with large image, description, quantity selector (`[-] [Qty] [+]`), special notes, and dynamic price total. |
| **FR-06** | **Cart Management** | Display selected items, unit prices, quantity modifiers, item removal, and real-time calculation of item subtotals and grand total. |
| **FR-07** | **Simulated Checkout** | Select pickup counter location, scheduled pickup time (e.g. ASAP, After Next Lecture), and place order. |
| **FR-08** | **Order Confirmation** | Generate dynamic local Order ID (e.g. `QB-7842`), display order summary, and direct links to live tracking. |
| **FR-09** | **Order Status Tracking** | Interactive timeline stepper showing status progression (Placed ➔ Preparing ➔ Ready for pickup). |
| **FR-10** | **Student Profile & History** | Display student credentials, guest/verified badge, account statistics, and historical order log. |

---

### 5. Non-Functional Requirements
* **Cross-Platform Compatibility:** 100% single Dart codebase functioning identically on Android and iOS platforms.
* **Responsive Design:** Utilizes `LayoutBuilder`, `MediaQuery`, and adaptive flex grids (`SliverGrid`) to deliver optimal layouts for both phones and tablets.
* **Performance & Transitions:** Smooth screen transitions (under 1–2 seconds) and 60 FPS scrolling.
* **State Persistence:** Cart tray and active orders remain persistent across route navigation using Provider.
* **Offline-First / Zero Backend Dependency:** Built with local mock datasets and simulated state machines.

---

### 6. Technology Stack
* **Framework:** Flutter SDK `3.47.4` (Channel Stable)
* **Language:** Dart `3.13.3`
* **State Management:** `provider: ^6.1.5+1` (`ChangeNotifierProvider`, `Consumer`)
* **Date & Formatting:** `intl: ^0.20.3`
* **Icons & Typography:** Flutter Material Design 3 Icons & Roboto Typography
* **Testing:** `flutter_test` (Automated Unit & Widget Testing)

---

### 7. Screen & Navigation Structure

```
[ Splash Screen ] (/splash)
        │
        ▼
[ Login / Guest Screen ] (/login)
        │
        ▼
[ Home Screen ] (/home)  ◄────────────────────────┐
   ├── [ Item Detail Screen ] (/item-detail)      │
   ├── [ Cart Screen ] (/cart)                    │
   │       └── [ Checkout Screen ] (/checkout)    │
   │               └── [ Order Confirmation ] ────┤
   │                       └── [ Order Tracking ] ┤
   └── [ Student Profile & History ] (/profile) ──┘
```

---

### 8. State Management Architecture
State management is implemented using the **Provider** pattern via `AppState` extending `ChangeNotifier`.

Key responsibilities handled in `AppState`:
1. **User Authentication:** Tracks active user session (`UserProfile`) or Guest user state.
2. **Menu Catalog & Search:** Manages full food item catalog, active category filter, and real-time query string.
3. **Shopping Cart:** Manages item quantities, modifications, subtotal calculations, and badge counts.
4. **Order Lifecycle:** Creates new orders with randomized order IDs (`QB-XXXX`), adds them to the order history, and advances order statuses (`OrderStatus.placed` ➔ `OrderStatus.preparing` ➔ `OrderStatus.readyForPickup`).

---

### 9. Data Model

```dart
// 1. Food Category
enum FoodCategory { meals, beverages, snacks }

// 2. Food Item
class FoodItem {
  final String id;
  final String name;
  final FoodCategory category;
  final double price;
  final String description;
  final String imagePath;
  final String prepTime;
  final double rating;
  final bool isVegetarian;
  final List<String> tags;
}

// 3. Cart Item
class CartItem {
  final FoodItem foodItem;
  int quantity;
  String? specialInstructions;
  double get subtotal => foodItem.price * quantity;
}

// 4. Order Model
class OrderModel {
  final String id; // e.g. "QB-4821"
  final String customerName;
  final String customerPhone;
  final String pickupLocation;
  final String estimatedPickupTime;
  final List<CartItem> items;
  final double subtotal;
  final double serviceFee;
  final double total;
  final DateTime createdAt;
  OrderStatus status; // placed -> preparing -> readyForPickup -> completed
}
```

---

### 10. Testing Strategy
A dual testing strategy was executed:
1. **Automated Unit & Widget Testing:** Automated test suites verifying state calculations, quantity boundary checks, filter logic, order generation, and widget rendering.
2. **Manual Functional Testing:** 8 comprehensive test scenarios validating navigation, touch interactions, responsive layouts, form validations, and status simulations.

---

### 11. Test Cases & Execution Results

| Test ID | Test Description | Expected Result | Actual Result | Status |
| :--- | :--- | :--- | :--- | :---: |
| **TC01** | Splash to Login Navigation | Auto-navigates smoothly after 2.4s | Splash loads and transitions to Login screen | **PASS** |
| **TC02** | Guest Access & Login Validation | Form errors on empty fields; 1-tap guest access | Errors displayed correctly; Guest mode logs in | **PASS** |
| **TC03** | Menu Search & Category Filter | Instant filtering of items by category and query | Live filtering matched all search terms | **PASS** |
| **TC04** | Cart Addition & Subtotals | Dynamic qty updates, correct LKR totals | Cart calculations matched accurately | **PASS** |
| **TC05** | Checkout & Order Placement | Order generated with `QB-XXXX` reference | Order placed with unique ID; cart cleared | **PASS** |
| **TC06** | Order Tracking Progression | Step timeline moves through all 3 stages | Stepper updated (Placed ➔ Preparing ➔ Ready) | **PASS** |
| **TC07** | Responsive Phone Layout | Vertical stack, zero RenderFlex overflow | Rendered with clean mobile cards and spacing | **PASS** |
| **TC08** | Responsive Tablet Layout | Multi-column grid & 2-pane checkout/profile | Layout utilized tablet width optimally | **PASS** |

---

### 12. Screenshots Section


#### 1. Splash Screen
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/611400d8-5d07-4beb-adb5-1e67cd56cbd0" />

#### 2. Login / Guest Access Screen
`[ Insert Screenshot: 02_login_screen.png ]`

#### 3. Home Screen (Menu & Category Filter)
`[ Insert Screenshot: 03_home_screen.png ]`

#### 4. Item Detail Screen
`[ Insert Screenshot: 04_item_detail_screen.png ]`

#### 5. Cart / Tray Screen
`[ Insert Screenshot: 05_cart_screen.png ]`

#### 6. Simulated Checkout Screen
`[ Insert Screenshot: 06_checkout_screen.png ]`

#### 7. Order Confirmation Screen
`[ Insert Screenshot: 07_order_confirmation_screen.png ]`

#### 8. Live Order Tracking Screen
`[ Insert Screenshot: 08_order_tracking_screen.png ]`

#### 9. Student Profile & Order History Screen
`[ Insert Screenshot: 09_profile_screen.png ]`

#### 10. Phone Responsive View
`[ Insert Screenshot: 10_phone_responsive_view.png ]`

#### 11. Tablet Responsive View
`[ Insert Screenshot: 11_tablet_responsive_view.png ]`

#### 12. Successful Test Execution Terminal Evidence
`[ Insert Screenshot: 12_test_execution_terminal.png ]`

---

### 13. GitHub Repository Link Placeholder
* **GitHub Repository URL:** `https://github.com/baaryam/quickbite_app`
* **Branch:** `main`
* **Commit Hash:** `Initial MVP Release - Complete QuickBite Implementation`

---
*Report generated and validated for University In-Class Activity Submission.*
