import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kover_x/const_file.dart';

class CustomIconButton extends StatefulWidget {
  Widget icon;
  AsyncCallback task;
  bool buttonTypeClose;
  CustomIconButton(
      {Key? key,
      required this.icon,
      required this.task,
      this.buttonTypeClose = false})
      : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  late bool tapped;
  @override
  void initState() {
    super.initState();
    tapped = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          tapped = true;
          setState(() {});
          await widget.task();
          if (!widget.buttonTypeClose) {
            tapped = false;
            setState(() {});
          }
        },
        child: Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          child: widget.icon,
          decoration: BoxDecoration(
              color: tapped ? tapColor : null,
              shape: BoxShape.circle,
              border: tapped ? Border.all(color: border, width: 1) : null),
        ));
  }
}
