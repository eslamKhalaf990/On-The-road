import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AlertDialog checksDialog() {
  int checks = 0;
  late bool checkBox1 = false;
  late bool checkBox2 = false;
  late bool checkBox3 = false;
  return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Center(child: Text("Checks")),
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Seat Belt  '),
                const ImageIcon(
                    size: 35, AssetImage("assets/icons8-seat-belt-96.png")),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 70),
                      child: Checkbox(
                        value: checkBox1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        onChanged: (bool? value) {
                          setState(() {
                            checkBox1 = value!;
                            value ? checks++ : checks--;
                            if (checks == 3) {
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text('Water '),
                const ImageIcon(
                    size: 35, AssetImage("assets/icons8-water-100.png")),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 70),
                      child: Checkbox(
                        value: checkBox2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        onChanged: (bool? value) {
                          setState(() {
                            checkBox2 = value!;
                            value ? checks++ : checks--;
                            if (checks == 3) {
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text('Oil '),
                const ImageIcon(
                    size: 35, AssetImage("assets/icons8-engine-oil-100.png")),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 70),
                      child: Checkbox(
                        value: checkBox3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        onChanged: (bool? value) {
                          setState(() {
                            checkBox3 = value!;
                            value ? checks++ : checks--;
                            if (checks == 3) {
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ));
}
