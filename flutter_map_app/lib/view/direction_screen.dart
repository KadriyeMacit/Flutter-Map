import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key});

  @override
  State<DirectionScreen> createState() => DirectionScreenState();
}

class DirectionScreenState extends State<DirectionScreen> {
  GoogleMapController? mapController;
  final LatLng _startLocation =
      const LatLng(43.77474504822277, 11.261909855167868);
  final LatLng _endLocation =
      const LatLng(45.38002052011845, 12.342675855331597);
  final Set<Polyline> _polylines = <Polyline>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Direction Sample")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            CameraPosition(target: _startLocation, zoom: 7.0),
        polylines: _polylines,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getDirections();
  }

  void _getDirections() async {
    const String mainApi =
        "https://maps.googleapis.com/maps/api/directions/json?origin=";
    final String startPosition =
        "${_startLocation.latitude},${_startLocation.longitude}";
    const String destination = "&destination=";
    final String endPosition =
        "${_endLocation.latitude},${_endLocation.longitude}";
    const String key = "&key=";
    const String apiKey = "APIKEY";

    final Uri uri = Uri.parse(
        mainApi + startPosition + destination + endPosition + key + apiKey);
    var response = await http.get(uri);

    Map data = json.decode(response.body);
    String encodedString = data['routes'][0]['overview_polyline']['points'];
    List<LatLng> points = _decodePoly(encodedString);

    setState(() {
      _polylines.add(
        Polyline(
            polylineId: const PolylineId('route1'),
            visible: true,
            points: points,
            //width: 4,
            color: Colors.purple),
      );
    });
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng(lat / 1E5, lng / 1E5);
      points.add(point);
    }

    return points;
  }
}
