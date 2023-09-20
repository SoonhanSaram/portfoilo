import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    this.outPadding = 12.0,
    this.fontSize = 16.0,
    this.radius = 20.0,
    this.prefixIcon = const Icon(Icons.search),
    this.surfixIcon = const Icon(Icons.send),
    this.hintText = "",
  });
  double outPadding;
  double fontSize;
  double radius;
  Icon prefixIcon;
  Icon surfixIcon;
  String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(outPadding),
      child: TextField(
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: surfixIcon,
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
