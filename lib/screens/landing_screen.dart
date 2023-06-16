import 'package:demo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_storage/get_storage.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  TextEditingController _url = TextEditingController();

  final List<Map<String, dynamic>> mapList = [];
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    // Retrieve stored map list from local storage
    final storedMapList = storage.read('mapList');
    if (storedMapList != null) {
      // If stored data exists, assign it to the map list
      mapList.addAll(storedMapList.map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    url: _url.text,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                        controller: _url,
                        onSubmitted: (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                url: _url.text,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  mapList.isEmpty
                      ? Expanded(
                          flex: 4,
                          child: const Center(
                            child: Text(
                              'No records found.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 4,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              return Future(() {
                                setState(() {});
                              });
                            },
                            child: ListView.builder(
                              // reverse: true,
                              // itemCount: 1,
                              itemCount: mapList.length,
                              itemBuilder: (context, index) {
                                final map = mapList[index];
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                                  url: map["url"],
                                                )));
                                  },
                                  leading: CircleAvatar(
                                    child: Image.network(map["imageUrl"] ?? ""),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  title: Text('Item ${index + 1}'),
                                  subtitle: Column(
                                    children: [
                                      Text(map["title"] ?? ""),
                                      Text(
                                        map["url"] ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.black, width: 3),
                  //       borderRadius: BorderRadius.circular(10)),
                  //   height: 220,
                  //   width: 200,
                  //   child: Column(
                  //     children: [
                  //       Image.asset("assets/amazon.png"),
                  //       const SizedBox(
                  //         height: 5,
                  //       ),
                  //       const Text(
                  //         "Visit us",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold, fontSize: 18),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
