import 'package:flutter/material.dart';
import '../models/service_item.dart';

/// MockServices provides static dummy data for home screen services and bill payment forms.
class MockServices {
  MockServices._();

  /// Services rendered on the Home Screen grid
  static const List<ServiceItem> homeServices = [
    ServiceItem(
      id: 'bill_payment',
      label: 'Thanh toán\nhóa đơn',
      icon: Icons.receipt_long_rounded,
      route: '/bill-payment',
      badgeText: 'HOT',
    ),
    ServiceItem(
      id: 'mobile_topup',
      label: 'Nạp tiền\nđiện thoại',
      icon: Icons.phone_android_rounded,
    ),
    ServiceItem(
      id: 'transfer_money',
      label: 'Chuyển\ntiền',
      icon: Icons.send_rounded,
    ),
    ServiceItem(
      id: 'data_topup',
      label: 'Nạp Data\n3G/4G/5G',
      icon: Icons.signal_cellular_alt_rounded,
    ),
    ServiceItem(
      id: 'travel_ticket',
      label: 'Vé tàu xe\nmáy bay',
      icon: Icons.directions_bus_rounded,
    ),
    ServiceItem(
      id: 'postpaid_wallet',
      label: 'Ví\nTrả Sau',
      icon: Icons.credit_card_rounded,
    ),
    ServiceItem(
      id: 'insurance',
      label: 'Bảo hiểm\nsức khỏe',
      icon: Icons.health_and_safety_rounded,
    ),
    ServiceItem(
      id: 'all_services',
      label: 'Tất cả\ndịch vụ',
      icon: Icons.grid_view_rounded,
    ),
  ];

  /// Bill payment categories shown in the Bill Payment screen
  static const List<ServiceItem> billCategories = [
    ServiceItem(
      id: 'electricity',
      label: 'Điện',
      icon: Icons.bolt_rounded,
      route: '/bill-payment/electricity',
      subtitle: 'EVN toàn quốc, tra cứu tự động hóa đơn',
    ),
    ServiceItem(
      id: 'water',
      label: 'Nước',
      icon: Icons.water_drop_rounded,
      route: '/bill-payment/water',
      subtitle: 'Cấp nước SAWACO và các tỉnh thành cả nước',
    ),
    ServiceItem(
      id: 'internet',
      label: 'Internet',
      icon: Icons.wifi_rounded,
      route: '/bill-payment/internet',
      subtitle: 'VNPT, FPT Telecom, Viettel, SPT',
    ),
    ServiceItem(
      id: 'tv',
      label: 'Truyền hình',
      icon: Icons.tv_rounded,
      route: '/bill-payment/tv',
      subtitle: 'VTVcab, K+, FPT Play, Viettel TV',
    ),
    ServiceItem(
      id: 'postpaid',
      label: 'Di động trả sau',
      icon: Icons.phone_iphone_rounded,
      route: '/bill-payment/postpaid',
      subtitle: 'Cước thuê bao Viettel, MobiFone, VinaPhone',
    ),
    ServiceItem(
      id: 'tuition',
      label: 'Học phí',
      icon: Icons.school_rounded,
      route: '/bill-payment/tuition',
      subtitle: 'Đại học, Cao đẳng, Học phí SSC, mầm non',
    ),
  ];

  /// Preconfigured bill form settings for Electricity
  static const BillFormArguments electricityConfig = BillFormArguments(
    serviceId: 'electricity',
    title: 'Hóa đơn tiền điện',
    icon: Icons.bolt_rounded,
    providerName: 'EVN - Tập đoàn Điện lực Việt Nam',
    customerCodeLabel: 'Mã khách hàng (EVN)',
    customerCodeHint: 'VD: PE01000123456',
    sampleCustomerCode: 'PE01000123456',
    defaultPeriod: 'Kỳ Tháng 10/2026',
    defaultAmount: 450000,
    instructions:
        'Mã khách hàng gồm 13 ký tự bắt đầu bằng PE/PA/PB/PD in trên giấy báo tiền điện hoặc tin nhắn SMS từ EVN.',
  );

  /// Preconfigured bill form settings for Water
  static const BillFormArguments waterConfig = BillFormArguments(
    serviceId: 'water',
    title: 'Hóa đơn tiền nước',
    icon: Icons.water_drop_rounded,
    providerName: 'SAWACO - Cấp nước Sài Gòn',
    customerCodeLabel: 'Mã danh bộ (Nước)',
    customerCodeHint: 'VD: 14123456',
    sampleCustomerCode: '14123456',
    defaultPeriod: 'Kỳ Tháng 10/2026',
    defaultAmount: 185000,
    instructions:
        'Mã danh bộ gồm 8 đến 11 chữ số được in ở phần đầu trên giấy báo tiền nước hoặc hợp đồng cấp nước.',
  );

  /// Preconfigured bill form settings for Internet
  static const BillFormArguments internetConfig = BillFormArguments(
    serviceId: 'internet',
    title: 'Hóa đơn Internet',
    icon: Icons.wifi_rounded,
    providerName: 'VNPT / FPT / Viettel Telecom',
    customerCodeLabel: 'Mã hợp đồng / Số điện thoại',
    customerCodeHint: 'VD: HNI123456',
    sampleCustomerCode: 'HNI123456',
    defaultPeriod: 'Kỳ Tháng 10/2026',
    defaultAmount: 220000,
    instructions:
        'Nhập mã hợp đồng Internet hoặc số điện thoại đăng ký gói cước mạng của gia đình.',
  );

  /// Preconfigured bill form settings for TV
  static const BillFormArguments tvConfig = BillFormArguments(
    serviceId: 'tv',
    title: 'Hóa đơn truyền hình',
    icon: Icons.tv_rounded,
    providerName: 'VTVcab / K+ / FPT Play',
    customerCodeLabel: 'Mã thẻ giải mã / Mã khách hàng',
    customerCodeHint: 'VD: VTV889912',
    sampleCustomerCode: 'VTV889912',
    defaultPeriod: 'Kỳ Tháng 10/2026',
    defaultAmount: 150000,
    instructions:
        'Nhập mã thuê bao hoặc số serial trên đầu thu truyền hình của bạn.',
  );

  /// Preconfigured bill form settings for Postpaid
  static const BillFormArguments postpaidConfig = BillFormArguments(
    serviceId: 'postpaid',
    title: 'Cước di động trả sau',
    icon: Icons.phone_iphone_rounded,
    providerName: 'Viettel / MobiFone / VinaPhone',
    customerCodeLabel: 'Số điện thoại thuê bao',
    customerCodeHint: 'VD: 0987654321',
    sampleCustomerCode: '0987654321',
    defaultPeriod: 'Kỳ Tháng 10/2026',
    defaultAmount: 300000,
    instructions:
        'Nhập số điện thoại trả sau cần thanh toán cước tháng hiện tại.',
  );

  /// Preconfigured bill form settings for Tuition
  static const BillFormArguments tuitionConfig = BillFormArguments(
    serviceId: 'tuition',
    title: 'Thanh toán học phí',
    icon: Icons.school_rounded,
    providerName: 'Cổng thông tin Giáo dục SSC',
    customerCodeLabel: 'Mã học sinh / Mã sinh viên',
    customerCodeHint: 'VD: HS20261099',
    sampleCustomerCode: 'HS20261099',
    defaultPeriod: 'Học kỳ I (2026 - 2027)',
    defaultAmount: 1250000,
    instructions:
        'Nhập mã số học sinh/sinh viên được nhà trường cung cấp đầu năm học.',
  );

  /// Helper to get configuration by service ID
  static BillFormArguments getConfigForService(String serviceId) {
    switch (serviceId) {
      case 'electricity':
        return electricityConfig;
      case 'water':
        return waterConfig;
      case 'internet':
        return internetConfig;
      case 'tv':
        return tvConfig;
      case 'postpaid':
        return postpaidConfig;
      case 'tuition':
        return tuitionConfig;
      default:
        return electricityConfig;
    }
  }
}
