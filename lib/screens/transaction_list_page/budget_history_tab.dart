import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/budget.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/numeric_formfield.dart';

import '../../constants/app_colors.dart';
import '../../services/budget_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';

class BudgetHistoryPage extends StatefulWidget {
  const BudgetHistoryPage({Key? key}) : super(key: key); //??

  @override
  State<BudgetHistoryPage> createState() => _BudgetHistoryPageState();
}

class _BudgetHistoryPageState extends AuthRequiredState<BudgetHistoryPage> {
  final _supabaseClientBudget = BudgetService();
  final _supabaseClientTransaction = TransactionService();
  final TextEditingController _amountController = TextEditingController();
  double _sumExpense = 0;
  double _budget = 99999;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setBudget();
    setSumExpense();
    super.initState();
  }

  double get amount => double.parse(_amountController.text);

  Future record() async {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;
    await _supabaseClientBudget.insertBudget(context,
        amount: amount, month: selectedMonth, year: selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Budgets'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("Budget this month: \$ $_budget", style: TextStyles.optionTextStyle),
            ),
            CustomButton(
              text: "Insert Budget",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Set Your Budget This Month'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              NumericFormField(
                                  labelText: "Budget",
                                  hintText: "Insert amount",
                                  controller: _amountController),
                              CustomButton(
                                text: "Record",
                                onTap: () async {
                                  if (_amountController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Insert amount'),
                                      duration: Duration(seconds: 2),
                                    ));
                                  } else {
                                    await record()
                                        .then((_) =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text('Budget recorded'),
                                              duration: Duration(seconds: 2),
                                            )))
                                        .then((_) =>
                                            Navigator.pushReplacementNamed(
                                                context,
                                                '/home/transactionlist/budget'));
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
              },
            ),
            CustomCard(
              title: 'This Month',
              child: CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 20.0,
                animation: true,
                percent: computePercentageBudgetRemaining(),
                center: Text(
                  "${computePercentageBudgetRemaining()} %",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "You have \$ ${computeRemainingBudget()} left",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: AppColors.steelteal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setBudget() async {
    Budget budget = await _supabaseClientBudget.getBudgetMonthYear(context, DateTime.now().month, DateTime.now().year);
    setState(() {
      _budget = budget.amount;
    });
  }

  void setSumExpense() async {
    double sumExpense = await _supabaseClientTransaction.sumMonthTransactions(context, month: DateTime.now().month, year: DateTime.now().year, isExpense: true);
    setState(() {
      _sumExpense = sumExpense;
    });
  }

  double computePercentageBudgetRemaining() {
      return ((_budget - _sumExpense) / _budget);
    }
  
  double computeRemainingBudget() {
    return _budget - _sumExpense;
  }
}


  // FutureBuilder<Budget> CircularProgressIndicatorBuilder() {
  //   return FutureBuilder<Budget>(
  //       future: _supabaseClientBudget.getBudgetMonthYear(
  //           context, DateTime.now().month, DateTime.now().year),
  //       builder: (context, AsyncSnapshot<Budget> snapshot) {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.waiting:
  //             return const Text('Loading....');
  //           default:
  //             if (snapshot.hasError) {
  //               return Text('Error: ${snapshot.error}');
  //             } else {
  //               var budgetThisMonth = snapshot.data;
  //               return CircularPercentIndicator(
  //                 radius: 100.0,
  //                 lineWidth: 20.0,
  //                 animation: true,
  //                 percent: 0.7,
  //                 center: Text(
  //                   "70.0%",
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
  //                 ),
  //                 footer: Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Text(
  //                     "... used out of ...",
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold, fontSize: 17.0),
  //                   ),
  //                 ),
  //                 circularStrokeCap: CircularStrokeCap.round,
  //                 progressColor: AppColors.steelteal,
  //               );
  //             }
  //         }
  //       });
  // }

