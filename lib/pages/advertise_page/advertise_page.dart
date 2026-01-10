import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/advertise_page/advertise_page_main.dart';
import 'package:utusan_sarawak/components/signup_page/signup_app_bar.dart';

class AdvertisePage extends StatefulWidget {
  const AdvertisePage({Key? key}) : super(key: key);

  @override
  State<AdvertisePage> createState() => AdvertisePageState();
}

class AdvertisePageState extends State<AdvertisePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SignupAppBar(width: MediaQuery.of(context).size.width, title: "Advertise with Us", shadow: false,),
      body: const AdvertisePageMain(),
    );
  }
}
