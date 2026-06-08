import 'package:utusan_sarawak/services/utusan_link_service.dart';

Future<String> createDynamicLink(String articleId) async {
  final link = await UtusanLinkService.createArticleLink(articleId);
  if (link != null && link.isNotEmpty) return link;
  final encoded = Uri.encodeComponent(articleId);
  return 'https://utusansarawak.com.my/article?id=$encoded';
}
