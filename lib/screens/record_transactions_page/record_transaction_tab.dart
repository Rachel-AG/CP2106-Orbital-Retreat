import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/services/category_service.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/custom_dropdown.dart';
import 'package:retreat/widgets/numeric_formfield.dart';
import 'package:retreat/widgets/custom_button.dart';

class RecordTransactionTab extends StatefulWidget {
  const RecordTransactionTab({Key? key, required this.isExpense})
      : super(key: key);

  final bool isExpense;

  @override
  State<RecordTransactionTab> createState() => _RecordTransactionTabState();
}

class _RecordTransactionTabState
    extends AuthRequiredState<RecordTransactionTab> {
  final _supabaseClient = TransactionService();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String get notes => _notesController.text.trim();
  double get amount => double.parse(_amountController.text);
  String category = "No category selected";
  int categoryId = -1;
  DateTime selectedDate = DateTime.now();

  late List<Category> categoryList;
  late CustomDropdownButton dropDownCategory;

  Future record() async {
    Category selectedCategory = categoryList[
        categoryList.indexWhere((element) => element.name == category)];
    categoryId = selectedCategory.id;
    await _supabaseClient.insertTransaction(context,
        amount: amount,
        notes: notes,
        categoryId: categoryId,
        timeTransaction: selectedDate,
        isExpense: widget.isExpense);
  }

  FutureBuilder<List<Category>> _dropDownCategoryBuilder() {
    return FutureBuilder<List<Category>>(
        future: widget.isExpense
            ? CategoryService.getExpenseCategories(context)
            : CategoryService.getIncomeCategories(context),
        builder: (context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // initialize category list
            categoryList = snapshot.data!;
            // initialize dropDownCategory
            dropDownCategory = CustomDropdownButton(
              menuItems: categoryList.map((e) => e.name).toList(),
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
  void initState() {
    super.initState();
    _dropDownCategoryBuilder();
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
                  const Text("Date of transaction:", style: TextStyles.optionTextStyle),
                  Text("${selectedDate.toLocal()}".split(' ')[0], style: TextStyles.optionTextStyle),
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
                              content: Text('Transaction recorded'),
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
