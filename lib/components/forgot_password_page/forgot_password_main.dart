import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/rounded_text_button.dart';
import 'package:utusan_sarawak/components/common/rounded_text_form_field.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/validation_helpers.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordMain extends StatefulWidget {
  const ForgotPasswordMain({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordMain> createState() => ForgotPasswordMainState();
}

class ForgotPasswordMainState extends State<ForgotPasswordMain> {

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final user = GetIt.I<User>();

  late FocusNode emailFocusNode;

  bool emailValidated = false;
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
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
      });
    });
  }

  Size calculateTextSize(String text, ThemeOptions themeOptions) {
    TextStyle style = TextStyle(
      color: themeOptions.textColorOnSecondary,
      fontSize: user.textSizeScale * themeOptions.textSize2,
      fontWeight: FontWeight.w500,
    );
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final apiService = GetIt.I<ApiService>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                  "Lupa kata laluan?",
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textTitleSize1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const VerticalWhiteSpace(height: 5),
                Text(
                  "Masukkan alamat e-mel anda dan kami akan menghantar e-mel kepada anda dengan kata laluan sementara.",
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize3,
                    height: 1.3,
                  ),
                ),
                const VerticalWhiteSpace(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "E-mel",
                        style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize2,
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
                        ),
                      ),
                      const VerticalWhiteSpace(height: 30),
                      Center(
                        child: SizedBox(
                          width: user.textSizeScale < 1.2
                              ? 50.w
                              : user.textSizeScale < 1.5
                                ? 65.w
                                : 80.w,
                          child: isWaiting
                            ? Container(
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : RoundedTextButton(
                                text: Text(
                                  "Tetapkan semula kata laluan",
                                  style: TextStyle(
                                    color: themeOptions.textColorOnSecondary,
                                    fontSize: user.textSizeScale * themeOptions.textSize2,
                                    fontWeight: FontWeight.w500,

                                  ),
                                ),
                                onPressed: emailValidated
                                  ? () async{
                                      if (_formKey.currentState!.validate()) {
                                        Map<String, dynamic> postData = {"email" : _emailTextEditingController.text};
                                        setState(() {
                                          isWaiting = true;
                                        });
                                        await apiService.forgotPassword(postData).then((value) {
                                          setState(() {
                                            isWaiting = false;
                                          });
                                          final beamer = Beamer.of(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                surfaceTintColor: Colors.white,
                                                title: const Text("Temporary Password Sent",),
                                                content: Text("A temporary password has been sent to ${_emailTextEditingController.text}, "
                                                    "please login and proceed to change your password"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle: Theme.of(context).textTheme.labelLarge,
                                                    ),
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: themeOptions.primaryColor,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      beamer.popRoute();
                                                    },
                                                  ),
                                                ],
                                              );
                                            }
                                          );
                                        });
                                      }
                                    }
                                  : null,
                                foregroundColor: emailValidated ? themeOptions.primaryColor : themeOptions.secondaryColor,
                                backgroundColor: emailValidated ? themeOptions.primaryColor : themeOptions.secondaryColor,
                              ),
                        ),
                      ),
                      const VerticalWhiteSpace(height: 15),
                      Center(
                        child: InkWell(
                          onTap: (){
                            customBeamToNamed(context, 0.0, "/signin");
                          },
                          child: Text(
                            "Kembali ke Daftar masuk",
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

              ],
            ),
          ),
        ],
      ),
    );
  }
}
