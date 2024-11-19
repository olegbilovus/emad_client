// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_title": MessageLookupByLibrary.simpleMessage("CAApp"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_content": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete?"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "image_uploaded":
            MessageLookupByLibrary.simpleMessage("Image uploaded"),
        "image_uploaded_keyword": MessageLookupByLibrary.simpleMessage(
            "Image uploaded for the word "),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "logout_content": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to logout?"),
        "no_history":
            MessageLookupByLibrary.simpleMessage("No items in history"),
        "no_images": MessageLookupByLibrary.simpleMessage("No images found"),
        "no_network":
            MessageLookupByLibrary.simpleMessage("No Internet connection"),
        "no_network_q": MessageLookupByLibrary.simpleMessage(
            "Are you connected to the network?"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "sign_in_sign_up":
            MessageLookupByLibrary.simpleMessage("Sign in / Sign up"),
        "welcome_back": MessageLookupByLibrary.simpleMessage("Welcome back"),
        "welcome_msg":
            MessageLookupByLibrary.simpleMessage("Hi, what can I generate?")
      };
}
