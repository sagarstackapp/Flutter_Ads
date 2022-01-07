import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ads/common/constant/color_res.dart';
import 'package:flutter_ads/common/constant/image_res.dart';
import 'package:flutter_ads/common/constant/string_res.dart';
import 'package:flutter_ads/common/widget/common_elevated_button.dart';
import 'package:flutter_ads/common/widget/common_image_asset.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsScreen extends StatefulWidget {
  const GoogleAdsScreen({Key? key}) : super(key: key);

  @override
  GoogleAdsScreenState createState() => GoogleAdsScreenState();
}

class GoogleAdsScreenState extends State<GoogleAdsScreen> {
  InterstitialAd? interstitialAd;
  int numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  final BannerAd bannerAd = BannerAd(
    size: AdSize.largeBanner,
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
    createIntersitialAd();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AdWidget(ad: bannerAd..load())),
                CommonElevatedButton(
                  text: 'Show interstitial Ad',
                  onPressed: showInterstitialAd,
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void createIntersitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('$ad InterstitialAd loaded');
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error.');
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              createIntersitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createIntersitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createIntersitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }
}
