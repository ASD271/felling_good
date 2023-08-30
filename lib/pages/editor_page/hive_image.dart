import 'package:flutter/material.dart';
class HiveImageButton extends StatelessWidget {
  const HiveImageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){print('hello embedded button' );}, icon: Icon(Icons.ac_unit));
  }
}