//
// ./widget/imagefullscreen_widget.dart
//



// Flutter imports
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageFullScreen extends StatelessWidget {
 
 final String picUrl;

  const ImageFullScreen(this.picUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: CachedNetworkImage(
            imageUrl: picUrl,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 4.0,),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

        ),  
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}