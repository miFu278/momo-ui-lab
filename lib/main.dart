import 'package:flutter/material.dart';
import 'data/mock_services.dart';
import 'screens/bill_form_screen.dart';
import 'screens/bill_payment_screen.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MomoApp());
}

/// Root widget of the MoMo UI application
class MomoApp extends StatelessWidget {
  const MomoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoMo UI Lab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/bill-payment': (context) => const BillPaymentScreen(),
        '/bill-payment/electricity': (context) => const BillFormScreen(
              initialService: MockServices.electricityConfig,
            ),
        '/bill-payment/water': (context) => const BillFormScreen(
              initialService: MockServices.waterConfig,
            ),
        '/bill-payment/internet': (context) => const BillFormScreen(
              initialService: MockServices.internetConfig,
            ),
        '/bill-payment/tv': (context) => const BillFormScreen(
              initialService: MockServices.tvConfig,
            ),
        '/bill-payment/postpaid': (context) => const BillFormScreen(
              initialService: MockServices.postpaidConfig,
            ),
        '/bill-payment/tuition': (context) => const BillFormScreen(
              initialService: MockServices.tuitionConfig,
            ),
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}
