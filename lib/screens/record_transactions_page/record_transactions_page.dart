import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/custom_dropdown.dart';
import 'package:retreat/widgets/numeric_formfield.dart';
import 'package:retreat/widgets/custom_button.dart';

class RecordTransactionsPage extends StatefulWidget {
  const RecordTransactionsPage({Key? key}) : super(key: key);

  @override
  State<RecordTransactionsPage> createState() => _RecordTransactionsPageState();
}

class _RecordTransactionsPageState
    extends AuthRequiredState<RecordTransactionsPage> {
  final _supabaseClient = TransactionService();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  //final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    //_categoryController.dispose();
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
    hint: "Select a category",);

  String get notes => _notesController.text.trim();
  double get amount => double.parse(_amountController.text);
  String get category => dropDownCategory.btnSelectedVal?? "No category";

  Future record() async {
                    await _supabaseClient.insertTransaction(context,
                        amount: amount, notes: notes, category: category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('record transactions'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              CustomFormField(
                labelText: 'Notes',
                controller: _notesController,
              ),
              const SizedBox(height: 20.0),
              NumericFormField(
                labelText: 'Amount',
                controller: _amountController,
              ),
              const SizedBox(height: 20.0),
              dropDownCategory,
              // CustomFormField(
              //   hintText: 'insert category',
              //   labelText: 'Category',
              //   controller: _categoryController,
              // ),
              const SizedBox(height: 20.0),
              CustomButton(
                  text: "Record",
                  onTap: () async {
                    if(_amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Insert amount'),
                      duration: Duration(seconds: 2),
                      )
                      );
                    } else {
                    await record();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Transaction recorded'),
                    duration: Duration(seconds: 2),
                    ));
                    Navigator.pushReplacementNamed(context, '/display');
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
