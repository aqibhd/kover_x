import 'package:flutter/material.dart';
import 'package:kover_x/const_file.dart';

// ignore: must_be_immutable
class LoadMoreBtn extends StatefulWidget {
  VoidCallback loadMore;
  bool btnStatus, loadStatus;

  LoadMoreBtn(
      {Key? key,
      required this.loadMore,
      required this.btnStatus,
      required this.loadStatus})
      : super(key: key);

  @override
  _LoadMoreBtnState createState() => _LoadMoreBtnState();
}

class _LoadMoreBtnState extends State<LoadMoreBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.btnStatus ? () => {widget.loadMore()} : null,
      child: Opacity(
        opacity: widget.btnStatus ? 1 : 0.1,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          color: secondary,
          child: widget.loadStatus
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ))
              : Text(
                  widget.btnStatus ? "LOAD MORE" : "Scroll",
                  style: const TextStyle(
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
