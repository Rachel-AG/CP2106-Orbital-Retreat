import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    Key? key,
    this.imageUrl =
        'https://ztjtrovgvzujvwbeipqv.supabase.co/storage/v1/object/public/avatars/2022-06-11T02:01:51.017482.png',
    this.size = 80,
  }) : super(key: key);

  final String imageUrl;
  final double size;
  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.size / 2),
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}
