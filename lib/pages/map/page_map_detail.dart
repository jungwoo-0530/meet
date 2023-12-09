import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ya_meet/common/constants.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

class DetailMapPage extends StatefulWidget {
  const DetailMapPage({super.key});

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  bool _isLoading = true;

  late double latitude; // 위도
  late double longitude; // 경도

  @override
  void initState() {
    super.initState();

    latitude = 37.43296265331129;
    longitude = -122.08832357078792;

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MeetSubAppBar(
        title: "Map Detail",
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(Consts.marginPage),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(latitude, longitude), zoom: 17),
                ),
              ),
      ),
    );
  }
}
