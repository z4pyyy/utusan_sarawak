import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

/// Looks up the App Store listing by its numeric Apple ID instead of the
/// bundle ID, since bundle-ID lookup can miss listings depending on region
/// and review state.
class AppleIdAppStore extends UpgraderStore {
  AppleIdAppStore({required this.appleId});

  final String appleId;

  @override
  Future<UpgraderVersionInfo> getVersionInfo({
    required UpgraderState state,
    required Version installedVersion,
    required String? country,
    required String? language,
  }) async {
    final iTunes = ITunesSearchAPI();
    iTunes.debugLogging = state.debugLogging;
    iTunes.client = state.client;
    iTunes.clientHeaders = state.clientHeaders;

    final response = await iTunes.lookupById(appleId, country: country ?? 'US');

    String? appStoreListingURL;
    Version? appStoreVersion;
    Version? minAppVersion;
    String? releaseNotes;

    if (response != null) {
      final version = iTunes.version(response);
      if (version != null) {
        try {
          appStoreVersion = Version.parse(version);
        } catch (e) {
          if (state.debugLogging) {
            print('upgrader: AppleIdAppStore.appStoreVersion "$version" exception: $e');
          }
        }
      }
      appStoreListingURL = iTunes.trackViewUrl(response);
      releaseNotes = iTunes.releaseNotes(response);
      minAppVersion = iTunes.minAppVersion(response);
    }

    return UpgraderVersionInfo(
      installedVersion: installedVersion,
      appStoreListingURL: appStoreListingURL,
      appStoreVersion: appStoreVersion,
      minAppVersion: minAppVersion,
      releaseNotes: releaseNotes,
    );
  }
}
