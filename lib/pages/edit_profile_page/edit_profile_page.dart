import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/edit_profile_page/edit_profile_main.dart';
import 'package:utusan_sarawak/components/signup_page/signup_app_bar.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.whiteBackground,
      appBar: SignupAppBar(width: MediaQuery.of(context).size.width, title: "Edit Profile",),
      body: const EditProfileMain(),
    );
  }
}
