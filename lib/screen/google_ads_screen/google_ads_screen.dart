import 'dart:developer';

import 'package:flutter/material.dart';

class GoogleAdsScreen extends StatefulWidget {
  const GoogleAdsScreen({Key? key}) : super(key: key);

  @override
  GoogleAdsScreenState createState() => GoogleAdsScreenState();
}

class GoogleAdsScreenState extends State<GoogleAdsScreen> {
  @override
  Widget build(BuildContext context) {
    log('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(),
    );
  }
}
