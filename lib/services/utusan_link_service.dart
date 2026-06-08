import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';

class UtusanLinkService {
  UtusanLinkService._();
  static final UtusanLinkService _instance = UtusanLinkService._();
  factory UtusanLinkService() => _instance;

  static const String _base = 'https://utusan-app-utusan-sarawak.web.app';
  static const String _customScheme = 'utusan';
  static const String _customHost = 'news';

  static final Dio _client = Dio();

  static Uri get _createUrl => Uri.parse('$_base/api/links');

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  final Set<String> _handledIds = <String>{};
  bool _isInit = false;

  static Future<String?> createUtusanLink({
    required String link,
    String? type,
    Object? id,
    Map<String, dynamic>? meta,
  }) async {
    try {
      final body = <String, dynamic>{
        'link': link,
        if (type != null) 'type': type,
        if (id != null) 'id': id.toString(),
        if (meta != null) 'meta': meta,
      };

      final res = await _client.post(
        _createUrl.toString(),
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      if (res.statusCode != 200) {
        debugPrint(
          'UtusanLinkService: create link failed ${res.statusCode} ${res.data}',
        );
        return null;
      }

      final data = _asJsonMap(res.data);
      final shortLink = data?['shortLink']?.toString();
      if (shortLink == null || shortLink.isEmpty) {
        debugPrint('UtusanLinkService: shortLink missing: ${res.data}');
        return null;
      }
      return shortLink;
    } on DioException catch (e) {
      debugPrint(
        'UtusanLinkService: create link exception ${e.response?.statusCode} '
        '${e.response?.data}',
      );
      return null;
    } catch (e, st) {
      debugPrint('UtusanLinkService: create link exception $e\n$st');
      return null;
    }
  }

  static Future<String?> createArticleLink(Article article) {
    final description = _buildDescription(article);
    return createUtusanLink(
      link: article.link,
      type: 'news',
      id: article.id.toString(),
      meta: <String, dynamic>{
        'title': article.title,
        'description': description,
        'image': article.imagePath,
      },
    );
  }

  static String _buildDescription(Article article) {
    final shortTitle = article.shortTitle.trim();
    if (shortTitle.isNotEmpty) return shortTitle;

    if (article.content.isNotEmpty) {
      final summary = article.content.first['summary'] ??
          article.content.first['paragraph'] ??
          '';
      final stripped = _stripHtml(summary).trim();
      if (stripped.isNotEmpty) return stripped;
    }

    return article.title;
  }

  static String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  Future<void> init(BeamerDelegate router) async {
    if (_isInit) return;
    _isInit = true;

    debugPrint('UtusanLinkService: initializing link listener');

    _sub = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleIncomingUri(uri, router);
      },
      onError: (err) => debugPrint('UtusanLinkService: link stream error: $err'),
    );

    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        await _handleIncomingUri(initial, router);
      } else {
        debugPrint('UtusanLinkService: no initial link');
      }
    } catch (e) {
      debugPrint('UtusanLinkService: failed to handle initial URI: $e');
    }

    debugPrint('UtusanLinkService: initialized');
  }

  Future<void> _handleIncomingUri(Uri uri, BeamerDelegate router) async {
    debugPrint('UtusanLinkService: received URI: $uri');

    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();

    if (scheme != _customScheme || host != _customHost) {
      debugPrint('UtusanLinkService: ignoring URI ${uri.scheme}://${uri.host}');
      return;
    }

    final idStr = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    if (idStr == null || idStr.isEmpty) {
      debugPrint('UtusanLinkService: missing id in custom-scheme URI');
      return;
    }

    if (_handledIds.contains(idStr)) {
      debugPrint('UtusanLinkService: already handled id $idStr');
      return;
    }
    _handledIds.add(idStr);

    await _routeToArticleById(idStr, router);
  }

  Future<void> _routeToArticleById(String idStr, BeamerDelegate router) async {
    final id = int.tryParse(idStr);
    if (id == null) {
      debugPrint('UtusanLinkService: invalid article id $idStr');
      return;
    }

    final articleStore = GetIt.I<ArticleStore>();
    try {
      final article = await articleStore.loadSingleArticleById(id);
      articleStore.articleByTitle.removeWhere((item) => item.id == article.id);
      articleStore.articleByTitle.add(article);

      final encodedTitle = encodeString(article.title);
      debugPrint('UtusanLinkService: navigating to /article/$encodedTitle');
      router.beamToNamed('/article/$encodedTitle', replaceRouteInformation: false);
    } catch (e, st) {
      debugPrint('UtusanLinkService: failed to load article $idStr: $e\n$st');
    }
  }

  static Map<String, dynamic>? _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) return decoded;
    }
    return null;
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _handledIds.clear();
    _isInit = false;
  }
}
