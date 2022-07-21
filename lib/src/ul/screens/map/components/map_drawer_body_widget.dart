// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../domain/entity/range_entity.dart';
import 'map_drawer_list_tile_widget.dart';

class MapDrawerBodyWidget extends StatelessWidget {
  final Size size;
  final List<RangeEntity> ranges;

  const MapDrawerBodyWidget({
    Key? key,
    required this.size,
    required this.ranges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * .9,
      child: Drawer(
        backgroundColor: Colors.white.withAlpha(200),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ranges.length,
                itemBuilder: (_, index) {
                  return MapDrawerListTileWidget(
                      position: ranges.elementAt(index));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
