// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `CAApp`
  String get app_title {
    return Intl.message(
      'CAApp',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `Hi, what can I generate?`
  String get welcome_msg {
    return Intl.message(
      'Hi, what can I generate?',
      name: 'welcome_msg',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `No items in history`
  String get no_history {
    return Intl.message(
      'No items in history',
      name: 'no_history',
      desc: '',
      args: [],
    );
  }

  /// `No Internet connection`
  String get no_network {
    return Intl.message(
      'No Internet connection',
      name: 'no_network',
      desc: '',
      args: [],
    );
  }

  /// `Are you connected to the network?`
  String get no_network_q {
    return Intl.message(
      'Are you connected to the network?',
      name: 'no_network_q',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcome_back {
    return Intl.message(
      'Welcome back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Sign in / Sign up`
  String get sign_in_sign_up {
    return Intl.message(
      'Sign in / Sign up',
      name: 'sign_in_sign_up',
      desc: '',
      args: [],
    );
  }

  /// `No images found`
  String get no_images {
    return Intl.message(
      'No images found',
      name: 'no_images',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get delete_content {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'delete_content',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get logout_content {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logout_content',
      desc: '',
      args: [],
    );
  }

  /// `Image uploaded`
  String get image_uploaded {
    return Intl.message(
      'Image uploaded',
      name: 'image_uploaded',
      desc: '',
      args: [],
    );
  }

  /// `Image uploaded for the word `
  String get image_uploaded_keyword {
    return Intl.message(
      'Image uploaded for the word ',
      name: 'image_uploaded_keyword',
      desc: '',
      args: [],
    );
  }

  /// `Parental Control`
  String get parental_control {
    return Intl.message(
      'Parental Control',
      name: 'parental_control',
      desc: '',
      args: [],
    );
  }

  /// `Protect your loved ones`
  String get parental_control_1 {
    return Intl.message(
      'Protect your loved ones',
      name: 'parental_control_1',
      desc: '',
      args: [],
    );
  }

  /// `With this feature you can decide whether to show explicit images on themes such as sex and violence`
  String get parental_control_2 {
    return Intl.message(
      'With this feature you can decide whether to show explicit images on themes such as sex and violence',
      name: 'parental_control_2',
      desc: '',
      args: [],
    );
  }

  /// `AI Style`
  String get ai_style {
    return Intl.message(
      'AI Style',
      name: 'ai_style',
      desc: '',
      args: [],
    );
  }

  /// `Choose your style`
  String get ai_style_1 {
    return Intl.message(
      'Choose your style',
      name: 'ai_style_1',
      desc: '',
      args: [],
    );
  }

  /// `With this feature you can choose the style you prefer for the generated images`
  String get ai_style_2 {
    return Intl.message(
      'With this feature you can choose the style you prefer for the generated images',
      name: 'ai_style_2',
      desc: '',
      args: [],
    );
  }

  /// `pictogram`
  String get ai_style_pictogram {
    return Intl.message(
      'pictogram',
      name: 'ai_style_pictogram',
      desc: '',
      args: [],
    );
  }

  /// `realism`
  String get ai_style_realism {
    return Intl.message(
      'realism',
      name: 'ai_style_realism',
      desc: '',
      args: [],
    );
  }

  /// `cartoon`
  String get ai_style_cartoon {
    return Intl.message(
      'cartoon',
      name: 'ai_style_cartoon',
      desc: '',
      args: [],
    );
  }

  /// `Chat language`
  String get chat_language {
    return Intl.message(
      'Chat language',
      name: 'chat_language',
      desc: '',
      args: [],
    );
  }

  /// `Break down language barriers`
  String get chat_language_1 {
    return Intl.message(
      'Break down language barriers',
      name: 'chat_language_1',
      desc: '',
      args: [],
    );
  }

  /// `With this feature you can select the language with which to communicate via text`
  String get chat_language_2 {
    return Intl.message(
      'With this feature you can select the language with which to communicate via text',
      name: 'chat_language_2',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get chat_language_it {
    return Intl.message(
      'Italian',
      name: 'chat_language_it',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get chat_language_en {
    return Intl.message(
      'English',
      name: 'chat_language_en',
      desc: '',
      args: [],
    );
  }

  /// `Enter the text to generate images`
  String get insert_text {
    return Intl.message(
      'Enter the text to generate images',
      name: 'insert_text',
      desc: '',
      args: [],
    );
  }

  /// `Error in generating images`
  String get error_gen_image {
    return Intl.message(
      'Error in generating images',
      name: 'error_gen_image',
      desc: '',
      args: [],
    );
  }

  /// `AI Image Generation`
  String get genai {
    return Intl.message(
      'AI Image Generation',
      name: 'genai',
      desc: '',
      args: [],
    );
  }

  /// `Enter something to generate`
  String get genai_insert {
    return Intl.message(
      'Enter something to generate',
      name: 'genai_insert',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to generate...`
  String get genai_question {
    return Intl.message(
      'What do you want to generate...',
      name: 'genai_question',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Images found`
  String get images_found {
    return Intl.message(
      'Images found',
      name: 'images_found',
      desc: '',
      args: [],
    );
  }

  /// `I generated %d images`
  String get images_generated {
    return Intl.message(
      'I generated %d images',
      name: 'images_generated',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
