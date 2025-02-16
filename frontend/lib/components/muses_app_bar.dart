import 'package:flutter/material.dart';

class MusesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLogo;

  const MusesAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      iconTheme: IconThemeData(color: Colors.black87),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
