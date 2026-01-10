import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/services/api_service.dart';

class RewardStore{
  DateTime refreshTime = DateTime.now().toUtc();
  List<Map<String, dynamic>> rewardList = [];
  final ApiService apiService = GetIt.I<ApiService>();

  Future<List<Map<String, dynamic>>> getRewards() async {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    if(now.difference(refreshTime).inMinutes >= 10 || rewardList.isEmpty) {
      refreshTime = now;
      final data = await apiService.getRewards();
      rewardList = data;
      // rewardList.removeWhere((element) => element["status"] != "active");
    }

    return rewardList;
  }

}
