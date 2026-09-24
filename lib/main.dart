import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/food_item.dart';
import 'providers/app_state.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/item_detail_screen.dart';
import 'screens/login_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuickBiteApp());
}

class QuickBiteApp extends StatelessWidget {
  const QuickBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'QuickBite – Campus Food Ordering',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/order-confirmation': (context) => const OrderConfirmationScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/item-detail') {
            final item = settings.arguments as FoodItem;
            return MaterialPageRoute(
              builder: (context) => ItemDetailScreen(item: item),
            );
          } else if (settings.name == '/order-tracking') {
            final orderId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => OrderTrackingScreen(orderId: orderId),
            );
          }
          return null;
        },
      ),
    );
  }
}
