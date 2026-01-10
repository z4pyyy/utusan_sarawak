import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utusan_sarawak/services/api_service.dart';

class User{
  int? id;
  int? userId;
  String? lastName;
  String? firstName;
  int? age;
  String? email;
  String? password;
  String country = "Malaysia";
  String? state;
  // String? token;
  bool isLogin = false;
  double textSizeScale;

  User({
    this.id,
    this.userId,
    this.lastName,
    this.firstName,
    this.age,
    this.email,
    this.password,
    this.state,
    // this.token,
    required this.textSizeScale,
  });

  void login(Map<String, dynamic> userDetails, String userEmail) async{
    isLogin = true;
    id = int.parse(userDetails['id']);
    userId = int.parse(userDetails['user_id']);
    firstName = userDetails['first_name'];
    lastName = userDetails['last_name'];
    age = int.parse(userDetails['age']);
    state = userDetails['country'];
    email = userEmail;
  }

  void rememberLogin(String username, String password) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime expireAt = DateTime.now().add(const Duration(days: 90));

    prefs.setString("username", username);
    prefs.setString("password", password);
    prefs.setString("expireAt", expireAt.toString());
  }

  void logout() async{
    isLogin = false;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("password");
    prefs.remove("expireAt");
  }

}