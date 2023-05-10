import 'package:flutter/material.dart';

class Field extends StatelessWidget {

  const Field({super.key, required this.name, required this.icon, required this.controller, required this.obsText});
  final String name;
  final TextEditingController controller;
  final Icon icon;
  final bool obsText;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This Field Is Required';
          }
          return null;
        },
        controller: controller,
        obscureText: obsText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
            borderSide: BorderSide(
                color: Colors.black,
                width: 1
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
            borderSide: BorderSide(
                color: Colors.black,
                width: 1
            ),
          ),
          labelText: name,
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 10, bottom: 6),
            child: icon,
          ),
          labelStyle: const TextStyle(fontFamily: 'tajawal'),
        ),
      ),
    );
  }
}
