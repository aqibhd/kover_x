import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kover_x/const_file.dart';
import 'package:kover_x/widgets/close_btn.dart';
import 'package:kover_x/widgets/custom_icon_button.dart';
import 'package:kover_x/widgets/grid_of_images.dart';
import 'package:kover_x/widgets/load_more_btn.dart';
import 'package:kover_x/widgets/no_internet_banner.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List images = [];
  final TextEditingController _controller = TextEditingController();
  bool pressed = false;
  bool isEnable = false;
  late bool isLoading; //is data being fetched?
  late bool queryActive;
  late bool _connected2Network;
  StreamSubscription? subscription;
  int _pageNo = 1;
  late String query;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _connected2Network = true;
    queryActive = false;
    networkCheck();
    subscription =
        SimpleConnectionChecker().onConnectionChange.listen((connected) {
      //listen to internet
      if (connected) {
        networkCheck();
      } else {
        _connected2Network = connected;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void networkCheck() async {
    //check for internet access and fetch data
    _connected2Network = await SimpleConnectionChecker.isConnectedToInternet();
    setState(() {});
    if (queryActive) {
      fetchQuery();
    }
    if (isLoading && !queryActive) {
      fetchMore();
    }
  }

  fetchQuery() async {
    isLoading = true;
    queryActive = true;
    setState(() {});
    if (_connected2Network) {
      await http.get(
          Uri.parse(
              'https://api.pexels.com/v1/search?query=$query&per_page=80&page=$_pageNo'),
          headers: {
            'Authorization':
                '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
          }).then((value) {
        Map result = jsonDecode(value.body);
        images = result['photos'];
        isLoading = false;
        queryActive = false;
        setState(() {});
      });
    }
  }

  fetchMore() async {
    isEnable = false;
    isLoading = true;
    setState(() {});
    if (_connected2Network) {
      _pageNo = _pageNo + 1;
      await http.get(
          Uri.parse(
              'https://api.pexels.com/v1/search?query=$query&per_page=80&page=$_pageNo'),
          headers: {
            'Authorization':
                '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
          }).then((value) {
        Map result = jsonDecode(value.body);
        setState(() {
          isLoading = false;
          images.addAll(result['photos']);
        });
      });
    }
  }

  enableLoad() {
    isEnable = true;
    setState(() {});
  }

  disableLoad() {
    isEnable = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: primary,
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
                child: CustomIconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  task: () async {
                    Navigator.pop(context);
                  },
                  buttonTypeClose: true,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      textAlignVertical: TextAlignVertical.center,
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
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        fillColor: primary,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.normal, color: hintColor),
                        hintText: "Search for wallpapers",
                      ),
                      autocorrect: true,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        !_connected2Network ? noInternetBanner(context) : const SizedBox(),
        Grid(
          source: images,
          enable: enableLoad,
          disable: disableLoad,
          loading: isLoading,
        ),
        Visibility(
            visible: images.isNotEmpty ? true : false,
            child: LoadMoreBtn(
              loadMore: fetchMore,
              btnStatus: isEnable,
              loadStatus: isLoading,
            ))
      ]),
    ));
  }
}
