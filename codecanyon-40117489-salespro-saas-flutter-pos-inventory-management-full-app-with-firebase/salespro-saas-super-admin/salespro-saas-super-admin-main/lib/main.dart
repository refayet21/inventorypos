import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_saas_admin/Screen/Authentication/forgot_password.dart';
import 'package:salespro_saas_admin/Screen/Authentication/log_in.dart';
import 'package:salespro_saas_admin/Screen/Dashboard/dashboard.dart';
import 'package:salespro_saas_admin/Screen/Package/package.dart';
import 'package:salespro_saas_admin/Screen/Reports/reports.dart';
import 'package:salespro_saas_admin/Screen/Shop%20Category/shop_category.dart';
import 'package:salespro_saas_admin/Screen/Shop%20Management/shop_management.dart';
import 'package:url_strategy/url_strategy.dart';
import 'Homepage Advertising/homepage_advertising.dart';
import 'Screen/Currency/currency_screen.dart';
import 'Screen/Payment Settings/payment_settings_screen.dart';
import 'Screen/Subscription Plans/subscription_plans.dart';
import 'Screen/User Role/user_role_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  setPathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salespro Saas Admin',
      initialRoute: '/',
      builder: EasyLoading.init(),
      routes: {
        '/': (context) => const LogIn(),
        MtDashboard.route: (context) => const MtDashboard(),
        ShopManagement.route: (context) => const ShopManagement(),
        ShopCategory.route: (context) => const ShopCategory(),
        Package.route: (context) => const Package(),
        Reports.route: (context) => const Reports(),
        ForgotPassword.route: (context) => const ForgotPassword(),
        PaymentSettings.route: (context) => const PaymentSettings(),
        SubscriptionPlans.route: (context) => const SubscriptionPlans(),
        HomepageAdvertising.route: (context) => const HomepageAdvertising(),
        UserRoleScreen.route: (context) => const UserRoleScreen(),
        CurrencyScreen.route: (context) => const CurrencyScreen(),
      },
    );
  }
}
