import 'dart:developer';
import 'dart:io';

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
  NativeAd? nativeAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;
  int numInterstitialLoadAttempts = 0;
  int numRewardedAdLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

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
    createNativeAd();
    createIntersitialAd();
    createRewardedAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Current screen --> $runtimeType');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          StringResources.googleTitle,
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
                SizedBox(
                  height: 50,
                  child: AdWidget(ad: nativeAd!),
                ),
                const Spacer(),
                CommonElevatedButton(
                  text: 'Show interstitial Ad',
                  onPressed: showInterstitialAd,
                ),
                const SizedBox(height: 50),
                CommonElevatedButton(
                  text: 'Show Rewarded Ad',
                  onPressed: showRewardedAd,
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        child: AdWidget(ad: bannerAd..load()),
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
      ),
    );
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

  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          log('$ad RewardedAd loaded');
          rewardedAd = ad;
          numRewardedAdLoadAttempts = 0;
          interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load: $error.');
          numRewardedAdLoadAttempts += 1;
          rewardedAd = null;
          if (numRewardedAdLoadAttempts <= maxFailedLoadAttempts) {
            createIntersitialAd();
          }
        },
      ),
    );
  }

  void showRewardedAd() {
    if (rewardedAd == null) {
      log('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );
    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(
      onUserEarnedReward: (ad, reward) =>
          log('Reward data --> $ad : ${reward.amount} ${reward.type}'),
    );
    rewardedAd = null;
  }

  void createNativeAd() {
    nativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/2247696110',
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            // _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
      request: const AdRequest(),
    );
    nativeAd!.load();
  }
}
