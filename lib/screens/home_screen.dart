import 'dart:convert';

import 'package:demo/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  final String url;
  const HomeScreen({super.key, required this.url});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetStorage storage = GetStorage();
  @override
  void initState() {
    super.initState();
    final storedMapList = storage.read('mapList');
    if (storedMapList != null) {
      mapList.addAll(storedMapList.map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item)));
    }
  }

  saveMapList() {
    storage.write('mapList', mapList);
  }

  final box = GetStorage();
  final List<Map<String, dynamic>> mapList = [];
  List addressList = [];
  Future<Map<String, dynamic>> fetchAmazonProductMetadata(String url) async {
    final response = await http.get(Uri.parse(url));
    final document = htmlParser.parse(response.body);
    final title = document.querySelector('#productTitle')?.text.trim();
    final price =
        document.querySelector('.priceBlockBuyingPriceString')?.text.trim();
    final description =
        document.querySelector('#productDescription')?.text.trim();
    final imageElement = document.querySelector('img#landingImage');
    // final imageElement = document.querySelector('#landingImage');

    final imageUrl = imageElement?.attributes['src'] ?? '';
    final metadata = {
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      "url": url,
    };
    final isValuePresent = mapList.any((map) => map['url'] == metadata['url']);
    if (!isValuePresent) {
      Fluttertoast.showToast(
          msg: "item added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 100,
          fontSize: 16.0);
      setState(() {
        mapList.add(metadata);
      });
      saveMapList();
    } else {
      Fluttertoast.showToast(
          msg: "this item is already saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 100,
          fontSize: 16.0);
    }
    return metadata;
  }

  InAppWebViewController? _webViewController;
  String? _currentUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.of(context).push(
        //           MaterialPageRoute(builder: (context) => MapListScreen()));
        //     },
        //     child: const Icon(
        //       Icons.shopping_bag,
        //       color: Colors.white,
        //     ),
        //   ),
        // ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(widget.url),
        ),
        onWebViewCreated: (InAppWebViewController webViewController) {
          _webViewController = webViewController;
        },
        onLoadStop: (controller, url) {
          setState(() {
            _currentUrl = url.toString();
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.share),
        onPressed: () {
          if (_webViewController != null) {
            _webViewController!.getUrl().then((url) {
              fetchAmazonProductMetadata(url.toString());
              setState(() {
                _currentUrl = url.toString();
              });
            });
          }
        },
      ),
    );
  }
}
