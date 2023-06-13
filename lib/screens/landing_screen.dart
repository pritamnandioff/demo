import 'package:demo/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  TextEditingController _url = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      url: _url.text,
                    )));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextField(
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     hintText: 'Enter a search term',
                //   ),
                //   controller: _url,
                //   onSubmitted: (value) {
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => HomeScreen(
                //               url: _url.text,
                //             )));
                //   },
                // ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(10)),
                  height: 220,
                  width: 200,
                  child: Column(
                    children: [
                      Image.asset("assets/amazon.png"),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Visit us",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
