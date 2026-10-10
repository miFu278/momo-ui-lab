import 'package:flutter/material.dart';
import '../data/mock_services.dart';
import '../models/service_item.dart';
import '../theme/app_theme.dart';

/// BillPaymentScreen displays categories of bill payment services (Electricity, Water, Internet, etc.)
/// and allows users to select a bill type to navigate to its form screen.
class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  String _searchQuery = '';

  List<ServiceItem> get _filteredCategories {
    if (_searchQuery.trim().isEmpty) {
      return MockServices.billCategories;
    }
    return MockServices.billCategories.where((cat) {
      return cat.label.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (cat.subtitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Thanh toán hóa đơn'),
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
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              children: [
                // Search Input Box
                _buildSearchField(),
                const SizedBox(height: AppTheme.spacingM),

                // Feature Highlights Banner
                _buildAutoPayBanner(),
                const SizedBox(height: AppTheme.spacingM),

                // Section Header
                Row(
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
                      'Chọn dịch vụ thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDefault,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingS),

                // Bill Services List
                ..._filteredCategories.map(_buildCategoryCard),

                // Empty state if search has no results
                if (_filteredCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingXL,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppTheme.placeholder,
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          'Không tìm thấy dịch vụ phù hợp với "$_searchQuery"',
                          style: const TextStyle(
                            color: AppTheme.textHint,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: AppTheme.spacingL),
                _buildSecurityFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm loại hóa đơn, nhà cung cấp...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppTheme.textHint,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppTheme.textHint,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingS + 2,
          ),
        ),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
      ),
    );
  }

  Widget _buildAutoPayBanner() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.infoLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXS),
            decoration: BoxDecoration(
              color: AppTheme.info.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppTheme.info,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhắc nợ tự động',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.info,
                  ),
                ),
                Text(
                  'MoMo tự động tra cứu & nhắc hẹn thanh toán định kỳ',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(ServiceItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Card(
        child: InkWell(
          onTap: () {
            if (item.route != null) {
              Navigator.pushNamed(context, item.route!);
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                // Icon with circular secondary background
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    item.icon,
                    color: AppTheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDefault,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textHint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing Chevron
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.placeholder,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityFooter() {
    return const Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 16,
            color: AppTheme.success,
          ),
          SizedBox(width: AppTheme.spacingXXS),
          Text(
            'Bảo mật thanh toán chuẩn quốc tế PCI-DSS',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
