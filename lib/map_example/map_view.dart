import 'dart:async';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'api_strings.dart';

part 'model.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final completer = Completer<GoogleMapController>();

  static const CameraPosition cairo = CameraPosition(
    target: LatLng(29.2050735, 31.0041669),
    zoom: 13,
  );

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: cairo,
              markers: markers,
              onTap: (argument) {
                markers.add(
                  Marker(
                    markerId: MarkerId(
                      argument.longitude.toString(),
                    ),
                    position: LatLng(
                      argument.latitude,
                      argument.longitude,
                    ),
                    infoWindow: const InfoWindow(
                      title: "Marker 1",
                      snippet: "Hello from marker 1",
                    ),
                  ),
                );
                setState(() {});
              },
              onMapCreated: (GoogleMapController controller) {
                completer.complete(controller);
              },
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: TextFormField(
                onChanged: (value) async {
                  final res = await Dio().get(
                    "${ApiStrings.apiPath}?api_key=${ApiStrings.apiKey}&text=$value&size=${ApiStrings.apiSizeOfResult}&boundary.country=${ApiStrings.apiCountryName}",
                  );
                  final model = SearchData.fromJson(
                    res.data,
                  );
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(
                      16,
                      90,
                      16,
                      0,
                    ),
                    items: List.generate(
                      model.features.length,
                      (index) => PopupMenuItem(
                        child: Text(
                          model.features[index].name,
                        ),
                        onTap: () {
                          goTo(
                            model.features[index].lat.toDouble(),
                            model.features[index].lng.toDouble(),
                          );
                        },
                      ),
                    ),
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.sizeOf(context).width - 50,
                      maxWidth: MediaQuery.sizeOf(context).width - 50,
                      minHeight: 200,
                      maxHeight: 400,
                    ),
                  );
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text(
          "Go To Another Location",
        ),
        icon: const Icon(
          Icons.directions_boat,
        ),
      ),
    );
  }

  void goTo(double lat, double lng) async {
    final controller = await completer.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            lat,
            lng,
          ),
          zoom: 13,
        ),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId(
          lat.toString(),
        ),
        position: LatLng(
          lat.toDouble(),
          lng.toDouble(),
        ),
        infoWindow: const InfoWindow(
          title: "Marker 1",
          snippet: "Hello from marker 1",
        ),
      ),
    );
    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
