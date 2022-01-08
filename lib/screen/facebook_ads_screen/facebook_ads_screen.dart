import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/common/constant/color_res.dart';
import 'package:flutter_ads/common/constant/image_res.dart';
import 'package:flutter_ads/common/constant/string_res.dart';
import 'package:flutter_ads/common/widget/common_elevated_button.dart';
import 'package:flutter_ads/common/widget/common_image_asset.dart';

class FacebookAdsScreen extends StatefulWidget {
  const FacebookAdsScreen({Key? key}) : super(key: key);

  @override
  FacebookAdsScreenState createState() => FacebookAdsScreenState();
}

class FacebookAdsScreenState extends State<FacebookAdsScreen> {
  bool isInterstitialAdLoaded = false;
  bool isRewardedAdLoaded = false;

  @override
  void initState() {
    FacebookAudienceNetwork.init(
      testingId: 'e4463f1f-42eb-4b19-99b8-56af15237d9b',
      iOSAdvertiserTrackingEnabled: true,
    );
    loadInterstitialAd();
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
            StringResources.facebookTitle,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FacebookNativeAd(
                    placementId: '259211405667722_259212315667631',
                    adType: NativeAdType.NATIVE_AD_VERTICAL,
                    width: double.infinity,
                    height: 300,
                    backgroundColor: Colors.blue,
                    titleColor: Colors.white,
                    descriptionColor: Colors.white,
                    buttonColor: Colors.deepPurple,
                    buttonTitleColor: Colors.white,
                    buttonBorderColor: Colors.white,
                    listener: (result, value) {
                      log('Native Ad: $result --> $value');
                    },
                    keepExpandedWhileLoading: true,
                    expandAnimationDuraion: 1000,
                  ),
                  const Spacer(),
                  CommonElevatedButton(
                    text: 'Show Interstitial Ad',
                    onPressed: () {
                      FacebookInterstitialAd.showInterstitialAd();
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: '259211405667722_259212432334286',
      listener: (result, value) {
        log('Full screen Ad: $result --> $value');
        if (result == InterstitialAdResult.LOADED) {
          isInterstitialAdLoaded = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value['invalidated'] == true) {
          isInterstitialAdLoaded = false;
          loadInterstitialAd();
        }
      },
    );
  }
}
