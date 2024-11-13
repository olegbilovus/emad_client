import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.toNamed('/settings');
        },
        icon: const Icon(
          Icons.settings,
          color: Colors.black,
        ),
      ),
      title: Text(
        context.loc.app_title,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: IconButton(
            onPressed: () {
              Get.toNamed('/user_page');
            },
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
