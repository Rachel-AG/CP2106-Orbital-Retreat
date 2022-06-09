import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/screens/transaction_list_pages/display_transactions_page.dart';
import 'package:retreat/screens/transaction_list_pages/transaction_breakdown_page.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends AuthRequiredState<TransactionListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _nTabPages = <Widget>[
    DisplayTransactionsPage(),
    TransactionBreakdownPage(),
  ];

  static const _nTabs = <Tab>[
    Tab(
      height: 48,
      icon: Icon(Icons.analytics_rounded),
      //text: 'Breakdown',
    ),
    Tab(
      height: 48,
      icon: Icon(Icons.list_alt_rounded),
      //text: 'Transactions History',
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
        color: AppColors.darkblue,
        child: TabBar(
          indicator: const BoxDecoration(
            color: AppColors.steelteal,
          ),
          indicatorWeight: 10,
          tabs: _nTabs,
          controller: _tabController,
        ),
      ),
    );
  }
}
