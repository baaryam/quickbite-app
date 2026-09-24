# QuickBite – Campus Food Ordering App 🍔🥤

A cross-platform mobile application built with **Flutter & Dart** designed for university campus canteens. QuickBite allows students to browse daily menus, customize food orders, bypass long canteen queues between lecture breaks, and track kitchen preparation status in real-time.

---

## 📱 Features

* **Splash Screen:** QuickBite animated canteen branding with automatic smooth transition.
* **Authentication & Guest Mode:** Student sign-in with full validation and one-tap guest access.
* **Campus Menu & Category Filtering:** Instant filtering by **Meals**, **Beverages**, and **Snacks** with item counts and realistic Sri Lankan Rupee (LKR) pricing.
* **Real-time Live Search:** Instant keyword matching across item names, categories, and descriptions.
* **Item Detail & Customization:** Detailed food cards with preparation times, chef recommendations, vegetarian tags, quantity selectors, and custom preparation notes.
* **Persistent Cart State Management:** Provider-backed reactive state that tracks items, quantity updates, unit prices, and grand totals across all screens.
* **Simulated Checkout:** Select campus pickup counters (Main Canteen Counter 1 & 2, Faculty Cafe, Student Kiosk) and estimated pickup times (ASAP, After Next Lecture).
* **Dynamic Order Confirmation:** Generates unique order references (e.g. `QB-4819`) with a full itemized breakdown.
* **Live Order Tracking Stepper:** Interactive progress timeline showing:
  `Placed ➔ Preparing ➔ Ready for pickup` with a built-in simulation mechanism.
* **Student Profile & Order History:** View student registration info, account statistics, and browse past simulated orders.
* **Adaptive & Responsive Design:** Optimized for both mobile phones and tablets without layout overflow errors.

---

## 🛠️ Technology Stack

* **Framework:** Flutter 3.47.4 / Dart 3.13.3
* **State Management:** Provider (`ChangeNotifier`, `Consumer`)
* **Styling:** Material Design 3 with custom warm campus palette
* **Testing:** Flutter Test Framework (`test/app_state_test.dart`, `test/widget_test.dart`)

---

## 📂 Project Architecture

```
quickbite_app/
├── lib/
│   ├── data/
│   │   └── mock_data.dart            # Canteen food items catalog
│   ├── models/
│   │   ├── cart_item.dart            # Cart item entity & subtotal logic
│   │   ├── food_item.dart            # Food item model & category enums
│   │   ├── order.dart                # Order entity & lifecycle state
│   │   └── user_profile.dart         # User & guest profile model
│   ├── providers/
│   │   └── app_state.dart            # Central Provider state management
│   ├── screens/
│   │   ├── cart_screen.dart          # Cart tray & subtotal breakdown
│   │   ├── checkout_screen.dart      # Pickup selection & simulated checkout
│   │   ├── home_screen.dart          # Menu catalog, search & category chips
│   │   ├── item_detail_screen.dart   # Food detail & quantity selector
│   │   ├── login_screen.dart         # Student login & guest access
│   │   ├── order_confirmation_screen.dart # Dynamic order receipt
│   │   ├── order_tracking_screen.dart# Kitchen progress stepper & simulator
│   │   ├── profile_screen.dart       # Student account & order history
│   │   └── splash_screen.dart        # Animated splash screen
│   ├── theme/
│   │   └── app_theme.dart            # Consistent design system & color tokens
│   ├── utils/
│   │   └── responsive_layout.dart    # Tablet & phone layout helpers
│   ├── widgets/
│   │   ├── category_chip.dart        # Category filter chip
│   │   ├── food_card.dart            # Responsive menu item card
│   │   ├── food_image_widget.dart    # App icon & gradient food visual
│   │   ├── order_status_stepper.dart # Live tracking step timeline
│   │   └── quantity_button.dart      # Increment/decrement modifier
│   └── main.dart                     # App entry point & route definitions
├── test/
│   ├── app_state_test.dart           # AppState unit tests (cart, order, filter)
│   └── widget_test.dart              # Widget tests (startup, login, home, cart)
├── pubspec.yaml                      # Dependencies & asset declarations
├── TESTING.md                        # Manual test cases TC01 to TC08 & logs
└── SUBMISSION_REPORT.md              # In-class activity final report
```

---

## 🚀 How to Run the Application

### 1. Prerequisites
Ensure Flutter SDK is installed and available in your `PATH`:
```bash
flutter doctor
```

### 2. Install Dependencies
```bash
cd quickbite_app
flutter pub get
```

### 3. Run Static Code Analysis
```bash
flutter analyze
```

### 4. Execute Automated Unit & Widget Tests
```bash
flutter test
```

### 5. Launch the Application
Run on your connected Android emulator, iOS simulator, or Chrome/Desktop:
```bash
# Run on default connected device
flutter run

# Or specify a device (e.g., Windows or Chrome)
flutter run -d windows
flutter run -d chrome
```

---

## 🧪 Testing Summary

All 8 required manual test cases and 9 automated test specifications are fully passing:
* `TC01` - Splash to Login Navigation (`PASS`)
* `TC02` - Guest Access & Login Validation (`PASS`)
* `TC03` - Menu Search & Category Filter (`PASS`)
* `TC04` - Add to Cart & Subtotals (`PASS`)
* `TC05` - Checkout & Order Placement (`PASS`)
* `TC06` - Order Tracking Progression (`PASS`)
* `TC07` - Responsive Phone Layout (`PASS`)
* `TC08` - Responsive Tablet Layout (`PASS`)

Refer to [TESTING.md](file:///c:/New%20folder%20(2)/quickbite_app/TESTING.md) and [SUBMISSION_REPORT.md](file:///c:/New%20folder%20(2)/quickbite_app/SUBMISSION_REPORT.md) for detailed test logs and submission evidence.
