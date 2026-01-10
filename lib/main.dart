import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/routes/app_router_delegate.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/stores/reward_store/reward_store.dart';
import 'package:utusan_sarawak/themes/default_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/initialize_get_it.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final GlobalKey<BeamerState> beamerKey = GlobalKey<BeamerState>();

Future<void> checkRememberLogIn() async{
  final ApiService apiService = GetIt.I<ApiService>();
  final user = GetIt.I<User>();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString("username");
  final String? password = prefs.getString("password");
  final String? expireAt = prefs.getString("expireAt");

  if(username != null && password != null && expireAt != null){
    DateTime expireDate = DateTime.parse(expireAt);
    DateTime now = DateTime.now();

    if(now.isBefore(expireDate)){
      Map<String, dynamic> data = {
        "username" : username,
        "password" : password,
      };
      await apiService.signIn(data).then((signInResponse) {
        if(signInResponse['status'] == "success"){
          user.login(signInResponse['details'][0], username);
        }
      });
    }

  }

}

void logMessage(String message){
  FirebaseCrashlytics.instance.log(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  initializeGetIt();

  await checkRememberLogIn();

  final articleStore = GetIt.I<ArticleStore>();
  await articleStore.loadCategories();

  final rewardStore = GetIt.I<RewardStore>();
  await rewardStore.getRewards();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((value) =>
      runApp(
        ChangeNotifierProvider(
          create: (context) => ScrollPositionState(),
          child: UtusanSarawak(),
        ),
      ),
    );
}

class UtusanSarawak extends StatefulWidget {
  const UtusanSarawak({Key? key}) : super(key: key);

  @override
  UtusanSarawakState createState() => UtusanSarawakState();
}

class UtusanSarawakState extends State<UtusanSarawak> {

  @override
  void initState() {
    super.initState();
    registerDynamicLinkListener();
    handleDynamicLinks();
  }

  void handleDynamicLinks() async {
    final articleStore = GetIt.I<ArticleStore>();
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      String? articleId = deepLink.queryParameters['id'];
      if (articleId != null) {

        try {
          await articleStore.getArticles(true).then((value)
            => appRouterDelegate.beamToNamed("/article/${encodeString(articleId)}", replaceRouteInformation: false));
        } catch (e, stack) {
          logMessage("----- IL ERROR: Navigation failed: $e\n$stack");
        }

      }
    }
  }

  void registerDynamicLinkListener() async {
    final articleStore = GetIt.I<ArticleStore>();
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLink) {
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          String? articleId = deepLink.queryParameters['id'];
          if (articleId != null) {

            try {
              await articleStore.loadArticleByTitle(articleId).then((value)
                => appRouterDelegate.beamToNamed("/article/${encodeString(articleId)}", replaceRouteInformation: false));
            } catch (e, stack) {
              logMessage("----- ERROR: Navigation failed: $e\n$stack");
            }
            
          }
        }
      });

    }).onError((error) {
      logMessage("----- Error retrieving dynamic link: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Sizer(
        builder: (context, orientation, deviceType) => ThemeProvider(
          themes: [
            DefaultTheme(),
            AppTheme.light(),
          ],
          defaultThemeId: "default_theme",
          saveThemesOnChange: true,
          loadThemeOnInit: true,
          child: ThemeConsumer(
            child: Builder(
              builder: (context) {
                return MaterialApp.router(
                  title: "Utusan Sarawak",
                  theme: Theme.of(context),
                  routeInformationParser: BeamerParser(),
                  routerDelegate: appRouterDelegate,
                  backButtonDispatcher: BeamerBackButtonDispatcher(
                    delegate: appRouterDelegate,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
