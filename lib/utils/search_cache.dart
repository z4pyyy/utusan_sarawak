import 'package:utusan_sarawak/models/article/article.dart';

class SearchCache {
  Future<List<Article>>? lastSearchFuture;
  String lastQuery = '';
}