import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momo_ui_lab/main.dart';
import 'package:momo_ui_lab/screens/bill_form_screen.dart';
import 'package:momo_ui_lab/screens/bill_payment_screen.dart';
import 'package:momo_ui_lab/screens/home_screen.dart';
import 'package:momo_ui_lab/screens/result_screen.dart';

void main() {
  group('MoMo App Navigation & Flow Tests', () {
    void setViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    testWidgets(
      'Navigates from Home to Bill Payment Screen when tapping "Thanh toán hóa đơn"',
      (WidgetTester tester) async {
        setViewport(tester);
        await tester.pumpWidget(const MomoApp());
        await tester.pumpAndSettle();

        // 1. Initial state: HomeScreen is rendered
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.text('Dịch vụ tiện ích MoMo'), findsOneWidget);

        // 2. Locate "Thanh toán hóa đơn" service item and tap it
        final billPaymentButton = find.text('Thanh toán\nhóa đơn');
        expect(billPaymentButton, findsOneWidget);

        await tester.ensureVisible(billPaymentButton);
        await tester.tap(billPaymentButton);
        await tester.pumpAndSettle();

        // 3. Verify BillPaymentScreen is opened
        expect(find.byType(BillPaymentScreen), findsOneWidget);
        expect(find.text('Chọn dịch vụ thanh toán'), findsOneWidget);
        expect(find.text('Điện'), findsOneWidget);
        expect(find.text('Nước'), findsOneWidget);
      },
    );

    testWidgets(
      'Navigates from Bill Payment to Electricity Form Screen and validates inputs',
      (WidgetTester tester) async {
        setViewport(tester);
        await tester.pumpWidget(const MomoApp());
        await tester.pumpAndSettle();

        // Tap "Thanh toán hóa đơn"
        final billPaymentButton = find.text('Thanh toán\nhóa đơn');
        await tester.ensureVisible(billPaymentButton);
        await tester.tap(billPaymentButton);
        await tester.pumpAndSettle();

        // Tap "Điện"
        final electricityItem = find.text('Điện');
        expect(electricityItem, findsOneWidget);
        await tester.ensureVisible(electricityItem);
        await tester.tap(electricityItem);
        await tester.pumpAndSettle();

        // Verify BillFormScreen is rendered for Electricity
        expect(find.byType(BillFormScreen), findsOneWidget);
        expect(find.text('Hóa đơn tiền điện'), findsWidgets);
        expect(find.text('EVN - Tập đoàn Điện lực Việt Nam'), findsOneWidget);
        expect(find.text('Mã khách hàng (EVN)'), findsOneWidget);

        // Tap sample code quick fill
        final sampleBtn = find.text('Điền mã mẫu');
        expect(sampleBtn, findsOneWidget);
        await tester.ensureVisible(sampleBtn);
        await tester.tap(sampleBtn);
        await tester.pumpAndSettle();

        // Verify sample code is populated
        expect(find.text('PE01000123456'), findsOneWidget);

        // Tap "Thanh toán"
        final payBtn = find.widgetWithText(ElevatedButton, 'Thanh toán');
        await tester.ensureVisible(payBtn);
        await tester.tap(payBtn);
        await tester.pumpAndSettle();

        // Verify ResultScreen is reached
        expect(find.byType(ResultScreen), findsOneWidget);
        expect(find.text('Thanh toán thành công!'), findsOneWidget);
        expect(find.text('450.000 đ'), findsWidgets);

        // Tap "Về trang chủ"
        final homeBtn = find.widgetWithText(ElevatedButton, 'Về trang chủ');
        await tester.ensureVisible(homeBtn);
        await tester.tap(homeBtn);
        await tester.pumpAndSettle();

        // Verify we are back on HomeScreen
        expect(find.byType(HomeScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Navigates from Bill Payment to Water Form Screen and tests back button',
      (WidgetTester tester) async {
        setViewport(tester);
        await tester.pumpWidget(const MomoApp());
        await tester.pumpAndSettle();

        // Tap "Thanh toán hóa đơn"
        final billPaymentButton = find.text('Thanh toán\nhóa đơn');
        await tester.ensureVisible(billPaymentButton);
        await tester.tap(billPaymentButton);
        await tester.pumpAndSettle();

        // Tap "Nước"
        final waterItem = find.text('Nước');
        expect(waterItem, findsOneWidget);
        await tester.ensureVisible(waterItem);
        await tester.tap(waterItem);
        await tester.pumpAndSettle();

        // Verify Water bill form
        expect(find.byType(BillFormScreen), findsOneWidget);
        expect(find.text('Hóa đơn tiền nước'), findsWidgets);
        expect(find.text('SAWACO - Cấp nước Sài Gòn'), findsOneWidget);
        expect(find.text('Mã danh bộ (Nước)'), findsOneWidget);

        // Tap Back button on AppBar
        final backBtn = find.byTooltip('Quay lại');
        await tester.tap(backBtn);
        await tester.pumpAndSettle();

        // Verify returned to BillPaymentScreen
        expect(find.byType(BillPaymentScreen), findsOneWidget);

        // Tap Back again to return to HomeScreen
        await tester.tap(find.byTooltip('Quay lại'));
        await tester.pumpAndSettle();

        // Verify returned to HomeScreen
        expect(find.byType(HomeScreen), findsOneWidget);
      },
    );
  });
}
