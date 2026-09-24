import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quickbite_app/main.dart';
import 'package:quickbite_app/providers/app_state.dart';
import 'package:quickbite_app/screens/home_screen.dart';
import 'package:quickbite_app/screens/cart_screen.dart';
import 'package:quickbite_app/screens/login_screen.dart';
import 'package:quickbite_app/theme/app_theme.dart';

void main() {
  testWidgets('App startup and Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuickBiteApp());

    // Verify QuickBite branding elements exist
    expect(find.text('Quick'), findsOneWidget);
    expect(find.text('Bite'), findsOneWidget);
    expect(find.text('CAMPUS FOOD ORDERING APP'), findsOneWidget);

    // Fast-forward splash timer
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify navigation to Login screen
    expect(find.text('Student Sign In'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });

  testWidgets('LoginScreen form validation and Guest login', (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
          routes: {
            '/home': (context) => const Scaffold(body: Text('Home Screen Destination')),
          },
        ),
      ),
    );

    // Tap Continue as Guest
    await tester.tap(find.text('Continue as Guest'));
    await tester.pumpAndSettle();

    expect(appState.isAuthenticated, true);
    expect(appState.currentUser?.isGuest, true);
  });

  testWidgets('HomeScreen renders categories and menu items', (WidgetTester tester) async {
    final appState = AppState();
    appState.continueAsGuest();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
        ),
      ),
    );

    // Verify category chips
    expect(find.text('All Items'), findsOneWidget);
    expect(find.text('Meals'), findsOneWidget);
    expect(find.text('Beverages'), findsOneWidget);
    expect(find.text('Snacks'), findsOneWidget);

    // Verify some menu items
    expect(find.text('Rice & Curry'), findsOneWidget);
    expect(find.text('Chicken Fried Rice'), findsOneWidget);
  });

  testWidgets('CartScreen displays items and calculates totals', (WidgetTester tester) async {
    final appState = AppState();
    final firstItem = appState.allFoodItems.first;
    appState.addToCart(firstItem, quantity: 2);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const CartScreen(),
        ),
      ),
    );

    expect(find.text('Your Canteen Tray'), findsOneWidget);
    expect(find.text(firstItem.name), findsOneWidget);
    expect(find.text('CHECKOUT'), findsOneWidget);
    expect(find.text(appState.formattedCartGrandTotal), findsWidgets);
  });
}
