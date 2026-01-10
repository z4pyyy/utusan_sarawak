import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:utusan_sarawak/main.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/routes/app_router_delegate.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

bool checkUriNeedConsume(String uri){
  bool needConsume = false;
  List<String> needConsumeUri = [
    "/article",
    "/category",
    "/popular",
    "/top",
    "/topic",
    "/tag",
    "/image"
  ];

  int startIndex = uri.indexOf("/");
  int endIndex = uri.indexOf("/", 1);
  String extractedUri = "";

  if(endIndex == -1){
    extractedUri = uri.substring(startIndex, uri.length);
  }else{
    extractedUri = uri.substring(startIndex, endIndex);
  }

  extractedUri.trim();

  if(needConsumeUri.contains(extractedUri)){
    needConsume = true;
  }

  return needConsume;
}

void customBeamToNamed(BuildContext context, double scrollPosition, String toUri, {int tabIndex = 0, int subTabIndex = 0}){
  final beamer = Beamer.of(context);
  final scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);
  String fromUri = beamer.currentBeamLocation.state.routeInformation.uri.toString();

  if(checkUriNeedConsume(fromUri)){
    scrollPositionState.addScrollPosition(scrollPosition);
    scrollPositionState.addIndex(tabIndex);
    scrollPositionState.addSubIndex(subTabIndex);
  }

  scrollPositionState.needConsume = false;
  beamer.beamToNamed(toUri, replaceRouteInformation: false);
}

String encodeString(String input) {
  String encodedInput = Uri.encodeComponent(input);
  encodedInput = encodedInput.replaceAll("%2F", "REPLACEMENTFORSLASH");
  return encodedInput;
}

String decodeString(String input) {
  // String decodedInput = Uri.decodeComponent(input);
  String decodedInput = input.replaceAll("REPLACEMENTFORSLASH", "/");
  return decodedInput;
}

List<dynamic> getTagDetails(Article article){
  List<dynamic> tagDetails = [];
  final articleStore = GetIt.I<ArticleStore>();

  if(article.isTagLink){
    int tagId = article.tags[0];
    String tagName = "";

    for(Map<String, dynamic> e in articleStore.allTags){
      if(e["id"] == tagId){
        tagName = e["name"];
      }
    }

    tagDetails.add(tagId);
    tagDetails.add(tagName);
  }

  return tagDetails;
}