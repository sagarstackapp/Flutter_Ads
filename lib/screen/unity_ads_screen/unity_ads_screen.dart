import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ads/common/constant/color_res.dart';
import 'package:flutter_ads/common/constant/image_res.dart';
import 'package:flutter_ads/common/constant/string_res.dart';
import 'package:flutter_ads/common/widget/common_image_asset.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

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
      listener: (state, args) => log('Init Listener: $state => $args'),
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
                    placementId: "banner_placement_id",
                    listener: (state, args) {
                      log('Banner Listener: $state => $args');
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
