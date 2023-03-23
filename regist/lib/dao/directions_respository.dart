import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:regist/models/directions_model.dart';

class DirectionsRepository {
  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections(
      {required LatLng origin, required LatLng destination}) async {
    final response = await _dio.get(
      dotenv.env['BASEURL']!,
      queryParameters: {
        'origin': "${origin.latitude},${origin.longitude}",
        'destination': "${destination.latitude},${destination.longitude}",
        'mode': "transit",
        'key': "AIzaSyBQ2IVl9B95UTTomzQMbnu0jbpngA3Za4s",
      },
    );

    if (response.statusCode == 200) {
      print(response.data);
      return Directions.fromMap(response.data);
    }
    throw Exception();
  }
}
