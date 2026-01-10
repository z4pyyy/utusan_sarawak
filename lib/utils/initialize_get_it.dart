import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/stores/ads_store/ads_store.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:dio/dio.dart';
import 'package:utusan_sarawak/stores/reward_store/reward_store.dart';
import 'package:utusan_sarawak/utils/search_cache.dart';

void initializeGetIt() {
  GetIt.I.registerLazySingleton<SearchCache>(() => SearchCache());

  GetIt.I.registerSingleton<Dio>(
    Dio(
      BaseOptions(baseUrl: "https://utusansarawak.com.my/wp-json/wp/v2"),
    ),
  );

  GetIt.I.registerSingleton<ApiService>(
    ApiService(
      client: GetIt.I<Dio>(),
    ),
  );

  GetIt.I.registerSingleton<ArticleStore>(
    ArticleStore(
      client: GetIt.I<Dio>(),
    )
  );

  GetIt.I.registerSingleton<RewardStore>(RewardStore());

  GetIt.I.registerSingleton<AdsStore>(AdsStore());

  GetIt.I.registerSingleton<User>(User(
    textSizeScale: 1.0,
  ));

}
