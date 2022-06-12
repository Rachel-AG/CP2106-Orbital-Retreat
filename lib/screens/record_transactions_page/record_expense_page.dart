import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/services/category_service.dart';
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

class _RecordExpensePageState extends AuthRequiredState<RecordExpensePage> {
  final _supabaseClient = TransactionService();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<Category>? categoryList;

  String get notes => _notesController.text.trim();
  double get amount => double.parse(_amountController.text);
  String category = "No category selected";
  int categoryId = -1;
  DateTime selectedDate = DateTime.now();

  CustomDropdownButton dropDownCategory =
      CustomDropdownButton(menuItems: List.empty());

  Future record() async {
    Category selectedCategory = categoryList![
        categoryList!.indexWhere((element) => element.name == category)];
    categoryId = selectedCategory.id;
    await _supabaseClient.insertTransaction(context,
        amount: amount,
        notes: notes,
        categoryId: categoryId,
        timeTransaction: selectedDate,
        isExpense: true);
  }

  FutureBuilder<List<Category>> _dropDownCategoryBuilder() {
    return FutureBuilder<List<Category>>(
        future: CategoryService.getExpenseCategories(context),
        builder: (context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            categoryList = snapshot.data;
            dropDownCategory = CustomDropdownButton(
              menuItems: categoryList!.map((e) => e.name).toList(),
              title: "Category: ",
              hint: "Select a category",
            );
            return dropDownCategory;
          } else {
            return const LinearProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: const Text("Edit"),
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
              _dropDownCategoryBuilder(),
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
                  } else if (dropDownCategory.btnSelectedVal == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Select Category'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    category = dropDownCategory.btnSelectedVal!;
                    await record()
                        .then((_) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Expense recorded'),
                              duration: Duration(seconds: 2),
                            )))
                        .then((_) => Navigator.pushReplacementNamed(
                            context, '/home/transactionlist'));
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
