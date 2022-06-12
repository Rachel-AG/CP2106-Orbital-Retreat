import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/custom_dropdown.dart';
import 'package:retreat/widgets/numeric_formfield.dart';
import 'package:retreat/widgets/custom_button.dart';

class RecordExpensePage extends StatefulWidget {
  const RecordExpensePage({Key? key}) : super(key: key);

  @override
  State<RecordExpensePage> createState() => _RecordExpensePageState();
}

class _RecordExpensePageState
    extends AuthRequiredState<RecordExpensePage> {
  final _supabaseClient = TransactionService();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  static const menuItems = <String>[
    'Education',
    'Entertainment',
    'Food & Drink',
    'Groceries',
    'Health',
    'Housing',
    'Tax',
    'Transportation',
    'Utilities',
    'Work',
    'Others',
  ];
  CustomDropdownButton dropDownCategory = CustomDropdownButton(
    menuItems: menuItems,
    title: "Category: ",
    hint: "Select a category",
  );

  String get notes => _notesController.text.trim();
  double get amount => double.parse(_amountController.text);
  String get category => dropDownCategory.btnSelectedVal ?? "No category";
  DateTime selectedDate = DateTime.now();

  Future record() async {
    await _supabaseClient.insertTransaction(context,
        amount: amount, notes: notes, category: category, 
        timeTransaction: selectedDate, isExpense: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Record Transactions'),
      //   centerTitle: true,
      // ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              NumericFormField(
                labelText: 'Amount',
                controller: _amountController,
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text("Date of transaction: "),
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ElevatedButton(
                    child: 
                    const Text("Edit"),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate, 
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                      );
                      if (picked != null && picked != selectedDate) {
                         setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              dropDownCategory,
              const SizedBox(height: 20.0),
              CustomFormField(
                labelText: 'Notes',
                controller: _notesController,
              ),
              const SizedBox(height: 20.0),
              CustomButton(
                text: "Record",
                onTap: () async {
                  if (_amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Insert amount'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    await record();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Expense recorded'),
                      duration: Duration(seconds: 2),
                    ));

                    Navigator.pushReplacementNamed(
                        context, '/home/transactionlist');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
