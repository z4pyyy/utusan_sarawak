import 'package:shared_preferences/shared_preferences.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/components/common/rounded_text_button.dart';
import 'package:utusan_sarawak/components/common/rounded_text_form_field.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/enums/status.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:utusan_sarawak/utils/show_toast.dart';
import 'package:utusan_sarawak/utils/validation_helpers.dart';
import 'package:sizer/sizer.dart';

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
    super.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
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
                  onPressed: !buttonAllowed
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
                  foregroundColor: buttonAllowed ? themeOptions.primaryColor : themeOptions.secondaryColor,
                  backgroundColor: buttonAllowed ? themeOptions.primaryColor : themeOptions.secondaryColor,
                ),
              ),
            ),
            const VerticalWhiteSpace(height: 15),
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
