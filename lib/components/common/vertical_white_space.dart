import 'package:flutter/widgets.dart';

class VerticalWhiteSpace extends StatelessWidget {
  const VerticalWhiteSpace({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height,);
  }
}
