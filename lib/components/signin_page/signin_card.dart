import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/components/common/rounded_text_button.dart';
import 'package:utusan_sarawak/components/common/rounded_text_form_field.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/enums/status.dart';
import 'package:utusan_sarawak/models/user/social_signup_data.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/show_toast.dart';
import 'package:utusan_sarawak/utils/validation_helpers.dart';

class SigninCard extends StatefulWidget {
  const SigninCard({super.key});

  @override
  State<SigninCard> createState() => SigninCardState();
}

class SigninCardState extends State<SigninCard> {

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  bool buttonAllowed = false;
  bool emailValidated = false;
  bool passwordValidated = false;
  bool _isLoading = false;

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _redirectToSocialSignup({
    required fb.User firebaseUser,
    required String provider,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    if (!mounted) return;

    customBeamToNamed(
      context,
      0.0,
      "/signup",
      data: SocialSignupData(
        uid: firebaseUser.uid,
        email: email,
        name: displayName,
        photo: photoUrl,
        provider: provider,
      ),
    );
  }

  Future<void> _processSocialSignIn({
    required fb.User firebaseUser,
    required String provider,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    final apiService = GetIt.I<ApiService>();
    final user = GetIt.I<User>();

    final signInData = {
      "username": email,
      "password": firebaseUser.uid,
    };

    try {
      final response = await apiService.signIn(signInData);

      if (response['status'] == 'success') {
        final token = response['token']?.toString();
        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }

        user.rememberLogin(email, firebaseUser.uid);

        if (response['details'] != null &&
            response['details'] is List &&
            (response['details'] as List).isNotEmpty) {
          user.login(response['details'][0], email);
        }

        if (mounted) {
          showFToast(
            context: context,
            status: Status.success,
            message: "Welcome back!",
          );
          customBeamToNamed(context, 0.0, "/top");
        }
      } else {
        await _redirectToSocialSignup(
          firebaseUser: firebaseUser,
          provider: provider,
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
        );
      }
    } catch (_) {
      await _redirectToSocialSignup(
        firebaseUser: firebaseUser,
        provider: provider,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      fb.UserCredential creds;

      if (kIsWeb) {
        final provider = fb.GoogleAuthProvider()
          ..addScope('email')
          ..setCustomParameters({'prompt': 'select_account'});

        creds = await fb.FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        final gUser = await googleSignIn.signIn();

        if (gUser == null) {
          setState(() => _isLoading = false);
          return;
        }

        final gAuth = await gUser.authentication;
        final credential = fb.GoogleAuthProvider.credential(
          idToken: gAuth.idToken,
          accessToken: gAuth.accessToken,
        );

        creds = await fb.FirebaseAuth.instance.signInWithCredential(credential);
      }

      final firebaseUser = creds.user;

      if (firebaseUser != null) {
        final email = firebaseUser.email;
        if (email == null || email.isEmpty) {
          throw Exception("Google account did not return an email.");
        }

        await _processSocialSignIn(
          firebaseUser: firebaseUser,
          provider: "google",
          email: email,
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
        );
      }
    } catch (_) {
      if (mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Google sign-in failed. Please try again.",
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithApple() async {
    if (_isLoading) return;

    final isAppleDevice = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    if (!kIsWeb && !isAppleDevice) {
      showFToast(
        context: context,
        status: Status.error,
        message: "Apple sign-in is only available on Apple devices.",
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      fb.UserCredential creds;
      String? appleEmail;
      String? appleDisplayName;

      if (kIsWeb) {
        final provider = fb.AppleAuthProvider()
          ..addScope('email')
          ..addScope('name');

        creds = await fb.FirebaseAuth.instance.signInWithPopup(provider);

        final profile = creds.additionalUserInfo?.profile;
        if (profile case final Map<String, dynamic> profileMap) {
          final givenName =
              (profileMap['given_name'] ?? profileMap['firstName']) as String?;
          final familyName =
              (profileMap['family_name'] ?? profileMap['lastName']) as String?;
          final parts = <String>[];

          if (givenName != null && givenName.trim().isNotEmpty) {
            parts.add(givenName.trim());
          }
          if (familyName != null && familyName.trim().isNotEmpty) {
            parts.add(familyName.trim());
          }

          if (parts.isNotEmpty) {
            appleDisplayName = parts.join(" ");
          }
        }
      } else {
        final rawNonce = _generateNonce();
        final nonce = _sha256OfString(rawNonce);

        final appleIsAvailable = await SignInWithApple.isAvailable();
        if (!appleIsAvailable) {
          throw Exception("Apple Sign-In is not available on this device.");
        }

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: const [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        final identityToken = appleCredential.identityToken;
        if (identityToken == null || identityToken.isEmpty) {
          throw Exception("Apple did not return a valid identity token.");
        }
        final authorizationCode = appleCredential.authorizationCode;

        appleEmail = appleCredential.email;
        final appleNames = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].whereType<String>().where((value) => value.trim().isNotEmpty).toList();

        if (appleNames.isNotEmpty) {
          appleDisplayName = appleNames.join(" ").trim();
        }

        final oauthCredential = fb.OAuthProvider("apple.com").credential(
          idToken: identityToken,
          accessToken: authorizationCode,
          rawNonce: rawNonce,
        );

        creds =
            await fb.FirebaseAuth.instance.signInWithCredential(oauthCredential);
      }

      final firebaseUser = creds.user;

      if (firebaseUser != null) {
        final email = firebaseUser.email ?? appleEmail;

        if (email == null || email.isEmpty) {
          throw Exception("Apple sign-in did not return an email.");
        }

        final resolvedName = (appleDisplayName?.isNotEmpty ?? false)
            ? appleDisplayName
            : firebaseUser.displayName;

        await _processSocialSignIn(
          firebaseUser: firebaseUser,
          provider: "apple",
          email: email,
          displayName: resolvedName,
          photoUrl: firebaseUser.photoURL,
        );
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled && mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Apple sign-in failed. Please try again.",
        );
      }
    } on fb.FirebaseAuthException catch (_) {
      if (mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Apple sign-in failed due to a FirebaseAuth error.",
        );
      }
    } catch (_) {
      if (mounted) {
        showFToast(
          context: context,
          status: Status.error,
          message: "Apple sign-in failed. Please try again.",
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void checkButtonAllowed(){
    if(emailValidated && passwordValidated){
      buttonAllowed = true;
    }else{
      buttonAllowed = false;
    }
  }

  void onEmailChange(){
    setState(() {
      if(_emailFieldKey.currentState!.validate()){
        emailValidated = true;
      }else{
        emailValidated = false;
      }
      checkButtonAllowed();
    });
  }

  void onPasswordChange(){
    setState(() {
      if(_passwordFieldKey.currentState!.validate()){
        passwordValidated = true;
      }else{
        passwordValidated = false;
      }
      checkButtonAllowed();
    });
  }

  void initializeFocusNode(){
    emailFocusNode = FocusNode();
    emailFocusNode.addListener(() {
      setState(() {
        if (!emailFocusNode.hasFocus) {
          if(_emailFieldKey.currentState!.validate()){
            emailValidated = true;
          }else{
            emailValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    passwordFocusNode = FocusNode();
    passwordFocusNode.addListener(() {
      setState(() {
        if (!passwordFocusNode.hasFocus) {
          if(_passwordFieldKey.currentState!.validate()){
            passwordValidated = true;
          }else{
            passwordValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
  }

  @override
  void initState(){
    super.initState();
    initializeFocusNode();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    final apiService = GetIt.I<ApiService>();

    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(210, 210, 210, 1.0),
              spreadRadius: 0,
              blurRadius: 10),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: themeOptions.whiteBackground,
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "E-mel",
              style: TextStyle(
                fontSize: user.textSizeScale * themeOptions.textSize1,
                fontWeight: FontWeight.w500
              ),
            ),
            const VerticalWhiteSpace(height: 2),
            SizedBox(
              child: RoundedTextFormField(
                focusNode: emailFocusNode,
                formFieldKey: _emailFieldKey,
                label: "",
                isDense: true,
                borderRadius: BorderRadius.circular(5.sp),
                controller: _emailTextEditingController,
                validator: validateEmail,
                showTick: emailValidated,
                onChanged: (value){
                  onEmailChange();
                },
              ),
            ),
            const VerticalWhiteSpace(height: 20),
            Text(
              "Kata laluan",
              style: TextStyle(
                  fontSize: user.textSizeScale * themeOptions.textSize1,
                  fontWeight: FontWeight.w500
              ),
            ),
            const VerticalWhiteSpace(height: 2),
            SizedBox(
              child: RoundedTextFormField(
                focusNode: passwordFocusNode,
                formFieldKey: _passwordFieldKey,
                label: "",
                isPasswordField: true,
                isDense: true,
                borderRadius: BorderRadius.circular(5.sp),
                controller: _passwordTextEditingController,
                validator: (value)
                  => validatePassword(true, value),
                onChanged: (value){
                  onPasswordChange();
                },
              ),
            ),
            const VerticalWhiteSpace(height: 20),
            Center(
              child: SizedBox(
                width: user.textSizeScale < 1.2
                    ? 30.w
                    : user.textSizeScale < 1.5
                      ? 35.w
                      : 40.w,
                child: RoundedTextButton(
                  text: Text(
                    "Daftar Masuk",
                    style: TextStyle(
                      color: themeOptions.textColorOnSecondary,
                      fontSize: user.textSizeScale * themeOptions.textSize2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: !buttonAllowed || _isLoading
                      ? null
                      : () async{
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            final user = GetIt.I<User>();
                            String email = _emailTextEditingController.text;
                            String password = _passwordTextEditingController.text;
                            Map<String, dynamic> data = {
                              "username" : email,
                              "password" : password,
                            };
                            await apiService.signIn(data).then((response) {
                              String responseMessage = response['message'];
                              bool loginSuccess = response['status'] == "success";
                              showFToast(
                                context: context,
                                status: loginSuccess
                                  ? Status.success
                                  : Status.error,
                                message: responseMessage,
                              );
                              if(loginSuccess){
                                user.rememberLogin(email, password);
                                user.login(response['details'][0], email);
                                customBeamToNamed(context, 0.0, "/top");
                              }

                            });

                          }
                        },
                  foregroundColor: buttonAllowed && !_isLoading
                      ? themeOptions.primaryColor
                      : themeOptions.secondaryColor,
                  backgroundColor: buttonAllowed && !_isLoading
                      ? themeOptions.primaryColor
                      : themeOptions.secondaryColor,
                ),
              ),
            ),
            const VerticalWhiteSpace(height: 15),
            Center(
              child: Text(
                "Atau",
                style: TextStyle(
                  fontSize: user.textSizeScale * themeOptions.textSize2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const VerticalWhiteSpace(height: 15),
            if (_isIOS) ...[
              Center(
                child: SizedBox(
                  width: 70.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: _isLoading ? null : _signInWithApple,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(FontAwesomeIcons.apple, size: 24),
                              const SizedBox(width: 12),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Continue with Apple",
                                    style: TextStyle(
                                      fontSize:
                                          user.textSizeScale * themeOptions.textSize2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const VerticalWhiteSpace(height: 10),
            ],
            if (_isAndroid) ...[
              Center(
                child: SizedBox(
                  width: 70.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(FontAwesomeIcons.google, size: 20),
                              const SizedBox(width: 12),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Continue with Google",
                                    style: TextStyle(
                                      fontSize:
                                          user.textSizeScale * themeOptions.textSize2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const VerticalWhiteSpace(height: 15),
            ],
            Center(
              child: InkWell(
                onTap: (){
                  customBeamToNamed(context, 0.0, "/forgot-password");
                },
                child: Text(
                  "Lupa kata laluan?",
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize2,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
