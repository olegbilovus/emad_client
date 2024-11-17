import 'dart:async';

import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late StreamSubscription<User?> _userSubscription;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;

    // Detect when a user signs in or out
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        if (user != null) {
          setState(() {
            _user = FirebaseAuth.instance.currentUser!;
          });
        } else {
          setState(() {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Get.toNamed('/sign_in');
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            bool fromSignIn = Get.previousRoute == '/sign_in';
            if (fromSignIn) {
              Get.toNamed('/');
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: _user.displayName != null
            ? Text('${context.loc.welcome_back} ${_user.displayName}')
            : Text(context.loc.welcome_back),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.toNamed('/');
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "User Info",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "Email: ${_user.email}\n"
              "Id: ${_user.uid}\n"
              "DisplayName: ${_user.displayName}",
            ),
          ],
        ),
      ),
    );
  }
}
