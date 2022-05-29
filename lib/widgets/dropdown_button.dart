import 'package:flutter/material.dart';

// Inspired by dropdown buttons demo in offical flutter gallery:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/buttons_demo.dart
class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  
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
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String? _btn2SelectedVal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Categories:'),
          trailing: DropdownButton(
            value: _btn2SelectedVal,
            hint: const Text('Choose'),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _btn2SelectedVal = newValue);
              }
            },
            items: _dropDownMenuItems,
          ),
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';


// // Inspired by dropdown buttons demo in offical flutter gallery:
// // https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/buttons_demo.dart

// class DropdownButton extends StatefulWidget {
//   final List<String> menuItems;
//   final TextEditingController controller;

//   const DropdownButton(
//     {Key? key,
//     required this.menuItems, 
//     required this.controller});

//     @override
//   State<DropdownButton> createState() => _DropdownButton();
// }
  

//   // static const menuItems = <String>[ //?? HOW TO DO THE LINKING TO SUPABASE FOR THE CATEGORY
//   //   'Education',
//   //   'Entertainment',
//   //   'Food & Drink',
//   //   'Groceries',
//   //   'Health',
//   //   'Housing',
//   //   'Tax',
//   //   'Transportation',
//   //   'Utilities',
//   //   'Work',
//   //   'Others',
//   // ];

// class _DropdownButton extends State<DropdownButton> {

//   final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
//       .map(
//         (String value) => DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         ),
//       )
//       .toList();


//   String? _btn2SelectedVal;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         ListTile(
//           title: const Text('Categories:'),
//           trailing: DropdownButton(
//             value: _btn2SelectedVal,
//             hint: const Text('Choose'),
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 setState(() => _btn2SelectedVal = newValue);
//               }
//             },
//             items: _dropDownMenuItems,
//           ),
//         ),
//       ],
//     );
//   }
// }