import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/models/month.dart';
import 'package:retreat/models/transaction.dart';
import 'package:retreat/notifiers/category_list_change_notifier.dart';
import 'package:retreat/notifiers/transaction_list_change_notifier.dart';
import 'package:retreat/widgets/custom_card.dart';
import 'package:retreat/widgets/custom_dropdown.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key); //??

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends AuthRequiredState<OverviewPage> {
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  // TODO: show earliest year
  static final List<String> _yearString =
      List<int>.generate(10, (index) => DateTime.now().year - index)
          .map((e) => e.toString())
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
        centerTitle: true,
      ),
      body:
          ListView(shrinkWrap: true, scrollDirection: Axis.vertical, children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              monthYearPopUpButton(),
              Text(
                '${Month.fromIntToString(month)}, $year',
                style: TextStyles.optionTextStyle,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
          child: CustomCard(
              title: 'Monthly Cash Flow',
              child: Consumer<TransactionListChangeNotifier>(
                builder: (context, value, child) {
                  List<double> expenseList = _calcTransactionSumPerMonth(
                      value.allTransactionList, true);
                  List<double> incomeList = _calcTransactionSumPerMonth(
                      value.allTransactionList, false);
                  return customBarChart(expenseList, incomeList);
                },
              )),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
          child: CustomCard(
            title: 'Outflow',
            child: Consumer2<TransactionListChangeNotifier,
                CategoryListChangeNotifier>(
              builder: (context, value, value2, child) {
                List<Transaction> expenseList =
                    _validTransactions(value.allTransactionList, true);
                List<Category> expenseCatList = value2.expenseCatList;
                if (expenseCatList.isEmpty) {
                  return const CircularProgressIndicator();
                }
                Map<Category, double> expenseBreakdownByCat =
                    _breakDownByCategory(expenseCatList, expenseList);
                return customPieChart(expenseBreakdownByCat, 'expense-chart');
              },
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 12.0, bottom: 24.0),
          child: CustomCard(
            title: 'Inflow',
            child: Consumer2<TransactionListChangeNotifier,
                CategoryListChangeNotifier>(
              builder: (context, value, value2, child) {
                List<Transaction> incomeList =
                    _validTransactions(value.allTransactionList, false);
                List<Category> incomeCatList = value2.incomeCatList;
                if (incomeCatList.isEmpty) {
                  return const CircularProgressIndicator();
                }
                Map<Category, double> incomeBreakdownByCat =
                    _breakDownByCategory(incomeCatList, incomeList);
                return customPieChart(incomeBreakdownByCat, 'income-chart');
              },
            ),
          ),
        )
      ]),
    );
  }

  IconButton monthYearPopUpButton() {
    CustomDropdownButton selectMonth = CustomDropdownButton(
      menuItems: Month.monthString,
      title: "Month",
    );
    CustomDropdownButton selectYear = CustomDropdownButton(
      menuItems: _yearString,
      title: "Year",
    );
    return IconButton(
        icon: const Icon(
          Icons.calendar_month,
          color: AppColors.custom,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Select Timeline"),
              actions: <Widget>[
                selectMonth,
                selectYear,
                TextButton(
                  onPressed: () {
                    if (selectMonth.btnSelectedVal == null ||
                        selectYear.btnSelectedVal == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Insert details'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      setState(() {
                        month =
                            Month.fromStringtoInt(selectMonth.btnSelectedVal!);
                        year = int.parse(selectYear.btnSelectedVal!);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Ok"),
                ),
              ],
            ),
          );
        });
  }

  //------------------
  // PIE CHART METHODS
  //------------------

  List<Widget> pieChartLegend(Map<Category, double> breakdownByCategoryData) {
    final categories = breakdownByCategoryData.keys.toList();
    final amount = breakdownByCategoryData.values.toList();
    final totalAmount = amount.reduce((value, element) => value + element);
    return List.generate(
        categories.length,
        (index) => Column(
              children: [
                index == 0
                    ? const SizedBox(
                        height: 24.0,
                      )
                    : const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16.0,
                          height: 16.0,
                          color: Colors.primaries[index],
                        ),
                        const SizedBox(width: 8.0),
                        Text(categories[index].name),
                      ],
                    ),
                    Row(
                      children: [
                        Text('\$${amount[index]}'),
                        Text(
                          ' (${(amount[index] / totalAmount * 100).round()}%)',
                          style: TextStyles.percentage,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ));
  }

  PieChartData pieChartMainData(Map<Category, double> breakdownByCategoryData) {
    final List<double> amountList = breakdownByCategoryData.values.toList();

    return PieChartData(
      sections: List.generate(breakdownByCategoryData.length, (index) {
        return PieChartSectionData(
          color: Colors.primaries[index],
          value: amountList[index],
          showTitle: false,
          radius: 60.0,
        );
      }),
      centerSpaceRadius: double.infinity,
      sectionsSpace: 2.0,
      borderData: FlBorderData(show: false),
    );
  }

  Widget customPieChart(Map<Category, double> breakdownByCategory, String key) {
    if (breakdownByCategory.values.fold(
        true, (previousValue, element) => previousValue && element == 0.0)) {
      return const Text(
        'No Transactions Recorded',
      );
    }
    return Column(
      children: [
        Padding(
          key: ValueKey(key),
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(pieChartMainData(breakdownByCategory))),
        ),
        ...pieChartLegend(breakdownByCategory),
      ],
    );
  }

  Map<Category, double> _breakDownByCategory(
      List<Category> catList, List<Transaction> transactionList) {
    final amountList = List<double>.filled(catList.length, 0.0);
    for (var element in transactionList) {
      int index =
          catList.indexWhere((category) => category.id == element.categoryId);
      amountList[index] += element.amount;
    }
    var result = Map.fromIterables(
        catList, amountList.map((e) => double.parse((e).toStringAsFixed(2))));
    result.removeWhere((key, value) => value == 0.0);
    return result;
  }

  List<Transaction> _validTransactions(
      List<Transaction> allTransactionList, bool isExpense) {
    return allTransactionList.where((transaction) {
      final time = DateTime.parse(transaction.timeTransaction);
      return transaction.isExpense == isExpense &&
          time.year == year &&
          time.month == month;
    }).toList();
  }

  //------------------
  // BAR CHART METHODS
  //------------------
  List<BarChartGroupData> barChartGroupMainData(
      List<double> totalExpenseList, List<double> totalIncomeList) {
    return List.generate(
        totalExpenseList.length,
        (index) => BarChartGroupData(x: index, barsSpace: 4.0, barRods: [
              BarChartRodData(
                  toY: totalExpenseList[index],
                  color: AppColors.red,
                  width: 6.0),
              BarChartRodData(
                  toY: totalIncomeList[index],
                  color: AppColors.green,
                  width: 6.0)
            ]));
  }

  BarChartData barChartMainData(List<BarChartGroupData> listOfGroupData) {
    // TODO: finish titlesData
    return BarChartData(
      barGroups: listOfGroupData,
      alignment: BarChartAlignment.center,
      groupsSpace: 10.0,
      baselineY: 0.0,
      titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  reservedSize: 56.0,
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 16,
                      child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                              Month.fromIntToStringShorten(value.toInt() + 1))),
                    );
                  }))),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
    );
  }

  Widget customBarChart(List<double> expenseList, List<double> incomeList) {
    if (expenseList.where((element) => element != 0.0).isEmpty &&
        incomeList.where((element) => element != 0.0).isEmpty) {
      return const Text(
        'No Transactions Recorded',
      );
    }
    return SizedBox(
      height: 240.0,
      width: 500.0,
      child: BarChart(
          key: const ValueKey('bar-chart'),
          barChartMainData(barChartGroupMainData(expenseList, incomeList))),
    );
  }

  List<double> _calcTransactionSumPerMonth(
      List<Transaction> allTransactionList, bool isExpense) {
    final result = List<double>.filled(12, 0.0);
    final validList = allTransactionList
        .where((transaction) => transaction.isExpense == isExpense);
    for (Transaction transaction in validList) {
      final time = DateTime.parse(transaction.timeTransaction);
      if (time.year == year) {
        result[time.month - 1] += transaction.amount;
      }
    }
    return result;
  }
}
