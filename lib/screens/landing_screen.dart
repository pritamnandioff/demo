import 'package:demo/controller/set_data.dart';
import 'package:demo/screens/home_screen.dart';
import 'package:demo/screens/no_records_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _url = TextEditingController();
  final List<Map<String, dynamic>> mapList = [];
  final GetStorage storage = GetStorage();
  final controler = Get.put(MetadataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => storage.erase(),
      //   child: Icon(Icons.clear_sharp),
      // ),
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
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  Obx(
                    () {
                      if (controler.metadata.value.length == 0) {
                        return const Expanded(
                          flex: 4,
                          child: NoRecordFound(),
                        );
                      } else {
                        return Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    url: controler.metadata["url"],
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Image.network(
                                        controler.metadata["imageUrl"] ?? ""),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(controler.metadata["title"] ?? ""),
                                const SizedBox(
                                  height: 10,
                                ),
                                SelectableText(
                                  controler.metadata["url"] ?? "",
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          url: controler.metadata["url"],
                                        ),
                                      ),
                                    );
                                  },
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
