import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/services/category_service.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/custom_dropdown.dart';
import 'package:retreat/widgets/numeric_formfield.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/models/transaction.dart';

class UpdateTransactionTab extends StatefulWidget {

  const UpdateTransactionTab({Key? key, required this.isExpense, required this.initialTransaction})
      : super(key: key);

  final Transaction initialTransaction;
  final bool isExpense;

  @override
  State<UpdateTransactionTab> createState() => _UpdateTransactionTabState();
}

class _UpdateTransactionTabState
    extends AuthRequiredState<UpdateTransactionTab> {
  final _supabaseClient = TransactionService();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

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

  Future update() async {
    Category selectedCategory = categoryList[
        categoryList.indexWhere((element) => element.name == category)];
    categoryId = selectedCategory.id;
    await _supabaseClient.updateTransaction(context,
        id: widget.initialTransaction.id,
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
            int initialCategoryId = widget.initialTransaction.categoryId;
            Category selectedCategory = categoryList[
              categoryList.indexWhere((element) => element.id == initialCategoryId)];
            dropDownCategory = CustomDropdownButton(
              menuItems: categoryList.map((e) => e.name).toList(),
              title: "Category: ",
              hint: "Select a category",
              btnSelectedVal: selectedCategory.name,
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
    _notesController.text = widget.initialTransaction.notes;
    _amountController.text = widget.initialTransaction.amount.toString();
    selectedDate = DateTime.parse(widget.initialTransaction.timeTransaction);
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
                //initialValue: widget.initialTransaction.amount.toString(),
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
                //initialValue: widget.initialTransaction.notes,
              ),
              const SizedBox(height: 20.0),
              CustomButton(
                text: "Update",
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
                    await update()
                        .then((_) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Transaction updated'),
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
