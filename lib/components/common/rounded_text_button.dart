import 'package:utusan_sarawak/utils/device_layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedTextButton extends StatelessWidget {
  final Text text;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;

  const RoundedTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor,
    this.borderSide,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: FittedBox(
        child: text,
      ),
    );
  }

  @protected
  ButtonStyle get buttonStyle {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        padding ??
            EdgeInsets.symmetric(
              vertical: DeviceLayoutHelper.isTablet ? 8.sp : 10.sp,
              horizontal: 10.sp
            ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            DeviceLayoutHelper.isTablet ? 7.sp : 9.sp,
          ),
          side: borderSide ?? BorderSide.none,
        ),
      ),
    );
  }
}
