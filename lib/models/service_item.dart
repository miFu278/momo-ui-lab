import 'package:flutter/material.dart';

/// ServiceItem represents an actionable service item on the MoMo dashboard or category screen.
class ServiceItem {
  final String id;
  final String label;
  final IconData icon;
  final String? route;
  final String? subtitle;
  final String? badgeText;
  final Color? badgeColor;

  const ServiceItem({
    required this.id,
    required this.label,
    required this.icon,
    this.route,
    this.subtitle,
    this.badgeText,
    this.badgeColor,
  });
}

/// BillFormArguments encapsulates configuration and data required by the reusable BillFormScreen.
class BillFormArguments {
  final String serviceId;
  final String title;
  final IconData icon;
  final String providerName;
  final String customerCodeLabel;
  final String customerCodeHint;
  final String sampleCustomerCode;
  final String defaultPeriod;
  final int defaultAmount;
  final String instructions;

  const BillFormArguments({
    required this.serviceId,
    required this.title,
    required this.icon,
    required this.providerName,
    required this.customerCodeLabel,
    required this.customerCodeHint,
    required this.sampleCustomerCode,
    required this.defaultPeriod,
    required this.defaultAmount,
    required this.instructions,
  });
}

/// PaymentResultArguments contains receipt data passed to the ResultScreen.
class PaymentResultArguments {
  final String serviceId;
  final String serviceName;
  final IconData serviceIcon;
  final String providerName;
  final String customerCode;
  final String period;
  final int amount;
  final String transactionId;
  final DateTime timestamp;
  final String paymentSource;

  const PaymentResultArguments({
    required this.serviceId,
    required this.serviceName,
    required this.serviceIcon,
    required this.providerName,
    required this.customerCode,
    required this.period,
    required this.amount,
    required this.transactionId,
    required this.timestamp,
    this.paymentSource = 'Ví MoMo',
  });
}
