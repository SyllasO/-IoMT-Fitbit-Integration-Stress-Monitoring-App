import 'package:flutter/material.dart';
import 'package:fetch_data_demo/pages/query_data.dart';
import 'package:fetch_data_demo/pages/save_data.dart';
// import 'package:fetch_data_demo/pages/stress.dart';

// This is home page after login
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Welcome to home page',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // Query Heart Rate button
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: SizedBox(
                height: 65,
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QueryData(),
                        ),
                      );
                    },
                    child: const Text(
                      'Query Heart Rate',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 59, 105),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Save Heart Rate button
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: SizedBox(
                height: 65,
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SaveData(),
                        ),
                      );
                    },
                    child: const Text(
                      'Save Heart Rate',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 59, 105),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Log out button
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: SizedBox(
                height: 65,
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 59, 105),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}