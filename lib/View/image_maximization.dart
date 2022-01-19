import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageMaximization extends StatefulWidget {
  const ImageMaximization(this.imageUrl, {Key key}) : super(key: key);
  final imageUrl;

  @override
  _ImageMaximizationState createState() => _ImageMaximizationState();
}

class _ImageMaximizationState extends State<ImageMaximization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Complete Image"),
        ),
        body: Container(
            child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.imageUrl.toString()),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrl),
            );
          },
          itemCount: 1,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: Center(
                child: Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.fill,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        )));
  }
}
