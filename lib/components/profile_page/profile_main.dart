import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utusan_sarawak/components/common/block_container.dart';
import 'package:utusan_sarawak/components/common/custom_divider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/profile_page/account_detail_row.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/show_toast.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  State<ProfileMain> createState() => ProfileMainState();
}

class ProfileMainState extends State<ProfileMain> {

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    final beamer = Beamer.of(context);
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: themeOptions.secondaryBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalWhiteSpace(height: 20),
            InkWell(
              onTap: (){
                if(user.isLogin){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        title: const Text("Daftar Keluar"),
                        content: const Text("Are you sure you want to sign out?"),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: themeOptions.secondaryColor,
                              ),
                            ),
                            onPressed: (){
                              beamer.popRoute();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: themeOptions.primaryColor,
                              ),
                            ),
                            onPressed: (){
                              beamer.popRoute();
                              showFToast(message: "Logout successful", context: context);
                              setState(() {
                                user.logout();
                              });
                            },
                          ),
                        ],
                      );
                    }
                  );
                }else{
                  customBeamToNamed(context, 0.0, "/signin");
                }
              },
              child: BlockContainer(
                child: Text(
                  user.isLogin ? "Daftar Keluar" : "Daftar Masuk",
                  style: TextStyle(
                      fontSize: user.textSizeScale * themeOptions.textSize2,
                      color: themeOptions.primaryColor,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            if(user.isLogin)
              const VerticalWhiteSpace(height: 30),
            if(user.isLogin)
              BlockContainer(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User Profile",
                          style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize5,
                            fontWeight: FontWeight.w500,
                            color: themeOptions.iconColor,
                            fontFamily: "Serif",
                            letterSpacing: 1.1,
                            wordSpacing: 3,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            customBeamToNamed(context, 0.0, "/edit-profile");
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: user.textSizeScale * themeOptions.textSize3,
                              fontWeight: FontWeight.w500,
                              color: themeOptions.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalWhiteSpace(height: 20),
                    AccountDetailRow(label: "Name", value: "${user.firstName} ${user.lastName}"),
                    const VerticalWhiteSpace(height: 5),
                    const CustomDivider(),
                    const VerticalWhiteSpace(height: 5),
                    AccountDetailRow(label: "Umur", value: "${user.age}"),
                    const VerticalWhiteSpace(height: 5),
                    const CustomDivider(),
                    const VerticalWhiteSpace(height: 5),
                    AccountDetailRow(label: "Negara", value: "${user.state}, ${user.country}"),
                    const VerticalWhiteSpace(height: 5),
                    const CustomDivider(),
                    const VerticalWhiteSpace(height: 5),
                    AccountDetailRow(label: "E-mel", value: user.email!),
                    const VerticalWhiteSpace(height: 10),
                  ],
                ),
              ),
            const VerticalWhiteSpace(height: 30),
            BlockContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Aturan Aplikasi",
                    style: TextStyle(
                      fontSize: user.textSizeScale * themeOptions.textSize5,
                      fontWeight: FontWeight.w500,
                      color: themeOptions.iconColor,
                      fontFamily: "Serif",
                      letterSpacing: 1.1,
                      wordSpacing: 3,
                    ),
                  ),
                  const VerticalWhiteSpace(height: 20),
                  InkWell(
                    onTap: (){
                      customBeamToNamed(context, 0.0, "/text-size");
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Saiz Teks",
                          style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize2,
                            color: themeOptions.textColor,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ],
              )
            ),
            const VerticalWhiteSpace(height: 30),
            BlockContainer(
              child: InkWell(
                onTap: (){
                  customBeamToNamed(context, 0.0, "/support-and-legal");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sokongan aplikasi",
                      style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize2,
                        color: themeOptions.textColor,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
            const VerticalWhiteSpace(height: 30),
            BlockContainer(
              child: InkWell(
                onTap: (){
                  final Uri url = Uri(
                    scheme: "mailto",
                    path: 'apps@utusansarawak.com.my',
                    queryParameters: {
                      "subject" : "",
                      "body" : ""
                    },
                  );
                  _launchUrl(url);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Maklum Balas",
                      style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize2,
                        color: themeOptions.textColor,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
            const VerticalWhiteSpace(height: 30),
            BlockContainer(
              child: InkWell(
                onTap: (){
                  customBeamToNamed(context, 0.0, "/advertise");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Iklan bersama kami",
                      style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize2,
                        color: themeOptions.textColor,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
            const VerticalWhiteSpace(height: 30),
            if(user.isLogin)
              BlockContainer(
                child: InkWell(
                  onTap: () async{
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          title: const Text("Berhenti Melanggan"),
                          content: const Text("Are you sure you want to unsubscribe to Utusan Sarawak? Your account will be permanently deleted."),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: Theme.of(context).textTheme.labelLarge,
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: themeOptions.secondaryColor,
                                ),
                              ),
                              onPressed: () {
                                beamer.popRoute();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: Theme.of(context).textTheme.labelLarge,
                              ),
                              child: Text(
                                'Unsubscribe',
                                style: TextStyle(
                                  color: themeOptions.primaryColor,
                                ),
                              ),
                              onPressed: () async{
                                customBeamToNamed(context, 0.0, "/unsubscribe");
                              },
                            ),
                          ],
                        );
                      }
                    );

                  },
                  child: Text(
                    "Berhenti Melanggan",
                    style: TextStyle(
                      fontSize: user.textSizeScale * themeOptions.textSize2,
                      color: themeOptions.primaryColor,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            if(user.isLogin)
              const VerticalWhiteSpace(height: 20),
            const VerticalWhiteSpace(height: 30),
          ],
        ),
      ),
    );
  }
}
