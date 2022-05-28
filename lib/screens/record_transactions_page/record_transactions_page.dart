import 'package:flutter/material.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/dropdown_button.dart';

class RecordTransactionsPage extends StatefulWidget {
  const RecordTransactionsPage({Key? key}) : super(key: key);

  @override
  State<RecordTransactionsPage> createState() => _RecordTransactionsPageState();
}

class _RecordTransactionsPageState extends State<RecordTransactionsPage> {
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _timeController = TextEditingController();
  // final TextEditingController _categoryController = TextEditingController();
  //
  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _priceController.dispose();
  //   _timeController.dispose();
  //   _categoryController.dispose();
  //   super.dispose();
  // }
  //
  // String get name => _nameController.text.trim();
  // String get price => _priceController.text.trim();
  // String get time => _timeController.text.trim();
  // String get category => _categoryController.text.trim();

  String name = "";
  String price = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('record transactions'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Notes on the transactions',
                  ),
                  onChanged: (val) {
                    setState(() => name = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Amount',
                  ),
                  onChanged: (val) {
                    setState(() =>
                        price = val); //HOW TO CHANGE THIS STRING TO DOUBLE BZzZ
                  }),
              SizedBox(height: 20.0),
              DropdownButtonExample(),
              SizedBox(height: 20.0),
              RaisedButton(
                  child: Text('Record'),
                  onPressed: () async {
                    print(name);
                    print(price);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
