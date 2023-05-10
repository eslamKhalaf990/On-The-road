import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  const Warning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.redAccent,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(
                  0, 0.1), // changes position of shadow
            ),
          ]),
      height: 100,
      margin: const EdgeInsets.only(
          left: 2, right: 2, top: 5, bottom: 3),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.all(Radius.circular(30)),
              child: Material(
                color: Colors.grey[50],
                elevation: 20,
                child: const SizedBox(
                  height: 98,
                  width: 98,
                  child: Center(
                    child: Text(
                      "32",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'tajawal',
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Text(
                "warning",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'tajawal',
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}