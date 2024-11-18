import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: context.loc.logout,
      content: context.loc.logout_content,
      optionsBuilder: () => {
            Text(context.loc.cancel): false,
            Text(
              context.loc.logout,
              style: const TextStyle(color: Colors.red),
            ): true
          }).then((value) => value ?? false);
}
