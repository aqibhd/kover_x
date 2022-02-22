import 'package:flutter/material.dart';

Widget loading() {
  return const Expanded(
      child: Center(
          child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2.5,
              ))));
}
