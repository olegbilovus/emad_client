import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: context.loc.delete,
      content: context.loc.delete_content,
      optionsBuilder: () => {
            Text(context.loc.cancel): false,
            Text(
              context.loc.delete,
              style: const TextStyle(color: Colors.red),
            ): true
          }).then((value) => value ?? false);
}
