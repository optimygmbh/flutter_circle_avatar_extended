library flutter_circle_avatar_extended;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleAvatarExtended extends StatelessWidget {
  final String imageUrl;
  final String placeholderText;
  final ImageProvider placeholderImage;
  final Map<String, String> httpHeaders;
  final bool blurPhoto;
  final Color backgroundColor;

  const CircleAvatarExtended({
    Key key,
    @required this.imageUrl,
    this.placeholderText,
    this.placeholderImage,
    this.httpHeaders,
    this.blurPhoto,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
      ),
    );
  }
}
