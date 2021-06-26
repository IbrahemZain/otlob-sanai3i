import 'package:flutter/material.dart';

class ImageProfile extends StatelessWidget {
  final String image;
  ImageProfile({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'dash',
          child: Image(
            image: NetworkImage(image),
          ),
        ),
      ),
    );
  }
}
