import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createDynamicLink(String articleId) async {
  String encodedLink = Uri.encodeFull("https://utusansarawak.com.my/article?id=$articleId");
  // final DynamicLinkParameters parameters = DynamicLinkParameters(
  //   uriPrefix: 'https://utusansarawak.page.link',
  //   link: Uri.parse('$encodedLink&apn=com.qm.utusan_sarawak&afl=https://play.google.com/store/apps/details?id=com.qm.utusan_sarawak'),
  //
  //   androidParameters: const AndroidParameters(
  //     packageName: 'com.qm.utusan_sarawak',
  //     minimumVersion: 1,
  //   ),
  //   iosParameters: const IOSParameters(
  //     bundleId: 'com.qm.utusan_sarawak.ios',
  //     appStoreId: 'YOUR_APP_STORE_ID',
  //   ),
  //
  // );

  final dynamicLinkParams = DynamicLinkParameters(
    link: Uri.parse(encodedLink),
    uriPrefix: "https://utusansarawak.page.link",
    androidParameters: const AndroidParameters(packageName: "com.qm.utusan_sarawak"),
    iosParameters: const IOSParameters(bundleId: "com.qm.utusan_sarawak"),
  );

  final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  return dynamicLink.shortUrl.toString();
}