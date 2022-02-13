import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kover_x/pages/search_page.dart';
import 'package:kover_x/widgets/grid_of_images.dart';
import 'package:kover_x/widgets/load_more_btn.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  bool isShown = false;
  bool isBorderOnBtn = false;
  int _pageNo = 1;
  @override
  void initState() {
    super.initState();
    fetchInit();
  }

  fetchInit() async {
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/curated?per_page=80&page=$_pageNo'),
        headers: {
          'Authorization':
              '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
    });
  }

  fetchMore() async {
    isShown = false;
    _pageNo = _pageNo + 1;
    setState(() {});
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/curated?per_page=80&page=$_pageNo'),
        headers: {
          'Authorization':
              '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  enableLoad() {
    isShown = true;
    setState(() {});
  }

  disableLoad() {
    isShown = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color(0xff181B1F),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                isBorderOnBtn = true;
                setState(() {});
                Future.delayed(const Duration(seconds: 1), () {
                  isBorderOnBtn = false;
                  setState(() {});
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SearchPage();
                }));
              },
              child: Container(
                height: 36,
                width: 36,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.search,
                  color: Color(0xff596271),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isBorderOnBtn
                        ? Border.all(color: const Color(0xff121417), width: 2)
                        : Border.all(color: const Color(0xff181B1F))),
              ),
            ),
          ),
          //color: Colors.red,
        ),
        Grid(source: images, enable: enableLoad, disable: disableLoad),
        LoadMoreBtn(loadMore: fetchMore, isShown: isShown)
      ]),
    ));
  }
}
