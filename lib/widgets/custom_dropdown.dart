import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/notifiers/theme_mode_change_notifier.dart';

class CustomDropdownButton extends StatefulWidget {
  String? btnSelectedVal;
  List<String> menuItems;
  String? title;
  String? hint;

  CustomDropdownButton(
      {Key? key,
      this.btnSelectedVal,
      required this.menuItems,
      this.title,
      this.hint})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> dropDownMenuItems = widget.menuItems
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: AppColors.custom.shade300),
            ),
          ),
        )
        .toList();

    return Column(
      children: <Widget>[
        ListTile(
          // tileColor: ThemeModeChangeNotifier().oppTextDefaultColor,
          title: Text(
            widget.title ?? "Items: ",
          ),
          trailing: DropdownButton<String>(
            value: widget.btnSelectedVal,
            hint: Text(
              widget.hint ?? "Choose",
              style: TextStyle(color: AppColors.custom.shade300),
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => widget.btnSelectedVal = newValue);
              }
            },
            items: dropDownMenuItems,
          ),
        ),
      ],
    );
  }
}
