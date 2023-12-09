import 'package:flutter/material.dart';
import 'package:ya_meet/common/constants.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

class AddMapPage extends StatefulWidget {
  const AddMapPage({super.key});

  @override
  State<AddMapPage> createState() => _AddMapPageState();
}

class _AddMapPageState extends State<AddMapPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MeetSubAppBar(
        title: "Map Add",
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(Consts.marginPage),
              ),
      ),
    );
  }
}
