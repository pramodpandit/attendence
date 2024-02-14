import 'package:flutter/material.dart';
import 'package:office/utils/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, this.actions, this.leading, this.autoLeading});
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? autoLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: autoLeading ?? true,
      leading: leading,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: K.themeColorPrimary,
        ),
      ),
      actions: actions,
    );
  }
  
  @override
  final Size preferredSize = const Size.fromHeight(50);
}