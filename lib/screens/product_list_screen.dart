import 'package:demo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MapListScreen extends StatefulWidget {
  @override
  _MapListScreenState createState() => _MapListScreenState();
}

class _MapListScreenState extends State<MapListScreen> {
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
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: mapList.isEmpty
          ? const Center(
              child: Text(
                'No records found.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: mapList.length,
              itemBuilder: (context, index) {
                final map = mapList[index];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
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
    );
  }
}
