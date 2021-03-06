import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ads/common/constant/color_res.dart';
import 'package:flutter_ads/common/constant/image_res.dart';
import 'package:flutter_ads/common/constant/string_res.dart';
import 'package:flutter_ads/common/widget/common_elevated_button.dart';
import 'package:flutter_ads/common/widget/common_image_asset.dart';
import 'package:flutter_ads/screen/facebook_ads_screen/facebook_ads_screen.dart';
import 'package:flutter_ads/screen/google_ads_screen/google_ads_screen.dart';
import 'package:flutter_ads/screen/unity_ads_screen/unity_ads_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int val = -1;

  List<String> adsType = ['Google', 'Facebook', 'Unity', 'Mopub'];

  @override
  Widget build(BuildContext context) {
    log('Current screen --> $runtimeType');
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: const Text(StringResources.title)),
        body: Stack(
          children: [
            const CommonImageAsset(
              imageName: ImageResources.backgroundImage,
              width: double.infinity,
            ),
            SafeArea(
              maintainBottomViewPadding: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Please select ads type :',
                    style: TextStyle(
                      color: ColorResources.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 30),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: adsType.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            val = index;
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: index,
                              groupValue: val,
                              activeColor: ColorResources.green,
                              onChanged: (value) {
                                setState(() {
                                  val = int.parse(value.toString());
                                });
                              },
                            ),
                            Text(
                              adsType[index],
                              style: TextStyle(
                                color: val == index
                                    ? ColorResources.green
                                    : ColorResources.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (val >= 0) CommonElevatedButton(onPressed: goToAds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToAds() {
    if (val == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GoogleAdsScreen()),
      );
    } else if (val == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FacebookAdsScreen()),
        (route) => false,
      );
    } else if (val == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UnityAdsScreen()),
        (route) => false,
      );
    }
  }
}
