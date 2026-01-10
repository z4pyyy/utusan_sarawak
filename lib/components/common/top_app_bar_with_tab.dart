import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/custom_icon_button.dart';
import 'package:utusan_sarawak/components/common/logo_image.dart';
import 'package:utusan_sarawak/components/setting_page/setting_main.dart';
import 'package:utusan_sarawak/components/common/tab_generator.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class TopAppBarWithTab extends StatefulWidget implements PreferredSizeWidget{
  const TopAppBarWithTab({
    Key? key,
    required this.width,
    this.isReward = false,
  }) : super(key: key);

  final double height = 110;
  final double width;
  final bool isReward;

  @override
  State<TopAppBarWithTab> createState() => TopAppBarWithTabState();

  @override
  Size get preferredSize => Size(width, height);
}

class TopAppBarWithTabState extends State<TopAppBarWithTab> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return AppBar(
      toolbarHeight: widget.height,
      backgroundColor: Colors.white,
      forceMaterialTransparency: true,
      titleSpacing: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
              icon: Icons.settings_outlined,
              size: 30,
              onPressed: (){
                showModalBottomSheet<dynamic>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: themeOptions.secondaryBackgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)
                    ),
                  ),
                  builder: (BuildContext context){
                    return const SettingMain();
                  });
              }
          ),
          LogoImage(
              width: MediaQuery.of(context).size.width*0.5
          ),
          CustomIconButton(
            icon: Icons.settings_outlined,
            size: 30,
            onPressed: (){},
            hide: true,
          ),
        ]
      ),
      bottom: TabBar(
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.only(left: 0),
        tabs: widget.isReward ? getRewardTabs() : getTabs(),
        indicatorColor: themeOptions.primaryColor,
        labelColor: themeOptions.primaryColor,
        unselectedLabelColor: themeOptions.primaryColorUnselect,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}
