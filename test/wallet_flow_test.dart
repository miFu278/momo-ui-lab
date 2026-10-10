import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momo_ui_lab/data/wallet_store.dart';
import 'package:momo_ui_lab/main.dart';
import 'package:momo_ui_lab/screens/home_screen.dart';
import 'package:momo_ui_lab/screens/result_screen.dart';

void main() {
  setUp(WalletStore.reset);

  test('pay() trừ tiền, xoá hoá đơn và chặn khi số dư không đủ', () {
    expect(WalletStore.pay(serviceId: 'electricity', amount: 450000), isTrue);
    expect(WalletStore.balance.value, 9400000);
    expect(WalletStore.pendingBills.value.map((b) => b.serviceId),
        isNot(contains('electricity')));

    // Vượt số dư: không trừ, hoá đơn còn nguyên
    expect(WalletStore.pay(serviceId: 'water', amount: 99999999), isFalse);
    expect(WalletStore.balance.value, 9400000);
    expect(WalletStore.pendingBills.value, hasLength(1));
  });

  testWidgets('Thanh toán hoá đơn điện rồi về Home: trừ tiền + mất hoá đơn',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MomoApp());
    await tester.pumpAndSettle();
    expect(find.text('9.850.000 đ'), findsOneWidget);

    // Trả hoá đơn điện 450.000 từ danh sách "Hoá đơn chưa thanh toán"
    final payButton =
        find.widgetWithText(ElevatedButton, 'Thanh toán').first;
    await tester.dragUntilVisible(
      payButton,
      find.byType(CustomScrollView),
      const Offset(0, -300),
    );
    await tester.tap(payButton);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'PE01000123456');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Thanh toán'));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsOneWidget);

    await tester.tap(find.text('Về trang chủ'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('9.400.000 đ'), findsOneWidget);
    expect(find.text('Hóa đơn tiền điện EVN'), findsNothing);
    expect(find.text('Hóa đơn tiền nước SAWACO'), findsOneWidget);
  });
}
