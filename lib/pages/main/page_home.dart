import 'package:flutter/material.dart';

import '../../common/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Consts.marginPageHorizon),
        child: Text("Home"),
      ),
    );
  }
}
