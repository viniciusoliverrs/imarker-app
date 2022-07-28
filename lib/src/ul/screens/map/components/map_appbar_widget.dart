import 'package:flutter/material.dart';

class MapAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final int markersAmount;
  final double distanceBetweenMarkers;
  final Function() closePointsOnMap;
  final Function() clearMap;
  const MapAppBarWidget({
    Key? key,
    required this.markersAmount,
    required this.distanceBetweenMarkers,
    required this.closePointsOnMap,
    required this.clearMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(200),
      title: Column(
        children: [
          _TextWidget(text: "Total $distanceBetweenMarkers m"),
        ],
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      actions: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: clearMap,
            ),
            IconButton(
              icon: const Icon(Icons.construction),
              onPressed: closePointsOnMap,
            ),
            _TextWidget(text: "$markersAmount"),
            const Icon(
              Icons.location_on,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TextWidget extends StatelessWidget {
  const _TextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
        fontSize: 18,
        fontFamily: "Roboto",
      ),
    );
  }
}
