import 'package:flutter/material.dart';
import 'package:kover_x/const_file.dart';

Widget noInternetBanner(BuildContext context) {
  return Container(
    height: 40,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    color: bannerColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.cloud_off,
          size: 18,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "You're offline. Please check your Internet connection.",
          style: TextStyle(fontSize: 12),
        )
      ],
    ),
  );
}
