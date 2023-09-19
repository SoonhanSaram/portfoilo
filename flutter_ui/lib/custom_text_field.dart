import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  CustomTextfield({
    super.key,
    this.borderRadius = 20.0,
    this.padding = 8.0,
    this.margin = 8.0,
    this.hintText = "",
    this.leadingIcon = Icons.search,
    this.surfixIcon = Icons.send,
    required this.onTapFunction,
  });
  double margin;
  double padding;
  double borderRadius;
  String hintText;
  IconData leadingIcon;
  IconData surfixIcon;
  Function onTapFunction;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(233, 233, 233, 1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(leadingIcon),
            hintText: hintText,
            helperStyle: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 12,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                onTapFunction();
              },
              child: Icon(
                surfixIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
