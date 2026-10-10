import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_services.dart';
import '../data/wallet_store.dart';
import '../models/service_item.dart';
import '../theme/app_theme.dart';

/// BillFormScreen is a reusable form screen used for both Electricity and Water bill payments
/// (as well as Internet, TV, etc.). It accepts configuration via constructor or ModalRoute arguments.
class BillFormScreen extends StatefulWidget {
  final BillFormArguments? initialService;

  const BillFormScreen({
    super.key,
    this.initialService,
  });

  @override
  State<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends State<BillFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _amountController;
  late String _selectedPeriod;

  final List<String> _periodOptions = [
    'Kỳ Tháng 10/2026',
    'Kỳ Tháng 09/2026',
    'Kỳ Tháng 08/2026',
  ];

  @override
  void initState() {
    super.initState();
    final defaultAmount = widget.initialService?.defaultAmount ?? 450000;
    _codeController = TextEditingController();
    _amountController = TextEditingController(text: defaultAmount.toString());
    _selectedPeriod =
        widget.initialService?.defaultPeriod ?? _periodOptions.first;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  BillFormArguments _resolveConfig(BuildContext context) {
    if (widget.initialService != null) {
      return widget.initialService!;
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is BillFormArguments) {
      return args;
    }
    return MockServices.electricityConfig;
  }

  void _fillSampleCode(BillFormArguments config) {
    setState(() {
      _codeController.text = config.sampleCustomerCode;
      _amountController.text = config.defaultAmount.toString();
    });
  }

  void _onPay(BillFormArguments config) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedAmount = int.tryParse(
          _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        config.defaultAmount;

    // Số dư hiển thị trên hoá đơn là số dư trước khi trừ.
    final paymentSource =
        'Ví MoMo (Số dư: ${AppTheme.formatCurrency(WalletStore.balance.value)} đ)';

    // Trừ tiền + bỏ hoá đơn khỏi danh sách chờ; store tự chặn nếu không đủ số dư.
    if (!WalletStore.pay(
      serviceId: config.serviceId,
      amount: parsedAmount,
    )) {
      return;
    }

    // Generate simulated transaction ID
    final randomSuffix = (1000 + Random().nextInt(9000)).toString();
    final transactionId = 'MOM20261010-$randomSuffix';

    final resultArgs = PaymentResultArguments(
      serviceId: config.serviceId,
      serviceName: config.title,
      serviceIcon: config.icon,
      providerName: config.providerName,
      customerCode: _codeController.text.trim().toUpperCase(),
      period: _selectedPeriod,
      amount: parsedAmount,
      transactionId: transactionId,
      timestamp: DateTime.now(),
      paymentSource: paymentSource,
    );

    Navigator.pushNamed(
      context,
      '/result',
      arguments: resultArgs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _resolveConfig(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(config.title),
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Provider info card
                          _buildProviderCard(config),
                          const SizedBox(height: AppTheme.spacingM),

                          // Customer Code input card
                          _buildCustomerCodeCard(config),
                          const SizedBox(height: AppTheme.spacingM),

                          // Period and Amount card
                          _buildPeriodAndAmountCard(config),
                          const SizedBox(height: AppTheme.spacingM),

                          // Payment Source card
                          _buildPaymentSourceCard(),
                          const SizedBox(height: AppTheme.spacingL),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom sticky checkout bar
                _buildBottomCheckoutBar(config),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderCard(BillFormArguments config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(
                config.icon,
                color: AppTheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.providerName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDefault,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXXS),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: const Text(
                          'Đối tác chính thức',
                          style: TextStyle(
                            color: AppTheme.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingXS),
                      const Text(
                        'Miễn phí dịch vụ',
                        style: TextStyle(
                          color: AppTheme.textHint,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCodeCard(BillFormArguments config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  config.customerCodeLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDefault,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _fillSampleCode(config),
                  icon: const Icon(
                    Icons.auto_fix_high_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  label: const Text(
                    'Điền mã mẫu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXS),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: config.customerCodeHint,
                prefixIcon: const Icon(
                  Icons.tag_rounded,
                  color: AppTheme.textHint,
                ),
                suffixIcon: _codeController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppTheme.textHint,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _codeController.clear();
                          });
                        },
                      )
                    : null,
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập ${config.customerCodeLabel.toLowerCase()}';
                }
                if (value.trim().length < 5) {
                  return 'Mã khách hàng phải có tối thiểu 5 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingS),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.textHint,
                ),
                const SizedBox(width: AppTheme.spacingXXS),
                Expanded(
                  child: Text(
                    config.instructions,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHint,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodAndAmountCard(BillFormArguments config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Billing period selector
            const Text(
              'Kỳ hóa đơn',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDefault,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            DropdownButtonFormField<String>(
              initialValue: _selectedPeriod,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.calendar_today_rounded,
                  color: AppTheme.textHint,
                ),
              ),
              items: _periodOptions.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(period),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedPeriod = val;
                  });
                }
              },
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Amount field
            const Text(
              'Số tiền thanh toán',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDefault,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.payments_outlined,
                  color: AppTheme.textHint,
                ),
                suffixText: 'đ',
                suffixStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập số tiền thanh toán';
                }
                final num = int.tryParse(value);
                if (num == null || num <= 0) {
                  return 'Số tiền thanh toán phải lớn hơn 0';
                }
                if (num > WalletStore.balance.value) {
                  return 'Số dư ví không đủ (còn ${AppTheme.formatCurrency(WalletStore.balance.value)} đ)';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppTheme.spacingS),

            // Quick amount recommendation chips
            Wrap(
              spacing: AppTheme.spacingXS,
              children: [100000, 200000, 450000, 1000000].map((quickAmount) {
                return ActionChip(
                  label: Text(
                    AppTheme.formatCurrency(quickAmount),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: AppTheme.white,
                  side: const BorderSide(color: AppTheme.border),
                  onPressed: () {
                    setState(() {
                      _amountController.text = quickAmount.toString();
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSourceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nguồn tiền: Ví MoMo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDefault,
                    ),
                  ),
                  const SizedBox(height: 2),
                  ValueListenableBuilder<int>(
                    valueListenable: WalletStore.balance,
                    builder: (context, balance, _) {
                      return Text(
                        'Số dư khả dụng: ${AppTheme.formatCurrency(balance)} đ',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHint,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCheckoutBar(BillFormArguments config) {
    final currentAmount = int.tryParse(_amountController.text) ?? 0;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: const Border(top: BorderSide(color: AppTheme.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng thanh toán:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                AppTheme.formatCurrency(currentAmount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          ElevatedButton(
            onPressed: () => _onPay(config),
            child: const Text('Thanh toán'),
          ),
        ],
      ),
    );
  }
}
