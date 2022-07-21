// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:imarker_app/src/domain/entity/position_entity.dart';

class RangeEntity {
  final PositionEntity start;
  final PositionEntity end;
  final double distance;
  RangeEntity({
    required this.start,
    required this.end,
    required this.distance,
  });

  factory RangeEntity.fromPositions({
    required PositionEntity start,
    required PositionEntity end,
  }) {
    final distance = start.distanceTo(end);
    return RangeEntity(
      start: start,
      end: end,
      distance: distance,
    );
  }
}
