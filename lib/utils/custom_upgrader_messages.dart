import 'package:upgrader/upgrader.dart';

class CustomUpgradeMessages extends UpgraderMessages {
  @override
  String message(UpgraderMessage messageKey) {
    if (languageCode == 'en') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return 'Versi baharu aplikasi Utusan Sarawak tersedia!';
        case UpgraderMessage.buttonTitleLater:
          return 'Kemas kini kemudian';
        case UpgraderMessage.buttonTitleUpdate:
          return 'Kemas kini sekarang';
        case UpgraderMessage.prompt:
          return 'Adakah anda ingin mengemaskini?';
        case UpgraderMessage.releaseNotes:
          return 'Release Notes';
        case UpgraderMessage.title:
          return 'Versi Aplikasi Baharu';
        default:
          return super.message(messageKey)!;
      }
    }
    // Messages that are not provided above can still use the default values.
    return super.message(messageKey)!;
  }
}