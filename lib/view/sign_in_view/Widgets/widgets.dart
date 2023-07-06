import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final String name;
  final Icon icon;
  final TextEditingController controller;
  final bool obsText;
  final Function(String)? onChanged; // Added onChanged callback

  const Field({
    Key? key,
    required this.name,
    required this.icon,
    required this.controller,
    required this.obsText,
    this.onChanged, // Added onChanged callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextField(
        onChanged: onChanged, // Added onChanged callback
        controller: controller,
        obscureText: obsText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: name,
          prefixIcon: icon,
        ),
      ),
    );
  }
}
