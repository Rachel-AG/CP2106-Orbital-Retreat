import 'package:flutter/material.dart';
import 'package:retreat/constants/text_styles.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(32.0, 0, 32.0, 24.0),
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final int price;
  final EdgeInsetsGeometry padding;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 290,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(
                      imageUrl,
                      
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyles.optionTextStyle,
                        ),
                        Text('\$$price', style: TextStyles.subOptionTextStyle),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add), 
                      onPressed: onPressed,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
