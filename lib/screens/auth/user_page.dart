import 'dart:async';

import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/services/cloud/dto.dart';
import 'package:emad_client/widget/dialogs/logout_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../services/cloud/firebase_cloud_storage.dart';
import 'images_list_view.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late StreamSubscription<User?> _userSubscription;
  late User _user;

  late final FirebaseCloudStorage _imagesService;

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

    _imagesService = FirebaseCloudStorage();
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
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                Get.toNamed('/');
              }
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _imagesService.allImages(userId: _user.uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              case ConnectionState.active:
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final allImages = snapshot.data as Iterable<CloudImage>;
                  return ImagesListView(
                    images: allImages,
                    onDeleteImage: (image) async {
                      await _imagesService.deleteImage(imageId: image.imageId);
                    },
                  );
                }
                return Center(child: Text(context.loc.no_images));
              default:
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ),
    );
  }
}
