import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/components/category_page/category_page_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<CategoryPage> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.backgroundColor,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, isCategory: true, category: widget.category,),
      body: CategoryPageMain(category: widget.category),
      bottomNavigationBar: const BottomNavBar(index: 0, showAllUnselected: true,),
    );
  }
}
