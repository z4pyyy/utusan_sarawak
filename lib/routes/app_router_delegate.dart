import 'package:beamer/beamer.dart';
import 'package:utusan_sarawak/components/article_detail_page/image_window.dart';
import 'package:utusan_sarawak/pages/advertise_page/advertise_page.dart';
import 'package:utusan_sarawak/pages/article_detail_page/article_detail_page.dart';
import 'package:utusan_sarawak/pages/article_tag_page/article_tag_page.dart';
import 'package:utusan_sarawak/pages/category_page/category_page.dart';
import 'package:utusan_sarawak/pages/edit_profile_page/edit_profile_page.dart';
import 'package:utusan_sarawak/pages/forgot_password_page/forgot_password_page.dart';
import 'package:utusan_sarawak/pages/profile_page/profile_page.dart';
import 'package:utusan_sarawak/pages/reward_detail_page/reward_detail_page.dart';
import 'package:utusan_sarawak/pages/reward_page/reward_page.dart';
import 'package:utusan_sarawak/pages/search_page/search_page.dart';
import 'package:utusan_sarawak/pages/signin_page/signin_page.dart';
import 'package:utusan_sarawak/pages/signup_page/signup_page.dart';
import 'package:utusan_sarawak/pages/support_and_legal_page/support_and_legal_page.dart';
import 'package:utusan_sarawak/pages/test_size_page/text_size_page.dart';
import 'package:utusan_sarawak/pages/top_story_page/top_story_page.dart';
import 'package:utusan_sarawak/pages/popular_page/popular_page.dart';
import 'package:utusan_sarawak/pages/topic_page/topic_page.dart';
import 'package:utusan_sarawak/pages/unsubscribe_form_page/unsubscribe_form_page.dart';
import 'package:utusan_sarawak/models/user/social_signup_data.dart';

final appRouterDelegate = BeamerDelegate(
  initialPath: "/top",
  locationBuilder: RoutesLocationBuilder(
    routes: {
      "/top": (context, state, data) => const TopStoryPage(),
      "/topic": (context, state, data) => const TopicPage(),
      "/popular": (context, state, data) => const PopularPage(),
      "/article/:title": (context, state, data) => ArticleDetailPage(
        title: state.pathParameters["title"] == null
            ? ""
            : state.pathParameters["title"]!,
      ),
      "/image/:url": (context, state, data) => ImageWindow(
        imageUrl: state.pathParameters["url"] == null
            ? ""
            : state.pathParameters["url"]!,
      ),
      "/category/:category": (context, state, data) => CategoryPage(
        category: state.pathParameters["category"] ?? "",
      ),
      "/tag/:tagId/:tagName": (context, state, data) => ArticleTagPage(
        tagId: int.parse(state.pathParameters["tagId"]!),
        tagName: state.pathParameters["tagName"]!,
      ),
      "/profile": (context, state, data) => const ProfilePage(),
      "/signin": (context, state, data) => const SigninPage(),
      "/signup": (context, state, data) => SignupPage(
        socialSignupData: data is SocialSignupData ? data : null,
      ),
      "/forgot-password": (context, state, data) => const ForgotPasswordPage(),
      "/support-and-legal": (context, state, data) => const SupportAndLegalPage(),
      "/edit-profile": (context, state, data) => const EditProfilePage(),
      "/text-size": (context, state, data) => const TextSizePage(),
      "/unsubscribe": (context, state, data) => const UnsubscribeFormPage(),
      "/reward": (context, state, data) => const RewardPage(),
      "/reward-detail/:rewardId": (context, state, data) => RewardDetailPage(
        rewardId: int.parse(state.pathParameters["rewardId"] ?? "1"),
      ),
      "/advertise": (context, state, data) => const AdvertisePage(),
      "/search": (context, state, data) => const SearchPage(),

    },
  ),
);
