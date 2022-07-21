import 'package:flutter/material.dart';

import '../../../../domain/entity/range_entity.dart';

class MapDrawerListTileWidget extends StatelessWidget {
  const MapDrawerListTileWidget({
    Key? key,
    required this.position,
  }) : super(key: key);

  final RangeEntity position;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        visualDensity: VisualDensity.compact,
        dense: true,
        leading: const Icon(
          Icons.location_on,
          color: Colors.black,
        ),
        title: Text(position.start.address(),
            style: const TextStyle(fontSize: 18)),
        subtitle: Text(
          position.end.address(),
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 16,
          ),
        ),
        trailing: Text("${position.distance}m",
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
