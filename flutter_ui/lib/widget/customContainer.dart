import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer(
      {super.key,
      this.child,
      this.height = 1.0,
      this.width = 1.0,
      this.color = const Color.fromRGBO(0, 0, 0, 0.7)});
  Color color;
  double height;
  double width;
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 2.0,
          color: color,
        ),
      ),
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * height,
      child: child,
    );
  }
}
