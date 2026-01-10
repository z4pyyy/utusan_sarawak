import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class AdvertisePageMain extends StatefulWidget {
  const AdvertisePageMain({Key? key}) : super(key: key);

  @override
  State<AdvertisePageMain> createState() => AdvertisePageMainState();
}

class AdvertisePageMainState extends State<AdvertisePageMain> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/utusan_logo_nobg.png",
                    fit: BoxFit.cover,
                    width: 80.w,
                  ),
                  const Text(
                    "Iklankan Bersama Kami. Merapatkan Jurang Hubungan dalam Pelaporan Berita.",
                  ),
                  const VerticalWhiteSpace(height: 20),
                  IntrinsicWidth(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(210, 210, 210, 1.0),
                                  spreadRadius: 0,
                                  blurRadius: 6),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.mail_outline_rounded, size: 28,),
                              HorizontalWhiteSpace(width: 10),
                              Text("apps@utusansarawak.com.my"),
                            ],
                          ),
                        ),
                        const VerticalWhiteSpace(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(210, 210, 210, 1.0),
                                  spreadRadius: 0,
                                  blurRadius: 6),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.phone, size: 28,),
                              HorizontalWhiteSpace(width: 10),
                              Text("082-424411"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              decoration: BoxDecoration(
                color: themeOptions.primaryColorLight.withOpacity(0.15),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Perkongsian Jenama",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                      "Maklumat bekerjasama dengan syarikat untuk menyampaikan berita dan mesej berkualiti "
                          "tinggi kepada pembaca dan pelanggan kami"
                  ),
                  const VerticalWhiteSpace(height: 20),
                  IntrinsicWidth(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(210, 210, 210, 1.0),
                                  spreadRadius: 0,
                                  blurRadius: 6),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.edit, size: 26,),
                              HorizontalWhiteSpace(width: 10),
                              Flexible(
                                child: Text("Penguasaan Isi & Bercerita"),
                              ),
                            ],
                          ),
                        ),
                        const VerticalWhiteSpace(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(210, 210, 210, 1.0),
                                  spreadRadius: 0,
                                  blurRadius: 6),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.store, size: 22,),
                              HorizontalWhiteSpace(width: 15),
                              Flexible(
                                child: Text("Pakar Acara dengan rekod prestasi yang terbukti"),
                              ),
                            ],
                          ),
                        ),
                        const VerticalWhiteSpace(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(210, 210, 210, 1.0),
                                  spreadRadius: 0,
                                  blurRadius: 6),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.briefcase, size: 22,),
                              HorizontalWhiteSpace(width: 15),
                              Flexible(
                                child: Text("Pembina hubungan jangka panjang"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Apa yang kami tawarkan?",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "Penyelesaian Pengiklanan",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalWhiteSpace(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, right: 10),
                          child: Column(
                            children: [
                              Text(
                                "Akan datang, Terokai Penyelesaian",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                              VerticalWhiteSpace(height: 20),
                              Text(
                                "Satu rangkaian lengkap perkhidmatan pemasaran dan acara yang disesuaikan dengan keperluan anda",
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/image/app_mockup.png",
                              fit: BoxFit.cover,
                              width: 100.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
