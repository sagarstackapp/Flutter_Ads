import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ads/common/constant/color_res.dart';
import 'package:flutter_ads/common/constant/image_res.dart';
import 'package:flutter_ads/common/constant/string_res.dart';
import 'package:flutter_ads/common/widget/common_image_asset.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsScreen extends StatefulWidget {
  const GoogleAdsScreen({Key? key}) : super(key: key);

  @override
  GoogleAdsScreenState createState() => GoogleAdsScreenState();
}

class GoogleAdsScreenState extends State<GoogleAdsScreen> {
  List<String> googleAdsType = ['Banner', 'Interstitial', 'Native', 'Rewarded'];
  final BannerAd bannerAd = BannerAd(
    size: AdSize.banner,
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => log('Ad loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        log('Ad failed to load: $error');
      },
      onAdOpened: (Ad ad) => log('Ad opened.'),
      onAdClosed: (Ad ad) => log('Ad closed.'),
      onAdImpression: (Ad ad) => log('Ad impression.'),
    ),
    request: const AdRequest(),
  );

  @override
  void initState() {
    bannerAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            StringResources.googleTitle,
            style: TextStyle(color: ColorResources.lightBlue),
          ),
        ),
        body: Stack(
          children: [
            const CommonImageAsset(
              imageName: ImageResources.backgroundImage,
              width: double.infinity,
            ),
            Column(
              children: [
                Expanded(child: AdWidget(ad: bannerAd..load())),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
