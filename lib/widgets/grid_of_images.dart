import 'package:flutter/material.dart';
import 'package:kover_x/pages/wallpaper_page.dart';
import 'package:kover_x/widgets/thumbnail.dart';

// ignore: must_be_immutable
class Grid extends StatelessWidget {
  List source = [];
  bool loading;
  VoidCallback enable, disable; //function for enable and disable load btn
  Grid(
      {Key? key,
      required this.loading,
      required this.source,
      required this.enable,
      required this.disable})
      : super(key: key);

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
            physics: loading
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 2 / 3),
            itemCount: source.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WallpaperPage(
                                  source: source[index],
                                )));
                  },
                  child: thumbnail(source[index]['src']['tiny'],
                      source[index]['avg_color']));
            }),
      ),
    );
  }
}
