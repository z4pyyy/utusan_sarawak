import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:utusan_sarawak/utils/device_layout_helper.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.index, this.showAllUnselected = false});

  final int index;
  final bool showAllUnselected;

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  static final Map<int, String> _bottomBarRouteMap = {
    0: "/top",
    1: "/search",
    2: "/reward",
    3: "/profile",
  };

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setCurrentIndex();
    // });
  }

  void setCurrentIndex() {
    final currentRoute = Beamer.of(
      context,
    ).currentBeamLocation.state.routeInformation.uri.toString();
    final index = _bottomBarRouteMap.keys.firstWhere(
          (key) => _bottomBarRouteMap[key] == currentRoute,
      orElse: () => 0,
    );
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);
    return Container(
        decoration: BoxDecoration(
          color: themeOptions.backgroundColor,
        ),
        child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(210, 210, 210, 1.0),
                    spreadRadius: 0,
                    blurRadius: 6),
              ],
            ),
            child: ClipRRect(
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                backgroundColor: themeOptions.whiteBackground,
                selectedItemColor: widget.showAllUnselected
                  ? themeOptions.iconColor
                  : themeOptions.iconColorSelected,
                unselectedItemColor: themeOptions.iconColor,
                showUnselectedLabels: true,
                selectedIconTheme: widget.showAllUnselected
                  ? IconTheme.of(context).copyWith(
                      color: themeOptions.iconColor,
                    )
                  : IconTheme.of(context).copyWith(
                      color: themeOptions.iconColorSelected,
                    ),
                unselectedIconTheme: IconTheme.of(context).copyWith(
                  color: themeOptions.iconColor,
                ),
                selectedLabelStyle: TextStyle(
                    fontSize: DeviceLayoutHelper.isTablet
                        ? themeOptions.textSize5Tablet
                        : themeOptions.textSize5),
                unselectedLabelStyle: TextStyle(
                    fontSize: DeviceLayoutHelper.isTablet
                        ? themeOptions.textSize5Tablet
                        : themeOptions.textSize5),
                items: [
                  BottomNavigationBarItem(
                      icon: const SizedBox(
                        width: 28,
                        height: 28,
                        child: Center(
                          child: Icon(Icons.newspaper, size: 26),
                        ),
                      ),
                      label: "Berita Utama",
                      backgroundColor: themeOptions.whiteBackground),
                  BottomNavigationBarItem(
                      icon: const SizedBox(
                        width: 28,
                        height: 28,
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 22),
                        ),
                      ),
                      label: "Cari",
                      backgroundColor: themeOptions.whiteBackground),
                  BottomNavigationBarItem(
                      icon: const SizedBox(
                        width: 28,
                        height: 28,
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.gift, size: 22),
                        ),
                      ),
                      label: "Ganjaran",
                      backgroundColor: themeOptions.whiteBackground),
                  BottomNavigationBarItem(
                      icon: const SizedBox(
                        width: 28,
                        height: 28,
                        child: Center(
                          child: Icon(Icons.account_circle_outlined, size: 26),
                        ),
                      ),
                      label: "Profil",
                      backgroundColor: themeOptions.whiteBackground),
                ],
                onTap: (value) {
                  setState(() {
                    _currentIndex = value;
                    scrollPositionState.needConsume = false;
                    Beamer.of(context).beamToNamed(_bottomBarRouteMap[value]!, replaceRouteInformation: false);
                  });
                },
              ),
            )
        )
    );
  }
}