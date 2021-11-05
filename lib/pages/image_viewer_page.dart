import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ImageViewerPage extends StatelessWidget {
  final Post post;
  final String board;

  const ImageViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SnackBar buildSnackBar(bool isSuccess) {
      return SnackBar(
        backgroundColor: isSuccess
            ? Theme.of(context).cardColor
            : Theme.of(context).errorColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        content: Text(
          isSuccess ? save_to_gallery_success : save_to_gallery_error,
          style: snackbarTextStyle(context),
        ).tr(),
      );
    }

    void _saveImage() async {
      var response = await Dio().get(post.getImageUrl(board),
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: '${post.filename}${post.ext}');
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(result!['isSuccess']),
      );
    }

    void _shareImage() async {
      var response = await Dio().get(post.getImageUrl(board),
          options: Options(responseType: ResponseType.bytes));
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(response.data);
      await Share.shareFiles([imagePath.path]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${post.filename}${post.ext}'),
        actions: [
          IconButton(
            onPressed: _shareImage,
            icon: Icon(Icons.share_rounded),
          ),
          IconButton(
            onPressed: _saveImage,
            icon: Icon(Icons.save_rounded),
          ),
        ],
      ),
      backgroundColor: TRANSPARENT_COLOR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: post.tim.toString(),
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              child: Stack(
                children: [
                  Image.network(
                    post.getThumbnailUrl(board),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Image.network(
                    post.getImageUrl(board),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
