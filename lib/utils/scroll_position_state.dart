import 'package:flutter/cupertino.dart';

class ScrollPositionState extends ChangeNotifier {
  List<double> scrollPositions = [];
  bool needConsume = false;

  List<int> tabIndex = [];
  bool tabNeedConsume = false;

  List<int> subTabIndex = [];
  bool subTabNeedConsume = false;

  void addScrollPosition(double scrollPosition) {
    scrollPositions.add(scrollPosition);
    notifyListeners();
  }

  double consumeScrollPosition(){
    double scrollPosition = 0.0;
    if(scrollPositions.isNotEmpty){
      scrollPosition = scrollPositions.last;
      scrollPositions.removeLast();
    }
    needConsume = false;

    return scrollPosition;
  }

  void addIndex(int index) {
    tabIndex.add(index);
    notifyListeners();
  }

  int consumeIndex(){
    int index = 0;
    if(tabIndex.isNotEmpty){
      index = tabIndex.last;
      tabIndex.removeLast();
    }
    tabNeedConsume = false;

    return index;
  }

  void addSubIndex(int index) {
    subTabIndex.add(index);
    notifyListeners();
  }

  int consumeSubIndex(){
    int index = 0;
    if(subTabIndex.isNotEmpty){
      index = subTabIndex.last;
      subTabIndex.removeLast();
    }
    subTabNeedConsume = false;

    return index;
  }

}