import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kpostal/kpostal.dart';
import 'package:location/location.dart';
import 'package:regist/reselvation.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => MapSampleState();
}

class MapSampleState extends State<Maps> {
  Location location = Location();
  LatLng? _latLng;
  CameraPosition? _kGooglePlex;
  final List<Marker> _marker = [];

  final CameraPosition _exeception =
      const CameraPosition(target: LatLng(37.3512, 126.5834), zoom: 17.5);

  String postCode = "";
  String address = "";
  dynamic latitude = "";
  dynamic longitude = "";
  late LatLng searchedPosition;
  late GoogleMapController _mapController;
  final _startController = TextEditingController();
  final _destinationController = TextEditingController();
  final Set<Polyline> _polylines = <Polyline>{};
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    Location.instance.onLocationChanged.listen(
      (LocationData currentLocation) async {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(
            () {
              _latLng =
                  LatLng(currentLocation.latitude!, currentLocation.longitude!);

              _kGooglePlex = CameraPosition(
                target: _latLng!,
                zoom: 17.5,
              );
              _marker.add(
                Marker(
                  markerId: const MarkerId("내 위치"),
                  draggable: true,
                  position: _latLng!,
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final List<Marker> markers = [];
  addMarker(cordinate) {
    // marker 여러개 사용시
    // int id = Random().nextInt(100);
    // 한 개의 마커만 사용
    // 마커 2개 사용하기
    String id = postCode;
    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex!,
            onMapCreated: (GoogleMapController controller) async {
              setState(() {
                _mapController = controller;
              });
            },
            // markers: Set.from(_marker),
            onTap: (cordinate) {
              _mapController.animateCamera(CameraUpdate.newLatLng(cordinate));
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Column(
                  children: [
                    searchBox(
                        context: context,
                        label: "출발지를 입력해주세요",
                        controller: _startController),
                    const SizedBox(height: 10),
                    searchBox(
                        context: context,
                        label: "도착지를 입력해주세요",
                        controller: _destinationController),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        completeButton(context),
                      ],
                    )
                  ],
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 650,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  TextField searchBox({
    required BuildContext context,
    String label = "출발지를 입력해주세요",
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KpostalView(
              useLocalServer: true,
              localPort: 1024,
              callback: (result) {
                postCode = result.postCode;
                address = result.address;
                latitude = result.latitude!.toString();
                longitude = result.longitude!.toString();
                searchedPosition = LatLng(result.latitude!, result.longitude!);
                _mapController
                    .animateCamera(CameraUpdate.newLatLng(searchedPosition));
                addMarker(searchedPosition);
                controller.text = address;
              },
            ),
          ),
        );
      },
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          prefixIcon: const Icon(Icons.search)),
    );
  }

  TextButton completeButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            // reselInfo.from = _startController.text;
            // reselInfo.destination = _destinationController.text;
            return const reselvation();
          },
        ));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      child: const Text(
        "다음",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
