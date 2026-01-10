import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';

class ImageWindow extends StatelessWidget {
  final String imageUrl;

  const ImageWindow({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    String decodedUrl = decodeString(imageUrl);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Set the status bar background color
        statusBarIconBrightness: Brightness.dark, // Change icons for visibility
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: TopAppBar(width: MediaQuery.of(context).size.width, isCategory: true,),
        body: Center(
          child: PhotoView(
            imageProvider: NetworkImage(decodedUrl),
          ),
        ),
      )
    );
  }
}