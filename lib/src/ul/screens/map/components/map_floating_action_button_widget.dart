import 'package:flutter/material.dart';

class MapFloatingActionButtonWidget extends StatelessWidget {
  final Function() currentPosition;
  const MapFloatingActionButtonWidget({
    Key? key,
    required this.currentPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: currentPosition,
      backgroundColor: Colors.white,
      elevation: 2,
      child: const Icon(
        Icons.my_location,
        color: Colors.black,
      ),
    );
  }
}
