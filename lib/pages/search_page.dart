import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kover_x/widgets/grid_of_images.dart';
import 'package:kover_x/widgets/load_more_btn.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List images = [];
  TextEditingController _controller = TextEditingController();
  bool isBorderOnBtn = false;
  bool isShown = false;
  int _pageNo = 1;
  String? query;

  fetchQuery() async {
    _pageNo = 1;
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search?query=$query&per_page=80&page=$_pageNo'),
        headers: {
          'Authorization':
              '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
        }).then((value) {
      Map result = jsonDecode(value.body);
      images = result['photos'];
      setState(() {});
    });
  }

  fetchMore() async {
    isShown = false;
    _pageNo = _pageNo + 1;
    setState(() {});
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search?query=$query&per_page=80&page=$_pageNo'),
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
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () {
                    isBorderOnBtn = true;
                    setState(() {});
                    Future.delayed(const Duration(seconds: 1), () {
                      isBorderOnBtn = false;
                      setState(() {});
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 36,
                    width: 36,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close,
                      color: Color(0xff596271),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isBorderOnBtn
                            ? Border.all(
                                color: const Color(0xff121417), width: 2)
                            : Border.all(color: const Color(0xff181B1F))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.pink,
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (string) {
                        query = string;
                        fetchQuery();
                      },
                      cursorWidth: 1.2,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        fillColor: Color(0xff121417),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xffA0A0A0)),
                        hintText: "Search for wallpapers",
                      ),
                      autocorrect: true,
                    ),
                  ),
                ),
              )
            ],
          ),
          //color: Colors.red,
        ),
        Grid(source: images, enable: enableLoad, disable: disableLoad),
        LoadMoreBtn(loadMore: fetchMore, isShown: isShown)
      ]),
    ));
  }
}
