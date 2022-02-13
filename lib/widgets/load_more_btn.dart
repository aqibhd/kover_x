import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadMoreBtn extends StatefulWidget {
  VoidCallback loadMore;
  bool isShown;

  LoadMoreBtn({Key? key, required this.loadMore, required this.isShown})
      : super(key: key);

  @override
  _LoadMoreBtnState createState() => _LoadMoreBtnState();
}

class _LoadMoreBtnState extends State<LoadMoreBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isShown ? () => {widget.loadMore()} : null,
      child: Opacity(
        opacity: widget.isShown ? 1 : 0.1,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xff121417),
          child: const Text(
            "LOAD MORE",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.7,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
