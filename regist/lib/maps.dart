import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kpostal/kpostal.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:regist/result_page.dart';
import 'package:regist/staticValue/static_value.dart';
import 'package:regist/viewmodel/booked_view_model.dart';

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

  String? postCode;
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
    String id = postCode!;
    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    var bookedViewModel = context.watch<BookedViewModel>();
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.28,
              minHeight: MediaQuery.of(context).size.height * 0.28,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Column(
                    children: [
                      searchBox(
                          context: context,
                          label: StaticValues.mapSearchBox1,
                          location: bookedViewModel.from,
                          controller: _startController),
                      const SizedBox(height: 10),
                      searchBox(
                          context: context,
                          label: StaticValues.mapSearchBox2,
                          location: bookedViewModel.destination,
                          controller: _destinationController),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          completeButton(context, bookedViewModel),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextField searchBox({
    required BuildContext context,
    required String label,
    required String location,
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

  TextButton completeButton(
      BuildContext context, BookedViewModel bookedViewModel) {
    return TextButton(
      onPressed: () {
        if (_startController.text.isEmpty != true &&
            _destinationController.text.isEmpty != true) {
          bookedViewModel.from = _startController.text;
          bookedViewModel.destination = _destinationController.text;
          _showBottomSheet(context, bookedViewModel);
          // print("${bookedViewModel.from}, ${bookedViewModel.destination}");
        } else if (_startController.text.isEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(StaticValues.warningMessage1),
            ),
          );
        } else if (_destinationController.text.isEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(StaticValues.warningMessage2),
            ),
          );
        }
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

void toResult(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return const ResultPage();
      },
    ),
  );
}

void _showBottomSheet(BuildContext context, BookedViewModel bookedViewModel) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.car_rental_outlined),
            trailing: const Text(
              "00000원",
              style: TextStyle(fontSize: 36),
            ),
            title: const Text(
              StaticValues.option1,
              style: TextStyle(fontSize: 36),
            ),
            onTap: () {
              bookedViewModel.transport = StaticValues.option1;
              bookedViewModel.fee = "00000";
              toResult(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental),
            trailing: const Text(
              "00000원",
              style: TextStyle(fontSize: 36),
            ),
            title: const Text(
              StaticValues.option2,
              style: TextStyle(fontSize: 36),
            ),
            onTap: () {
              bookedViewModel.transport = StaticValues.option2;
              bookedViewModel.fee = "00000";
              toResult(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental_outlined),
            trailing: const Text(
              "00000원",
              style: TextStyle(fontSize: 36),
            ),
            title: const Text(
              StaticValues.option3,
              style: TextStyle(fontSize: 36),
            ),
            onTap: () {
              bookedViewModel.transport = StaticValues.option3;
              bookedViewModel.fee = "00000";
              toResult(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental_sharp),
            trailing: const Text(
              "00000원",
              style: TextStyle(fontSize: 36),
            ),
            title: const Text(
              StaticValues.option4,
              style: TextStyle(fontSize: 36),
            ),
            onTap: () {
              bookedViewModel.transport = StaticValues.option4;
              bookedViewModel.fee = "00000";
              toResult(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text(
              StaticValues.cancel,
              style: TextStyle(fontSize: 36),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
