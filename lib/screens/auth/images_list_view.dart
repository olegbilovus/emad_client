import 'dart:convert';

import 'package:emad_client/services/cloud/dto.dart';
import 'package:flutter/material.dart';

import '../../widget/dialogs/delete_dialog.dart';

typedef ImageCallBack = void Function(CloudImage note);

class ImagesListView extends StatelessWidget {
  final Iterable<CloudImage> images;
  final ImageCallBack onDeleteImage;

  const ImagesListView(
      {super.key, required this.images, required this.onDeleteImage});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images.elementAt(index);
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.memory(
                  base64Decode(image.base64),
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: Text(
                  textAlign: TextAlign.center,
                  image.keyword,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteImage(image);
                    }
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
