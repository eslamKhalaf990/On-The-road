import 'dart:async';
import 'package:flutter/material.dart';
import 'package:on_the_road/Services/map_services.dart';
import 'package:on_the_road/constants/design_constants.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';

void showAutoDismissDialog(BuildContext context, String message, int id) {
  Timer t;
  MapServices mapServices = MapServices();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Set up a Timer to dismiss the dialog after 10 seconds
      t = Timer(const Duration(seconds: 10), () {
        Navigator.of(context).pop();
      });
      return Column(
        // alignment: Alignment.topCenter,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.grey[900],
            // title: const Text('Auto Dismiss Dialog'),
            content: Center(
              child: Text(
                'Did you find a $message?',
                style: TextStyle(fontFamily: DesignConstants.fontFamily),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors
                          .grey[700]), // Set the background color of the button
                    ),
                    onPressed: () {
                      mapServices.sendUserFeedBack(
                          Provider.of<User>(context, listen: false).token,
                          true,
                          id);
                      t.cancel();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(fontFamily: DesignConstants.fontFamily),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors
                          .grey[700]), // Set the background color of the button
                    ),
                    onPressed: () {
                      t.cancel();
                      mapServices.sendUserFeedBack(
                          Provider.of<User>(context, listen: false).token,
                          false,
                          id);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(fontFamily: DesignConstants.fontFamily),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
// void showCustomDialog(BuildContext context, String message) {
//   showDialog(
//     barrierColor: Colors.transparent,
//     context: context,
//     builder: (BuildContext cxt) {
//       return Align(
//         alignment: Alignment.topCenter,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Material(
//             color: Colors.black,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15)),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Did You Found a $message",
//                     style: const TextStyle(
//                       fontSize: 19,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 7.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('yes'),
//                       ),
//                       const SizedBox(width: 17.0),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Close'),
//                       )
//                     ],
//                   ),
//                   // const ShrinkingLine()
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
