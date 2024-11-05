import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          // Vai ad impostazioni
        },
        icon: const Icon(
          Icons.settings,
          color: Colors.black,
        ),
      ),
      title: const Text(
        "CAApp",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle:
          true, // Impostazione per un'ulteriore assicurazione della centratura
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
