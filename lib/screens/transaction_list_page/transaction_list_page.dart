import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/models/auth_required_state.dart';
import 'package:retreat/screens/transaction_list_page/budget_history_tab.dart';
import 'package:retreat/screens/transaction_list_page/display_transactions_tab.dart';
import 'package:retreat/screens/transaction_list_page/overview_tab.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends AuthRequiredState<TransactionListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static final _nTabPages = <Widget>[
    const OverviewPage(),
    const DisplayTransactionsPage(),
    const BudgetHistoryPage(),
  ];

  static const _nTabs = <Tab>[
    Tab(
      icon: Icon(Icons.analytics_rounded),
      // text: 'Breakdown',
    ),
    Tab(
      icon: Icon(Icons.list_alt_rounded),
      // text: 'Transactions',
    ),
    Tab(
      icon: Icon(Icons.wallet_giftcard_rounded),
      // text: 'Budgets',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _nTabPages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _nTabPages,
      ),
      bottomNavigationBar: Material(
        color: AppColors.custom.shade800,
        child: TabBar(
          indicator: BoxDecoration(
            color: AppColors.custom.shade400,
          ),
          indicatorWeight: 12,
          tabs: _nTabs,
          controller: _tabController,
        ),
      ),
    );
  }
}
