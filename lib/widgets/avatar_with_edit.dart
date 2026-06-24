import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file:///')) {
      return ImageType.file;
    } else if (this.startsWith('/data/user/')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

class AvatarWithEdit extends StatelessWidget {
  final double avatarRadius;
  final double editIconSize;
  final String? imageUrl;
  final VoidCallback? onEditPressed;

  const AvatarWithEdit({
    Key? key,
    required this.avatarRadius,
    required this.editIconSize,
    this.imageUrl,
    this.onEditPressed,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final imageUrl = this.imageUrl;

  ImageProvider imageProvider;

  if (imageUrl != null && imageUrl.startsWith('/')) {
    // Local file image
    imageProvider = FileImage(File(imageUrl));
  } else if (imageUrl != null && imageUrl.startsWith('http')) {
    // Network image
    imageProvider = NetworkImage(imageUrl);
  } else {
    // Fallback (asset or placeholder)
    imageProvider = AssetImage('assets/images/logo.png');
  }
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xffD9D9D9),
          radius: avatarRadius,
          backgroundImage: imageProvider,
          child: (imageUrl == null || imageUrl.isEmpty)
              ? SvgPicture.asset('assets/images/avatar.svg')
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEditPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:Colors.grey[200],
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset('assets/images/edit.svg',height: 20,width: 20,),
              // Icon(
              //   Icons.edit,
              //   color: Colors.black,
              //   size: editIconSize,
              // ),
            ),
          ),
        ),
      ],
    );
  }
}