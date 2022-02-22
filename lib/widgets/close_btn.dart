import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CloseBtn extends StatelessWidget {
  bool clicked;
  Color tapBackgroundColor, borderColor;
  CloseBtn(
      {Key? key,
      required this.clicked,
      this.tapBackgroundColor = const Color(0xff242424),
      this.borderColor = const Color(0xff353535)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      alignment: Alignment.center,
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
          color: clicked ? tapBackgroundColor : null,
          shape: BoxShape.circle,
          border: clicked ? Border.all(color: borderColor, width: 1) : null),
    );
  }
}
