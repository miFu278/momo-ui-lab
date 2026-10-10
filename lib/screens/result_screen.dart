import 'package:flutter/material.dart';
import '../models/service_item.dart';
import '../theme/app_theme.dart';

/// ResultScreen displays the receipt and confirmation for a successful bill payment transaction.
class ResultScreen extends StatelessWidget {
  final PaymentResultArguments? initialResult;

  const ResultScreen({
    super.key,
    this.initialResult,
  });

  PaymentResultArguments _resolveResult(BuildContext context) {
    if (initialResult != null) {
      return initialResult!;
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is PaymentResultArguments) {
      return args;
    }
    // Fallback demo transaction if navigated directly
    return PaymentResultArguments(
      serviceId: 'electricity',
      serviceName: 'Hóa đơn tiền điện',
      serviceIcon: Icons.bolt_rounded,
      providerName: 'EVN - Tập đoàn Điện lực Việt Nam',
      customerCode: 'PE01000123456',
      period: 'Kỳ Tháng 10/2026',
      amount: 450000,
      transactionId: 'MOM20261010-9842',
      timestamp: DateTime.now(),
    );
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final result = _resolveResult(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Kết quả giao dịch'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Quay lại',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppTheme.maxContentWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                children: [
                  // Success Status Card
                  _buildSuccessCard(result),
                  const SizedBox(height: AppTheme.spacingM),

                  // Transaction Detail Card
                  _buildReceiptCard(result),
                  const SizedBox(height: AppTheme.spacingM),

                  // Security & Info Notice Card
                  _buildInfoNotice(),
                  const SizedBox(height: AppTheme.spacingL),

                  // Action Buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/'),
                      );
                    },
                    child: const Text('Về trang chủ'),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Thực hiện giao dịch khác'),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard(PaymentResultArguments result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 48,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            const Text(
              'Thanh toán thành công!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDefault,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXXS),
            Text(
              'Giao dịch được xử lý và ghi nhận tức thì',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textHint,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              AppTheme.formatCurrency(result.amount),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptCard(PaymentResultArguments result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    result.serviceIcon,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    result.serviceName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDefault,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: AppTheme.spacingL),
            _buildReceiptRow('Đơn vị thụ hưởng', result.providerName),
            _buildReceiptRow('Mã khách hàng', result.customerCode),
            _buildReceiptRow('Kỳ hóa đơn', result.period),
            _buildReceiptRow(
              'Số tiền',
              AppTheme.formatCurrency(result.amount),
              isHighlighted: true,
            ),
            _buildReceiptRow('Phí giao dịch', 'Miễn phí (0 đ)'),
            _buildReceiptRow('Nguồn tiền', result.paymentSource),
            _buildReceiptRow('Mã giao dịch', result.transactionId),
            _buildReceiptRow('Thời gian', _formatDateTime(result.timestamp)),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXXS + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textHint,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                color: isHighlighted ? AppTheme.primary : AppTheme.textDefault,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNotice() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.infoLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.info.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.receipt_outlined,
            color: AppTheme.info,
            size: 20,
          ),
          SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              'Hóa đơn điện tử sẽ được lưu tự động trong Lịch sử giao dịch MoMo.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
