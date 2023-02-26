import 'package:flutter/material.dart';

bool camMood = true;

class settingPage extends StatefulWidget {
  const settingPage({Key? key}) : super(key: key);

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Text('Camera Mode'),
            Switch(
              value: camMood,
              onChanged: (bool s) {
                setState(() {
                  camMood = s;
                });
              },
            )
          ],
        ),
      ]),
    );
  }
}
