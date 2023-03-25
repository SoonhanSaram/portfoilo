import 'dart:async';
import 'dart:ffi';

import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kpostal/kpostal.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:regist/models/directions_model.dart';
import 'package:regist/result_page.dart';
import 'package:regist/ui_modules/ui_modules.dart';
import 'package:regist/viewmodel/booked_view_model.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => MapSampleState();
}

class MapSampleState extends State<Maps> {
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  Double? _distance;
  late double lat1;
  late double lng1;
  late double lat2;
  late double lng2;
  late String locationOrigin = "";
  late String locationDestination = "";
  Location location = Location();
  LatLng? _latLng;
  CameraPosition? _kGooglePlex;
  final List<Marker> _marker = [];
  double distance = 0;
  final CameraPosition _exeception = const CameraPosition(target: LatLng(37.3512, 126.5834), zoom: 17.5);

  String? postCode;
  String address = "";
  dynamic latitude = "";
  dynamic longitude = "";
  late LatLng searchedPosition;
  late GoogleMapController _mapController;
  final _startController = TextEditingController();
  final _destinationController = TextEditingController();
  late Map<PolylineId, Polyline> polylines = {};
  late List<LatLng> latLng = [];
  PolylinePoints polylinePoints = PolylinePoints();
  final PolylineResult _polyResult = PolylineResult(points: []);

  Future<void> addPolyLine(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  // directions API 요청법
  // Future<void> getPolylines(TextEditingController startController, TextEditingController destinationController) async {
  //   DirectionsService.init("AIzaSyBlvArPjmzxG13H7YJTzglJK3KH4pU3ByQ");

  //   final directionsService = DirectionsService();

  //   final request = DirectionsRequest(
  //     origin: startController.text,
  //     destination: destinationController.text,
  //     travelMode: TravelMode.driving,
  //   );

  //   await directionsService.route(request, (DirectionsResult response, DirectionsStatus? status) {
  //     if (status == DirectionsStatus.ok) {
  //       print(response);
  //     } else {
  //       print("루트 에러, 결과 : $response , 상태 : $status");
  //     }
  //   });
  // }

  Future<void> _fitBounds() async {
    final LatLngBounds bounds = LatLngBounds(
      southwest: latLng[0],
      northeast: latLng[1],
    );
    final double lat1 = latLng[0].latitude;
    final double lon1 = latLng[0].longitude;
    final double lat2 = latLng[1].latitude;
    final double lon2 = latLng[1].longitude;
    final double centerLat = (lat1 + lat2) / 2;
    final double centerLon = (lon1 + lon2) / 2;
    final LatLng center = LatLng(centerLat, centerLon);
    final GoogleMapController mapController = await _controller.future;
    final CameraPosition cameraPosition = CameraPosition(target: center, zoom: 10);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<void> getperMission() async {
    bool serviceEnabled;
    PermissionStatus permissionGrandted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    if (!serviceEnabled) {
      return;
    }

    permissionGrandted = await location.hasPermission();
    if (permissionGrandted == PermissionStatus.denied) {
      permissionGrandted = await location.requestPermission();
    }
    if (permissionGrandted != PermissionStatus.granted) {
      return;
    }
    Timer(const Duration(seconds: 1), () {
      Location.instance.onLocationChanged.listen(
        (LocationData currentLocation) {
          if (currentLocation.latitude != null && currentLocation.longitude != null) {
            setState(
              () {
                _latLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);

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
          } else {
            _latLng = const LatLng(37.3512, 126.5834);
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getperMission();
  }

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  final List<Marker> markers = [];
  final List<String> _location = [];
  // directions 사용하기 위한 addMarker 함수
  Future<void> addMarker(String location, LatLng pos, BookedViewModel bookedViewModel) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _location.add(location);
        _origin = Marker(
          markerId: MarkerId(
            dotenv.env["MARKER_ORIGIN"]!,
          ),
          infoWindow: InfoWindow(title: dotenv.env["MARKER_ORIGIN"]!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          position: pos,
        );
        _destination = null;
        _info = null;
      });
    } else {
      _location.add(location);
      setState(() {
        _destination = Marker(
          markerId: MarkerId(
            dotenv.env["MARKER_DESTINATION"]!,
          ),
          infoWindow: InfoWindow(title: dotenv.env["MARKER_DESTINATION"]!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
      print("위치정보 ${_location[0]}, ${_location[1]}");
      final directions = await bookedViewModel.fetchDirections(
        origin: _origin!.position,
        destination: pos,
      );
      print("여기");
      setState(() => _info = bookedViewModel.directions);
    }
  }

  // 기존 addMarker 함수
  // addMarker(cordinate, address) async {
  // marker 여러개 사용시
  // int id = Random().nextInt(100);
  // 한 개의 마커만 사용
  // 마커 2개 사용하기
  // String id = address!;
  // setState(() {
  // markers.add(
  // Marker(
  // position: cordinate,
  // markerId: MarkerId(
  // id.toString(),
  // ),
  // infoWindow: InfoWindow(
  // title: id.toString(),
  // ),
  // ),
  // );
  // });
  // }

  @override
  Widget build(BuildContext context) {
    var bookedViewModel = context.watch<BookedViewModel>();
    double? distance = context.read<BookedViewModel>().calDistance;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId("overview_polyline"),
                  color: Colors.red,
                  width: 3,
                  points: _info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                )
            },
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex!,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);

              setState(() {
                _mapController = controller;
              });
              if (latLng.length >= 2) {
                _fitBounds();
              }
            },
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
                        label: dotenv.env["MAP_SEARCH_BOX1"]!,
                        location: locationOrigin,
                        locationOrigin: locationOrigin,
                        locationDestination: locationDestination,
                        controller: _startController,
                        bookedViewModel: bookedViewModel,
                        uiModules: UiModules(),
                      ),
                      const SizedBox(height: 10),
                      searchBox(
                        context: context,
                        label: dotenv.env["MAP_SEARCH_BOX2"]!,
                        location: locationDestination,
                        locationDestination: locationDestination,
                        locationOrigin: locationOrigin,
                        controller: _destinationController,
                        bookedViewModel: bookedViewModel,
                        uiModules: UiModules(),
                      ),
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
          ),
          distance?.isFinite == true && distance! > 0
              ? Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text("목적지까지 ${distance.toStringAsFixed(2)} KM"),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  TextField searchBox({
    required BuildContext context,
    required String label,
    required String location,
    required String locationOrigin,
    required String locationDestination,
    required TextEditingController controller,
    required BookedViewModel bookedViewModel,
    required UiModules uiModules,
  }) {
    return TextField(
      controller: controller,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KpostalView(
              useLocalServer: true,
              localPort: 1024,
              callback: (result) async {
                postCode = result.postCode;
                address = result.address;
                latitude = result.latitude!.toString();
                longitude = result.longitude!.toString();
                searchedPosition = LatLng(result.latitude!, result.longitude!);
                _mapController.animateCamera(CameraUpdate.newLatLng(searchedPosition));

                controller.text = address;
                addMarker(address, searchedPosition, bookedViewModel);
                setState(() {
                  latLng.add(searchedPosition);
                });
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

  TextButton completeButton(BuildContext context, BookedViewModel bookedViewModel) {
    return TextButton(
      onPressed: () {
        if (_startController.text.isEmpty != true && _destinationController.text.isEmpty != true) {
          bookedViewModel.from = _startController.text;
          bookedViewModel.destination = _destinationController.text;
          bookedViewModel.fare();
          _showBottomSheet(context, bookedViewModel);
        } else if (_startController.text.isEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(dotenv.env["WARNING_MESSAGE1"]!),
            ),
          );
        } else if (_destinationController.text.isEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(dotenv.env["WARING_MESSAGE2"]!),
            ),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      child: const Text(
        "다음",
        style: TextStyle(fontSize: 18, color: Colors.white),
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
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.35, maxHeight: MediaQuery.of(context).size.height * 0.35),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, i) {
            var fee = [];
            var titles = [];
            // fee.addAll(
            // [bookedViewModel.sedanRentFee, bookedViewModel.suvRentFee, bookedViewModel.limousineRentFee, "0000"],
            // );
            titles.addAll(
              [
                dotenv.env["OPTION1"]!,
                dotenv.env["OPTION2"]!,
                dotenv.env["OPTION3"]!,
                dotenv.env["OPTION4"]!,
              ],
            );
            if (i <= 3) {
              return ListTile(
                onTap: () => {
                  bookedViewModel.transport = titles[i],
                  bookedViewModel.fee = fee[i],
                  toResult(context),
                },
                leading: const Icon(
                  Icons.car_rental,
                  size: 50,
                ),
                title: Text(
                  titles[i],
                  style: const TextStyle(fontSize: 24),
                ),
                trailing: Text(
                  "${fee[i]}원",
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }
            return ListTile(
              onTap: () => {
                Navigator.pop(context),
              },
              leading: const Icon(
                Icons.cancel,
                size: 50,
              ),
              title: Text(
                dotenv.env["CANCEL"]!,
                style: const TextStyle(fontSize: 24),
              ),
            );
          },
        ),
      );
    },
  );
}

// try {
//                   if (_startController.text.isNotEmpty && _destinationController.text.isNotEmpty) {
//                     setState(() {
//                       if (latLng.length == 2) {
//                         distance = 0;

//                         late List latingArr;
//                         late String latlngStr;
//                         late List locationArr = [];
//                         try {
//                           for (var i = 0; i < latLng.length; i++) {
//                             latlngStr = latLng[i].toString();
//                             latingArr = latlngStr.split(
//                               RegExp(r'[,\s()]'),
//                             );
//                             locationArr.add([...latingArr]);
//                           }
//                         } catch (e) {
//                           print(e);
//                         }

//
//                         distance += uiModules.distance(lat1, lng1, lat2, lng2);

//                         // getPolylines(_startController, _destinationController);
//                         // print(getPolylines);
//                         // Polyline pathPolyline = Polyline(
//                         // polylineId: const PolylineId("path"),
//                         // points: polyResult.
//                         // .map(
//                         // (e) => LatLng(e.latitude, e.longitude),
//                         // )
//                         // .toList(),
//                         // width: 2,
//                         // color: Colors.orangeAccent);
//                         // print("path : $pathPolyline");
//                         // polylines.add(pathPolyline);
//                         // print("여기");
//                         // debugPrint(polylines.toString());
//                       } else if (latLng.length > 2) {
//                         distance = 0;
//                         latLng = [];
//                       }
//                     });
//                   }
//                 } catch (e) {
//                   print("setState 에러 $e");
//                 }
