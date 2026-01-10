import 'package:flutter/widgets.dart';

class HorizontalWhiteSpace extends StatelessWidget {
  const HorizontalWhiteSpace({super.key, required  this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width,);
  }
}
