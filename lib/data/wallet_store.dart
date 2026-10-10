import 'package:flutter/material.dart';

/// A bill waiting to be paid, rendered in the Home screen quick-pay section.
class PendingBill {
  final String serviceId;
  final String title;
  final String customerCode;
  final int amount;
  final IconData icon;

  const PendingBill({
    required this.serviceId,
    required this.title,
    required this.customerCode,
    required this.amount,
    required this.icon,
  });
}

/// In-memory wallet state for a single app run (mock data, mất khi tắt app).
/// HomeScreen chỉ đọc, BillFormScreen đổi state qua [pay]; state sống ở đây
/// nên không bị reset khi pop về Home.
class WalletStore {
  WalletStore._();

  static const int initialBalance = 9850000;

  static const List<PendingBill> defaultBills = [
    PendingBill(
      serviceId: 'electricity',
      title: 'Hóa đơn tiền điện EVN',
      customerCode: 'PE01000123456',
      amount: 450000,
      icon: Icons.bolt_rounded,
    ),
    PendingBill(
      serviceId: 'water',
      title: 'Hóa đơn tiền nước SAWACO',
      customerCode: '14123456',
      amount: 185000,
      icon: Icons.water_drop_rounded,
    ),
  ];

  static final ValueNotifier<int> balance = ValueNotifier<int>(initialBalance);

  static final ValueNotifier<List<PendingBill>> pendingBills =
      ValueNotifier<List<PendingBill>>(defaultBills);

  /// Trừ số dư và bỏ hóa đơn của [serviceId] khỏi danh sách chờ.
  /// Trả về false (không trừ gì) nếu số tiền không hợp lệ hoặc vượt số dư.
  static bool pay({required String serviceId, required int amount}) {
    if (amount <= 0 || amount > balance.value) {
      return false;
    }
    balance.value -= amount;
    pendingBills.value = pendingBills.value
        .where((bill) => bill.serviceId != serviceId)
        .toList();
    return true;
  }

  /// Đưa state về ban đầu (dùng cho test).
  static void reset() {
    balance.value = initialBalance;
    pendingBills.value = defaultBills;
  }
}
