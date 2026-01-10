import 'package:dio/dio.dart';
import 'package:utusan_sarawak/enums/status.dart';
import 'package:utusan_sarawak/utils/show_toast.dart';

class ApiService {
  final Dio client;
  // final String apiUrl = "${dotenv.env['API_URL']}";
  final String apiUrl = "https://utusansarawak.com.my/ads-cms";

  ApiService({required this.client});

  Future<dynamic> getAds() async {
    try {
      Response response = await client.get("$apiUrl/adsapi");
      return response.data;
    } on DioException catch (e) {
      // if (e.response?.data['message'] != null) {
      //   showToast(message: "Error while getting Ads data ${e.response!.data['message']}", status: Status.error);
      // }
      // showToast(message: "Error getting news articles", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> getStaticAds() async {
    try {
      Response response = await client.get("$apiUrl/staticadsapi");
      return response.data;
    } on DioException catch (e) {
      // if (e.response?.data['message'] != null) {
      //   showToast(message: "Error while getting Ads data ${e.response!.data['message']}", status: Status.error);
      // }
      // showToast(message: "Error getting news articles", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<List<Map<String, dynamic>>> getRewards() async {
    try {
      Response response = await client.get("$apiUrl/rewardapi");
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(
          (response.data as List).map(
                (item) => Map<String, dynamic>.from(item),
          ),
        );
      }
    } on DioException catch (e) {
      print("ERROR ----- $e");
    }

    List<Map<String, dynamic>> errorResult = [{}];
    return errorResult;
  }

  Future<dynamic> signup(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/signupController", data: formData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // showToast(message: "Error while getting Ads data ${e.response!.data}", status: Status.error);
        // print(e.response!.data);
      }
      //showToast(message: "Error while signing up, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> signIn(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/loginController", data: formData);
      return response.data;
    } on DioException catch (e) {
      // showToast(message: "Error while signing in, please try again");
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> unsubscribe(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/unsubscribeController", data: formData);
      return response.data;
    } on DioException catch (e) {
      // if (e.response?.data != null) {
      //   showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      // }
      // showToast(message: "Error while unsubscribing, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> forgotPassword(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/forgotPasswordController", data: formData);
      return response.data;
    } on DioException catch (e) {
      // if (e.response?.data != null) {
      //   showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      // }
      // print(e);
      // showToast(message: "Error while resetting password, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> editProfile(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/editProfileController", data: formData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      }
      // showToast(message: "Error while editing profile, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> adsClick(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/adsclick", data: formData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      }
      // showToast(message: "Error while editing profile, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }

  Future<dynamic> staticAdsClick(Map<String, dynamic> postData) async {
    try {
      final formData = FormData.fromMap(postData);
      Response response = await client.post("$apiUrl/staticadsclick", data: formData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // showToast(message: "Error while logging in: ${e.response!.data}", status: Status.error);
      }
      // showToast(message: "Error while editing profile, please try again", status: Status.error);
    }

    final errorResult = {};
    return errorResult;
  }



}
