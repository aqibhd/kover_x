import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

Widget thumbnail(String url, String avgColor) {
  return Container(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: url,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 350),
      ),
      color: Color(int.parse(code(avgColor))));
}

String code(String code) {
  return '0xff' + code.substring(1);
}
