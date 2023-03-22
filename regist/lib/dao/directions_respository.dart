import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:regist/models/directions.model.dart';
import 'package:regist/staticValue/static_value.dart';

class DirectionsRepository {
  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({required LatLng origin, required LatLng destination}) async {
    final response = await _dio.get(
      StaticValues.baseUrl,
      queryParameters: {
        'origin': "${origin.latitude},${origin.longitude}",
        'destination': "${destination.latitude},${destination.longitude}",
        'key': "AIzaSyDfRiDcBG0T3nzEm-kOIV4lLxIr3DKhODs",
      },
    );

    if (response.statusCode == 200) {
      print(response.data);
      return Directions.fromMap(response.data);
    }
    throw Exception();
  }
}
