import 'package:flutter/material.dart';
import 'package:demo/controller/set_data.dart';
import 'package:demo/utils/loading.dart';
// import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:get/get.dart';
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
  int _currentIndex = 0;
  double _progress = 0.0;
  final box = GetStorage();
  InAppWebViewController? _webViewController;
  String? currentUrl;
  final MetadataController metadataController = Get.find<MetadataController>();

  saveMapList(Map<String, dynamic> metaData) {
    storage.write('mapList', metaData);
  }

  String? header;
  Future<void> fetchAmazonProductMetadata(String url) async {
    // String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
    LoadingHelper.showLoading();
    final imageUrl;
    final imageElement;
    var header = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3578.98 Safari/537.36',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip',
      'DNT': '1',
      'Connection': 'close'
    };
    var header2 = {
      "User-Agent": _userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip',
      'DNT': '1',
      'Connection': 'close'
    };
    // var header3 = {
    //   'User-Agent': _userAgent.toLowerCase(),
    //   'Accept':
    //       'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    //   'Accept-Language': 'en-US, en;q=0.5',
    //   'Accept-Encoding': 'gzip',
    //   'DNT': '1',
    //   'Connection': 'close'
    // };
    // print(header3);

    var response = await http.get((Uri.parse(url)), headers: header2);
    // var response = await http.get(
    //   (Uri.parse(url)),
    // );

    print(response.body);

    final document = htmlParser.parse(response.body);
    final title = document.querySelector('#productTitle')?.text.trim() ??
        "Data can't be fetched";
    imageElement = document.querySelector('img#landingImage');
    imageUrl = imageElement?.attributes['src'] ?? "https://fakeimg.pl/150x150/";

    // final imageElement = document.querySelector("#landingImage");
    // final titleElement = document.querySelector('#productTitle');

    // final imageUrl =
    //     imageElement?.attributes['src'] ?? "https://fakeimg.pl/150x150/";
    // titleElement ?? "";

    // final title = titleElement == null
    //     ? "Data can't be fetched"
    //     : titleElement.text.trim();

    LoadingHelper.hideLoading();
    final metadata = {
      'title': title,
      'imageUrl': imageUrl,
      "url": url,
    };
    print(metadata);
    if (storage.read("mapList") == null) {
      metadataController.setMetadata(
          title: title, imageUrl: imageUrl, url: url);

      Fluttertoast.showToast(
          msg: "item added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 100,
          fontSize: 16.0);
    } else if (storage.read("mapList")["url"] == metadata["url"]) {
      Fluttertoast.showToast(
          msg: "this item is already saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 100,
          fontSize: 16.0);
    } else if (storage.read("mapList")["url"] != metadata["url"]) {
      metadataController.setMetadata(
          title: title, imageUrl: imageUrl, url: url);
      Fluttertoast.showToast(
          msg: "item added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 100,
          fontSize: 16.0);
    }
  }

  webpageDirector(int index) {
    setState(
      () {
        _currentIndex = index;
        if (_currentIndex == 0) {
          _webViewController?.reload();
        } else if (_currentIndex == 1) {
          _webViewController?.goBack();
        } else if (_currentIndex == 2) {
          _webViewController?.goForward();
        }
        // else if (_currentIndex == 3) {
        //   if (_webViewController != null) {
        //     _webViewController!.getUrl().then((url) {
        //       fetchAmazonProductMetadata(url.toString());
        //       setState(() {
        //         currentUrl = url.toString();
        //       });
        //     });
        //   }
        // }
      },
    );
  }

  String _userAgent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home_outlined)),
        title: const Text('Demo'),
      ),
      body: Column(
        children: [
          _progress < 1.0
              ? LinearProgressIndicator(
                  value: _progress,
                  color: Colors.white,
                  minHeight: 2,
                )
              : const SizedBox(),
          Expanded(
            child: WillPopScope(
              onWillPop: () async {
                if (await _webViewController?.canGoBack() ?? false) {
                  _webViewController?.goBack();
                  return false;
                }
                return true;
              },
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: Uri.parse(widget.url), headers: {
                  "User-Agent":
                      "Mozilla/5.0 (iPhone; CPU iPhone OS 16_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
                }),

                onWebViewCreated:
                    (InAppWebViewController webViewController) async {
                  _webViewController = webViewController;
                },
                onLoadStart: ((controller, url) {}),
                onProgressChanged: ((controller, load) async {
                  Uri? url = await controller.getUrl();
                  setState(() {
                    currentUrl = url?.toString();
                  });
                  setState(() {
                    _progress = load / 100;
                  });
                }),
                onLoadStop: (controller, url) async {
                  final userAgent = await controller.evaluateJavascript(
                      source: "window.navigator.userAgent");
                  setState(() {
                    _userAgent = userAgent;
                  });
                  print("User Agent: $_userAgent");

                  setState(() {
                    currentUrl = url.toString();
                  });
                },
                onTitleChanged: (controller, title) {
                  // print("hii$title");
                },
//                 initialOptions: InAppWebViewGroupOptions(
//                     crossPlatform: InAppWebViewOptions(
// // debuggingEnabled: true,
//                   userAgent:
//                       'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
//                   javaScriptEnabled: true,
//                   useShouldOverrideUrlLoading: true,
//                   useOnLoadResource: true,
//                   cacheEnabled: true,
//                 )),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _progress == 1
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                if (_progress == 1.0) {
                  if (_webViewController != null) {
                    _webViewController!.getUrl().then((url) {
                      fetchAmazonProductMetadata(url.toString());
                      setState(() {
                        currentUrl = url.toString();
                      });
                    });
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "Loading please wait",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 100,
                    fontSize: 16.0,
                  );
                }
              },
            )
          : const SizedBox(),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        webpageDirector(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.refresh),
          label: 'Refresh',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_back),
          label: 'Backward',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_forward),
          label: 'Forward',
        ),
      ],
    );
  }
}
