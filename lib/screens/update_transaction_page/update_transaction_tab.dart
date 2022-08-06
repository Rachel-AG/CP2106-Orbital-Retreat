import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/models/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/notifiers/category_list_change_notifier.dart';
import 'package:retreat/notifiers/transaction_list_change_notifier.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/custom_dropdown.dart';
import 'package:retreat/widgets/numeric_formfield.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/models/transaction.dart';

class UpdateTransactionTab extends StatefulWidget {
  const UpdateTransactionTab(
      {Key? key, required this.isExpense, required this.initialTransaction})
      : super(key: key);

  final Transaction initialTransaction;
  final bool isExpense;

  @override
  State<UpdateTransactionTab> createState() => _UpdateTransactionTabState();
}

class _UpdateTransactionTabState
    extends AuthRequiredState<UpdateTransactionTab> {
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

  late CustomDropdownButton dropdownButton;

  Widget dropDownCategory(List<Category> categoryList) {
    if (categoryList.isEmpty) return const LinearProgressIndicator();

    dropdownButton = CustomDropdownButton(
      key: const ValueKey('category-dropdown'),
      menuItems: categoryList.map((e) => e.name).toList(),
      title: "Category: ",
      hint: "Select a category",
    );
    return dropdownButton;
  }

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.initialTransaction.notes;
    _amountController.text = widget.initialTransaction.amount.toString();
    selectedDate = DateTime.parse(widget.initialTransaction.timeTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        const Text("Date: ", style: TextStyles.optionTextStyle),
                        Text("${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyles.optionTextStyle),
                      ],
                    ),
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
                Consumer<CategoryListChangeNotifier>(
                    builder: ((context, value, child) {
                  if (widget.isExpense) {
                    final expenseDropDown =
                        dropDownCategory(value.expenseCatList);
                    return expenseDropDown;
                  }
                  final incomeDropDown = dropDownCategory(value.incomeCatList);
                  return incomeDropDown;
                })),
                const SizedBox(height: 20.0),
                CustomFormField(
                  key: const ValueKey('notes-field'),
                  labelText: 'Notes',
                  controller: _notesController,
                  //initialValue: widget.initialTransaction.notes,
                ),
                const SizedBox(height: 20.0),
                updateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomButton updateButton() {
    return CustomButton(
      key: const ValueKey('update-button'),
      text: "Update",
      onTap: () async {
        if (_amountController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Insert amount'),
            duration: Duration(seconds: 2),
          ));
        } else if (dropdownButton.btnSelectedVal == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Select Category'),
            duration: Duration(seconds: 2),
          ));
        } else {
          category = dropdownButton.btnSelectedVal!;
          List<Category> categoryList = widget.isExpense
              ? Provider.of<CategoryListChangeNotifier>(context, listen: false)
                  .expenseCatList
              : Provider.of<CategoryListChangeNotifier>(context, listen: false)
                  .incomeCatList;
          Category selectedCategory = categoryList[
              categoryList.indexWhere((element) => element.name == category)];
          categoryId = selectedCategory.id;

          Provider.of<TransactionListChangeNotifier>(context, listen: false)
              .updateTransaction(
                  id: widget.initialTransaction.id,
                  amount: amount,
                  notes: notes,
                  categoryId: categoryId,
                  timeTransaction: selectedDate,
                  isExpense: widget.isExpense);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Transaction updated'),
            duration: Duration(seconds: 2),
          ));
          Navigator.pop(context);
        }
      },
    );
  }
}
