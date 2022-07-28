// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../application/providers/google_maps_provider.dart';
import 'components/map_appbar_widget.dart';
import 'components/map_drawer_body_widget.dart';
import 'components/map_floating_action_button_widget.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<GoogleMapsProvider>(
      create: (context) => GoogleMapsProvider(),
      child: Consumer<GoogleMapsProvider>(
        builder: (_, provider, __) {
          return Scaffold(
            appBar: MapAppBarWidget(
              distanceBetweenMarkers: provider.distanceBetweenMarkers,
              markersAmount: provider.markers.length,
              closePointsOnMap: provider.closePointsOnMap,
              clearMap: provider.clearMap,
            ),
            drawer: provider.markers.isNotEmpty? MapDrawerBodyWidget(
              size: size,
              ranges: provider.getRanges(),
            ) : null,
            body: Stack(
              children: [
                GoogleMap(
                  polylines: provider.polylines,
                  markers: provider.markers,
                  mapType: MapType.satellite,
                  initialCameraPosition: provider.cameraPosition,
                  onMapCreated: provider.onMapCreated,
                  onTap: provider.addMarker,
                ),
              ],
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: provider.markers.isNotEmpty
                ? MapFloatingActionButtonWidget(
                    currentPosition: provider.currentPositionListener,
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
