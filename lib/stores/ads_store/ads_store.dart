import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/services/api_service.dart';

class AdsStore{
  DateTime refreshTime = DateTime.now().toUtc();
  List<dynamic> adsList = [];
  List<dynamic> staticAdsList = [];
  final ApiService apiService = GetIt.I<ApiService>();
  int count = 0;
  int staticAdsCount = 0;
  int partialCount = 0;

  Future<List<dynamic>> getAds() async {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    if(now.difference(refreshTime).inMinutes >= 10 || adsList.isEmpty) {
      refreshTime = now;
      final data = await apiService.getAds();
      adsList = data['ads'];
      adsList.removeWhere((element) => element["status"] != "active" || element["image"] == null || element["image"].toString().isEmpty);
    }

    return adsList;
  }

  Future<Map<String, String>> getNextAds() async{
    Map<String, String> result = {};
    await getAds();

    if(adsList.isNotEmpty){
      result["image"] = adsList[count]['image'];
      result["url"] = adsList[count]['url'];
    }else{
      await getAds();
      result["image"] = adsList[count]['image'];
      result["url"] = adsList[count]['url'];
    }

    if(count >= adsList.length - 1){
      count = 0;
    }else{
      count++;
    }

    return result;
  }

  Future<List<Map<String, String>>> getAdsListPartial() async {
    List<Map<String, String>> result = [];
    List<dynamic> ads = await getAds();

    if (ads.isNotEmpty) {
      int numberOfAds = ads.length <= 5 ? ads.length : 5;

      for (int i = 0; i < numberOfAds; i++) {
        if(ads[partialCount]['image'] != null){
          result.add({
            "image": ads[partialCount]['image'],
            "url": ads[partialCount]['url'],
            "id": ads[partialCount]['id'],
          });
        }

        partialCount = (partialCount >= ads.length - 1) ? 0 : partialCount + 1;
      }
    }

    // print("----- RESULT RETURN $result");
    return result;
  }

  Future<List<dynamic>> getStaticAds() async {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    if(now.difference(refreshTime).inMinutes >= 10 || staticAdsList.isEmpty) {
      refreshTime = now;
      final data = await apiService.getStaticAds();
      staticAdsList = data['ads'];
      staticAdsList.removeWhere((element) => element["status"] != "active" || element["image"] == null || element["image"].toString().isEmpty);
    }

    return staticAdsList;
  }

  Future<Map<String, String>> getNextStaticAds() async{
    Map<String, String> result = {};
    await getStaticAds();
    print("--- GETTING NEXT STATIC ADS ---");
    print("--- LENGTH : ${staticAdsList.length} --- CURRENT INDEX : $staticAdsCount");

    if(staticAdsList.isNotEmpty){
      print("--- ACCESSING STATIC ADS: ${staticAdsList[staticAdsCount]['title']}");
      result["title"] = staticAdsList[staticAdsCount]['title'];
      result["image"] = staticAdsList[staticAdsCount]['image'];
      result["description"] = staticAdsList[staticAdsCount]['description'];
      result["url"] = staticAdsList[staticAdsCount]['url'];
    }else{
      await getStaticAds();
      result["title"] = staticAdsList[staticAdsCount]['title'];
      result["image"] = staticAdsList[staticAdsCount]['image'];
      result["description"] = staticAdsList[staticAdsCount]['description'];
      result["url"] = staticAdsList[staticAdsCount]['url'];
    }

    if(staticAdsCount >= staticAdsList.length - 1){
      staticAdsCount = 0;
    }else{
      staticAdsCount++;
    }

    return result;
  }

}
