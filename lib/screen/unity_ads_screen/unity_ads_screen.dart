import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ads/common/constant/color_res.dart';
import 'package:flutter_ads/common/constant/image_res.dart';
import 'package:flutter_ads/common/constant/string_res.dart';
import 'package:flutter_ads/common/widget/common_image_asset.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityAdsScreen extends StatefulWidget {
  const UnityAdsScreen({Key? key}) : super(key: key);

  @override
  UnityAdsScreenState createState() => UnityAdsScreenState();
}

class UnityAdsScreenState extends State<UnityAdsScreen> {
  @override
  void initState() {
    UnityAds.init(
      gameId: '3315378',
      testMode: false,
      onComplete: () => log('Initialization Complete'),
      onFailed: (error, errorMessage) =>
          log('Error is : ${error.name} & Message : $errorMessage'),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            StringResources.unityTitle,
            style: TextStyle(color: ColorResources.white),
          ),
        ),
        body: Stack(
          children: [
            const CommonImageAsset(
              imageName: ImageResources.backgroundImage,
              width: double.infinity,
            ),
            SafeArea(
              child: Column(
                children: [
                  UnityBannerAd(
                    placementId: 'testing',
                    onLoad: (placementId) => log('Banner loaded: $placementId'),
                    onClick: (placementId) =>
                        log('Banner clicked: $placementId'),
                    onFailed: (placementId, error, message) =>
                        log('Banner Ad $placementId failed: $error $message'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
