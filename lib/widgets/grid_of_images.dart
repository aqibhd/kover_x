import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Grid extends StatelessWidget {
  List source = [];
  VoidCallback enable, disable; //function for enable and disable load btn
  Grid(
      {Key? key,
      required this.source,
      required this.enable,
      required this.disable})
      : super(key: key);
  String code(String code) {
    return '0xff' + code.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            enable();
          } else {
            disable();
          }

          return true;
        },
        child: GridView.builder(
            padding: const EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 2 / 3),
            itemCount: source.length,
            itemBuilder: (context, index) {
              return Container(
                  child: Image.network(
                    source[index]['src']['tiny'],
                    fit: BoxFit.cover,
                  ),
                  color: Color(int.parse(code(source[index]['avg_color']))));
            }),
      ),
    );
  }
}
