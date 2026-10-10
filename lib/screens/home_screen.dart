import 'package:flutter/material.dart';
import '../data/mock_services.dart';
import '../data/wallet_store.dart';
import '../models/service_item.dart';
import '../theme/app_theme.dart';

/// HomeScreen serves as the primary dashboard displaying wallet balance,
/// search bar, quick actions, responsive services grid, and pending bill reminders.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppTheme.maxContentWidth,
                ),
                child: CustomScrollView(
                  slivers: [
                    // Top App Bar & Header
                    SliverToBoxAdapter(
                      child: _buildHeader(),
                    ),

                    // Wallet Card with Quick Action Buttons
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingS,
                        ),
                        child: _buildWalletCard(),
                      ),
                    ),

                    // Promotional / Feature Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingXS,
                        ),
                        child: _buildPromoBanner(),
                      ),
                    ),

                    // Services Grid Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppTheme.spacingM,
                          AppTheme.spacingM,
                          AppTheme.spacingM,
                          AppTheme.spacingS,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingXS),
                            const Text(
                              'Dịch vụ tiện ích MoMo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDefault,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Services Grid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                      ),
                      sliver: _buildServicesGrid(),
                    ),

                    // Pending Bills Preview Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        child: _buildPendingBillsSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppTheme.spacingL),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds top header with search and profile info
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingM,
        AppTheme.spacingM,
        AppTheme.spacingM,
        AppTheme.spacingL,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppTheme.radiusLarge),
          bottomRight: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      child: Column(
        children: [
          // Greeting & Icons
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.white.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppTheme.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào,',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Nguyễn Văn A',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không có thông báo mới')),
                  );
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),

          // Search Box
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Row(
              children: [
                const SizedBox(width: AppTheme.spacingM),
                const Icon(
                  Icons.search_rounded,
                  color: AppTheme.textHint,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm dịch vụ, tiền điện, nước...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                    ),
                    style: const TextStyle(fontSize: 14),
                    onSubmitted: (value) {
                      if (value.toLowerCase().contains('điện') ||
                          value.toLowerCase().contains('nước') ||
                          value.toLowerCase().contains('hóa đơn')) {
                        Navigator.pushNamed(context, '/bill-payment');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds wallet card showing balance and 4 quick actions
  Widget _buildWalletCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Balance Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingXS),
                    const Flexible(
                      child: Text(
                        'Số dư ví MoMo',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingXS),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      child: Icon(
                        _isBalanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Text(
                  'Tài khoản chuẩn',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Align(
            alignment: Alignment.centerLeft,
            child: ValueListenableBuilder<int>(
              valueListenable: WalletStore.balance,
              builder: (context, balance, _) {
                return Text(
                  _isBalanceVisible
                      ? AppTheme.formatCurrency(balance)
                      : '******** đ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDefault,
                  ),
                );
              },
            ),
          ),
          const Divider(height: AppTheme.spacingL),

          // 4 Quick action buttons
          Row(
            children: [
              Expanded(
                child: _buildWalletAction(
                  icon: Icons.add_circle_outline_rounded,
                  label: 'Nạp tiền',
                ),
              ),
              Expanded(
                child: _buildWalletAction(
                  icon: Icons.arrow_circle_up_rounded,
                  label: 'Rút tiền',
                ),
              ),
              Expanded(
                child: _buildWalletAction(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Quét mã',
                ),
              ),
              Expanded(
                child: _buildWalletAction(
                  icon: Icons.qr_code_2_rounded,
                  label: 'Nhận tiền',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAction({
    required IconData icon,
    required String label,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tính năng $label đang được mô phỏng')),
        );
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: AppTheme.spacingXXS,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primary, size: 22),
            ),
            const SizedBox(height: AppTheme.spacingXXS),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Promotional banner for bill payments
  Widget _buildPromoBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.secondary.withValues(alpha: 0.8),
            AppTheme.white,
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.secondary),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXS),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppTheme.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ưu đãi thanh toán hóa đơn',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  'Giảm đến 50.000đ khi thanh toán Điện, Nước',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textHint,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/bill-payment'),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingS,
                vertical: AppTheme.spacingXXS,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: const Text(
                'Xem ngay',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds responsive 4-column service grid
  Widget _buildServicesGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppTheme.spacingM,
        crossAxisSpacing: AppTheme.spacingXS,
        childAspectRatio: 0.85,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final service = MockServices.homeServices[index];
          return _buildServiceItem(service);
        },
        childCount: MockServices.homeServices.length,
      ),
    );
  }

  Widget _buildServiceItem(ServiceItem service) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (service.route != null) {
            Navigator.pushNamed(context, service.route!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Dịch vụ "${service.label.replaceAll('\n', ' ')}" đang phát triển',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Icon(
                    service.icon,
                    color: AppTheme.primary,
                    size: 28,
                  ),
                ),
                if (service.badgeText != null)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        service.badgeText!,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              service.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDefault,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pending bills quick-pay section
  Widget _buildPendingBillsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hóa đơn chưa thanh toán',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDefault,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/bill-payment'),
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),

          // Danh sách hóa đơn lấy từ WalletStore: thanh toán xong sẽ tự biến mất
          ValueListenableBuilder<List<PendingBill>>(
            valueListenable: WalletStore.pendingBills,
            builder: (context, bills, _) {
              if (bills.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                  child: Text(
                    'Không có hóa đơn chưa thanh toán',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textHint,
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  for (int i = 0; i < bills.length; i++) ...[
                    if (i > 0) const Divider(height: AppTheme.spacingL),
                    _buildQuickBillRow(bills[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBillRow(PendingBill bill) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(bill.icon, color: AppTheme.primary, size: 22),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bill.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDefault,
                ),
              ),
              Text(
                'Mã: ${bill.customerCode}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textHint,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppTheme.formatCurrency(bill.amount),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXXS),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/bill-payment/${bill.serviceId}',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 28),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
              ),
              child: const Text(
                'Thanh toán',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
