import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/budget.dart';
import 'package:retreat/models/transaction.dart';
import 'package:retreat/notifiers/budget_list_change_notifier.dart';
import 'package:retreat/notifiers/transaction_list_change_notifier.dart';
import 'package:retreat/widgets/numeric_formfield.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';

class BudgetHistoryPage extends StatefulWidget {
  const BudgetHistoryPage({Key? key}) : super(key: key);

  @override
  State<BudgetHistoryPage> createState() => _BudgetHistoryPageState();
}

class _BudgetHistoryPageState extends AuthRequiredState<BudgetHistoryPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get amount => double.parse(_amountController.text);

  @override
  Widget build(BuildContext context) {
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Budget'),
        centerTitle: true,
      ),
      body: Consumer2<BudgetListChangeNotifier, TransactionListChangeNotifier>(
          builder: ((context, value, value2, child) {
        if (!value.isUpToDate) {
          value.budgetList;
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            ],
          );
        }
        if (!value2.isUpToDate) {
          value2.allTransactionList;
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            ],
          );
        }

        if (value.budgetList.isEmpty) {
          return noBudget();
        }

        Budget mostRecent = value.budgetList[0];
        if (mostRecent.year != currentYear ||
            mostRecent.month != currentMonth) {
          return noBudget();
        }

        double totalExpense = _validTransactions(
                value2.allTransactionList, currentYear, currentMonth)
            .fold(0.0,
                (previousValue, element) => previousValue + element.amount);
        return updateBudget(mostRecent, totalExpense);
      })),
    );
  }

  Widget noBudget() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No recorded budget for this month",
                    style: TextStyles.optionTextStyle),
              ),
              insertBudgetButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget updateBudget(Budget currentBudget, double totalExpense) {
    //user alr set budget
    double budgetAmount = currentBudget.amount;
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Budget this month: \$ $budgetAmount",
                    style: TextStyles.optionTextStyle),
              ),
              updateBudgetButton(currentBudget),
              CustomCard(
                title: 'Budget Overview',
                child: remainingBudgetChart(totalExpense, budgetAmount),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Transaction> _validTransactions(
      List<Transaction> allTransactionList, int year, int month) {
    return allTransactionList.where((transaction) {
      final time = DateTime.parse(transaction.timeTransaction);
      return transaction.isExpense && time.year == year && time.month == month;
    }).toList();
  }

  CustomButton updateBudgetButton(Budget budget) {
    return CustomButton(
        key: const ValueKey('update-button'),
        text: "Update Budget",
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: const Text('Set Your Budget This Month'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        NumericFormField(
                            key: const ValueKey('update-field'),
                            labelText: "Budget",
                            hintText: "Insert amount",
                            controller: _amountController),
                        CustomButton(
                          key: const ValueKey('update-budget-button'),
                          text: "Update",
                          onTap: () async {
                            if (_amountController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Insert budget'),
                                duration: Duration(seconds: 2),
                              ));
                            } else {
                              Dialog alert = Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "WARNING! Updating your budget now would reset the current COINS multiplier. Do you want to proceed?",
                                        softWrap: true,
                                      ),
                                    ),
                                    TextButton(
                                      key: const ValueKey('yes-button'),
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        String id = budget.id;
                                        //TODO: reset multiplier here
                                        int selectedMonth =
                                            DateTime.now().month;
                                        int selectedYear = DateTime.now().year;
                                        Provider.of<BudgetListChangeNotifier>(
                                                context,
                                                listen: false)
                                            .updateBudget(
                                                id: id,
                                                amount: amount,
                                                month: selectedMonth,
                                                year: selectedYear);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Budget updated'),
                                          duration: Duration(seconds: 2),
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              );
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  CustomButton insertBudgetButton() {
    return CustomButton(
        key: const ValueKey('insert-button'),
        text: "Insert Budget",
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: const Text('Set Your Budget This Month'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        NumericFormField(
                            key: const ValueKey('insert-field'),
                            labelText: "Budget",
                            hintText: "Insert amount",
                            controller: _amountController),
                        CustomButton(
                          key: const ValueKey('record-budget-button'),
                          text: "Record",
                          onTap: () async {
                            if (_amountController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Insert budget'),
                                duration: Duration(seconds: 2),
                              ));
                            } else {
                              int selectedMonth = DateTime.now().month;
                              int selectedYear = DateTime.now().year;
                              Provider.of<BudgetListChangeNotifier>(context,
                                      listen: false)
                                  .insertBudget(
                                      amount: amount,
                                      month: selectedMonth,
                                      year: selectedYear);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Budget recorded'),
                                duration: Duration(seconds: 2),
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  CircularPercentIndicator remainingBudgetChart(
      double sumExpense, double budgetThisMonth) {
    double remainingBudget = budgetThisMonth - sumExpense;
    double percentBudgetRemaining = remainingBudget / budgetThisMonth;
    String percentBudgetRemainingString =
        "${(percentBudgetRemaining * 100).toStringAsFixed(2)}%";
    return CircularPercentIndicator(
      key: const ValueKey('budget-chart'),
      radius: 100.0,
      lineWidth: 20.0,
      animation: true,
      percent: percentBudgetRemaining.abs() >= 1
          ? 1.0
          : percentBudgetRemaining.abs(),
      center: Text(
        percentBudgetRemainingString,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          remainingBudget >= 0
              ? "Remaining Budget: \$${remainingBudget.abs().toStringAsFixed(2)}"
              : "Exceed Budget: \$${remainingBudget.abs().toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: remainingBudget >= 0 ? AppColors.green : AppColors.red,
    );
  }
}
