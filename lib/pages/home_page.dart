import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kover_x/const_file.dart';
import 'package:kover_x/pages/search_page.dart';
import 'package:kover_x/widgets/custom_icon_button.dart';
import 'package:kover_x/widgets/grid_of_images.dart';
import 'package:kover_x/widgets/load_more_btn.dart';
import 'package:kover_x/widgets/loading.dart';
import 'package:kover_x/widgets/no_internet_banner.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  bool isEnable = false;
  //bool isBorderOnBtn = false;
  late bool isLoading;
  late bool initLoad;
  late bool _connected2Network;
  StreamSubscription? subscription;
  int _pageNo = 1;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    _connected2Network = true;
    initLoad = true;
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
    if (initLoad) {
      fetchInit();
    }
    if (isLoading && !initLoad) {
      fetchMore();
    }
  }

  fetchInit() async {
    if (_connected2Network) {
      // fetch if there is internet connection
      await http.get(
          Uri.parse(
              'https://api.pexels.com/v1/curated?per_page=80&page=$_pageNo'),
          headers: {
            'Authorization':
                '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
          }).then((value) {
        Map result = jsonDecode(value.body);
        setState(() {
          initLoad = false;
          isLoading = false;
          images = result['photos'];
        });
      });
    }
  }

  fetchMore() async {
    isEnable = false;
    isLoading = true;
    setState(() {});
    if (_connected2Network) {
      // fetch if there is internet access
      _pageNo = _pageNo + 1;
      await http.get(
          Uri.parse(
              'https://api.pexels.com/v1/curated?per_page=80&page=$_pageNo'),
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
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            // child: InkWell(
            //   onTap: () async {
            //     isBorderOnBtn = true;
            //     setState(() {});
            //     subscription?.pause(); // pausing the subscription
            //     await Navigator.push(context,
            //         MaterialPageRoute(builder: (context) {
            //       return const SearchPage();
            //     }));
            //     subscription?.resume();
            //     isBorderOnBtn = false;
            //     setState(() {}); //resuming subscripting
            //   },
            //   child: Container(
            //     height: 36,
            //     width: 36,
            //     alignment: Alignment.center,
            //     child: const Icon(
            //       Icons.search,
            //       color: Colors.white,
            //     ),
            //     decoration: BoxDecoration(
            //         color: isBorderOnBtn ? tapColor : null,
            //         shape: BoxShape.circle,
            //         border: isBorderOnBtn
            //             ? Border.all(color: border, width: 1)
            //             : null),
            //   ),
            // ),
            child: CustomIconButton(
                task: () async {
                  subscription?.pause();
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const SearchPage();
                  }));
                  subscription?.resume();
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
          //color: Colors.red,
        ),
        !_connected2Network ? noInternetBanner(context) : const SizedBox(),
        initLoad
            ? loading()
            : Grid(
                source: images,
                enable: enableLoad,
                disable: disableLoad,
                loading: isLoading,
              ),
        Visibility(
            visible: !initLoad,
            child: LoadMoreBtn(
              loadMore: fetchMore,
              btnStatus: isEnable,
              loadStatus: isLoading,
            ))
      ]),
    ));
  }
}
