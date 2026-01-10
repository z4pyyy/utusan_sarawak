import 'package:flutter/widgets.dart';

class LogoImage extends StatelessWidget {
  static const String _logoImagePath = 'assets/image/utusan_logo.png';
  final double? width;
  final double? height;

  const LogoImage({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _logoImagePath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
