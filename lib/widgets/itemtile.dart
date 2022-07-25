import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
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
      color: Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            title,
                            style: const TextStyle(
                                color: AppColors.custom,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            '\$$price',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: AppColors.custom,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.custom,
                      ),
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
