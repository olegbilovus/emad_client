import 'package:emad_client/widget/custom_appbar_back.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbarBack(
          title: 'Sign In / Sign Up',
        ),
        body: SignInScreen(
          actions: [
            ForgotPasswordAction(
              (context, email) {
                Get.toNamed('/forgot_password', arguments: email);
              },
            ),
            AuthStateChangeAction(
              (context, state) {
                if (state is UserCreated || state is SignedIn) {
                  var user = (state is SignedIn)
                      ? state.user
                      : (state as UserCreated).credential.user;
                  if (user == null) {
                    return;
                  }
                  if (!user.emailVerified && (state is UserCreated)) {
                    user.sendEmailVerification();
                  }
                  if (state is UserCreated) {
                    if (user.displayName == null && user.email != null) {
                      var defaultDisplayName = user.email!.split('@')[0];
                      user.updateDisplayName(defaultDisplayName);
                    }
                  }
                  Get.toNamed('/user_page');
                }
              },
            ),
          ],
        ));
  }
}
