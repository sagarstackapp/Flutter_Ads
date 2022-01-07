import 'package:flutter/material.dart';
import 'package:flutter_ads/common/constant/color_res.dart';

class CommonElevatedButton extends StatelessWidget {
  final double width;
  final double margin;
  final double textSize;
  final double borderRadius;
  final String text;
  final Color textColor;
  final Color buttonColor;
  final VoidCallback? onPressed;

  const CommonElevatedButton(
      {Key? key,
      this.width = double.infinity,
      this.margin = 40,
      this.textSize = 20,
      this.borderRadius = 10,
      this.text = 'Go',
      this.textColor = ColorResources.white,
      this.buttonColor = ColorResources.lightBlue,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              fontSize: textSize,
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
          backgroundColor: MaterialStateProperty.all(buttonColor),
        ),
      ),
    );
  }
}
