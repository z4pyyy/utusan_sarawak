import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utusan_sarawak/components/common/custom_divider.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/rounded_text_button.dart';
import 'package:utusan_sarawak/components/common/rounded_text_form_field.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/signup_page/signup_description.dart';
import 'package:utusan_sarawak/enums/status.dart';
import 'package:utusan_sarawak/models/user/social_signup_data.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/show_toast.dart';
import 'package:utusan_sarawak/utils/validation_helpers.dart';
import 'package:sizer/sizer.dart';

class SignupMain extends StatefulWidget {
  final SocialSignupData? socialSignupData;

  const SignupMain({Key? key, this.socialSignupData}) : super(key: key);

  @override
  State<SignupMain> createState() => SignupMainState();
}

class SignupMainState extends State<SignupMain> {

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _confirmFieldKey = GlobalKey<FormFieldState>();
  final _firstNameFieldKey = GlobalKey<FormFieldState>();
  final _lastNameFieldKey = GlobalKey<FormFieldState>();
  final _ageFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _firstNameTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _ageTextEditingController = TextEditingController();

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode firstNameFocusNode;
  late FocusNode confirmPasswordFocusNode;
  late FocusNode lastNameFocusNode;
  late FocusNode ageFocusNode;

  bool buttonAllowed = false;
  bool emailValidated = false;
  bool passwordValidated = false;
  bool firstNameValidated = false;
  bool confirmPasswordValidated = false;
  bool lastNameValidated = false;
  bool ageValidated = false;
  bool isChecked = false;

  bool get _isSocialSignup => widget.socialSignupData != null;

  final selectState = [
    "Johor",
    "Kedah",
    "Kelantan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Penang",
    "Perak",
    "Perlis",
    "Sabah",
    "Sarawak",
    "Selangor",
    "Terengganu"
  ];
  String _currentSelectedState = "Sarawak";
  final String _currentSelectedCountry = "Malaysia";
  String errorMessage = "";

  void checkButtonAllowed(){
    if(emailValidated && passwordValidated && firstNameValidated &&
        lastNameValidated && confirmPasswordValidated && ageValidated && isChecked){
      buttonAllowed = true;
    }else{
      errorMessage = "";
      if(!emailValidated){
        errorMessage = "- Please fill in a valid email";
      }
      if(!passwordValidated || !confirmPasswordValidated){
        if(errorMessage != ""){
          errorMessage = "$errorMessage\n";
        }
        errorMessage = "$errorMessage- Please fill in a valid password";
      }
      if(!firstNameValidated || !lastNameValidated){
        if(errorMessage != ""){
          errorMessage = "$errorMessage\n";
        }
        errorMessage = "$errorMessage- Please fill in a valid name";
      }
      if(!ageValidated){
        if(errorMessage != ""){
          errorMessage = "$errorMessage\n";
        }
        errorMessage = "$errorMessage- Please fill in a valid age";
      }
      if(!isChecked){
        if(errorMessage != ""){
          errorMessage = "$errorMessage\n";
        }
        errorMessage = "$errorMessage- Please check the box to agree to our T&C and Disclaimer";
      }
      buttonAllowed = false;

      // print("ERROR MESSAGE --------- $errorMessage");
    }
  }

  Future<void> _launchUrl(String stringUrl) async {
    final Uri url = Uri.parse(stringUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void emailOnChange(){
    setState(() {
      emailValidated = false;
      if(_emailFieldKey.currentState!.validate()){
        emailValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void passwordOnChange(){
    setState(() {
      passwordValidated = false;
      if(_passwordFieldKey.currentState!.validate()){
        passwordValidated = true;
      }
      confirmPasswordValidated = false;
      if(_confirmFieldKey.currentState!.validate()){
        confirmPasswordValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void firstNameOnChange(){
    setState(() {
      firstNameValidated = false;
      if(_firstNameFieldKey.currentState!.validate()) {
        firstNameValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void lastNameOnChange(){
    setState(() {
      lastNameValidated = false;
      if(_lastNameFieldKey.currentState!.validate()){
        lastNameValidated = true;
      }
      checkButtonAllowed();
    });
  }

  void ageOnChange(){
    setState(() {
      ageValidated = false;
      if(_ageFieldKey.currentState!.validate()){
        ageValidated = true;
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
        if (!confirmPasswordFocusNode.hasFocus) {
          if(_confirmFieldKey.currentState!.validate()){
            confirmPasswordValidated = true;
          }else{
            confirmPasswordValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    confirmPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode.addListener(() {
      setState(() {
        if (!passwordFocusNode.hasFocus) {
          if(_passwordFieldKey.currentState!.validate()){
            passwordValidated = true;
          }else{
            passwordValidated = false;
          }
        }
        if (!confirmPasswordFocusNode.hasFocus) {
          if(_confirmFieldKey.currentState!.validate()){
            confirmPasswordValidated = true;
          }else{
            confirmPasswordValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    firstNameFocusNode = FocusNode();
    firstNameFocusNode.addListener(() {
      setState(() {
        if (!firstNameFocusNode.hasFocus) {
          if(_firstNameFieldKey.currentState!.validate()){
            firstNameValidated = true;
          }else{
            firstNameValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    lastNameFocusNode = FocusNode();
    lastNameFocusNode.addListener(() {
      setState(() {
        if (!lastNameFocusNode.hasFocus) {
          if(_lastNameFieldKey.currentState!.validate()){
            lastNameValidated = true;
          }else{
            lastNameValidated = false;
          }
        }
        checkButtonAllowed();
      });
    });
    ageFocusNode = FocusNode();
    ageFocusNode.addListener(() {
      setState(() {
        if (!ageFocusNode.hasFocus) {
          if(_ageFieldKey.currentState!.validate()){
            ageValidated = true;
          }else{
            ageValidated = false;
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
    _applySocialPrefill();
  }

  void _applySocialPrefill() {
    final socialData = widget.socialSignupData;
    if (socialData == null) {
      return;
    }

    if (socialData.email.isNotEmpty) {
      _emailTextEditingController.text = socialData.email;
      emailValidated = validateEmail(socialData.email) == null;
    }

    if (socialData.name != null && socialData.name!.trim().isNotEmpty) {
      final parts = socialData.name!.trim().split(RegExp(r"\\s+"));
      if (parts.isNotEmpty) {
        _firstNameTextEditingController.text = parts.first;
        firstNameValidated =
            validateStringNotEmpty(parts.first, "first name") == null;
      }
      if (parts.length > 1) {
        final lastName = parts.sublist(1).join(" ");
        _lastNameTextEditingController.text = lastName;
        lastNameValidated =
            validateStringNotEmpty(lastName, "last name") == null;
      }
    }

    _passwordTextEditingController.text = socialData.uid;
    _confirmPasswordTextEditingController.text = socialData.uid;
    passwordValidated = true;
    confirmPasswordValidated = true;

    checkButtonAllowed();
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalWhiteSpace(height: 10),
                const SignupDescription(),
                const VerticalWhiteSpace(height: 10),
                const CustomDivider(),
                const VerticalWhiteSpace(height: 10),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama diberi",
                        style: TextStyle(
                            fontSize:user.textSizeScale *  themeOptions.textSize1,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const VerticalWhiteSpace(height: 2),
                      SizedBox(
                        child: RoundedTextFormField(
                          focusNode: firstNameFocusNode,
                          formFieldKey: _firstNameFieldKey,
                          label: "",
                          isDense: true,
                          borderRadius: BorderRadius.circular(5.sp),
                          controller: _firstNameTextEditingController,
                          validator: (value) =>
                              validateStringNotEmpty(value, "first name"),
                          showTick: firstNameValidated,
                          onChanged: (value){
                            firstNameOnChange();
                          },
                        ),
                      ),
                      const VerticalWhiteSpace(height: 20),
                      Text(
                        "Nama keluarga",
                        style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize1,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const VerticalWhiteSpace(height: 2),
                      SizedBox(
                        child: RoundedTextFormField(
                          focusNode: lastNameFocusNode,
                          formFieldKey: _lastNameFieldKey,
                          label: "",
                          isDense: true,
                          borderRadius: BorderRadius.circular(5.sp),
                          controller: _lastNameTextEditingController,
                          validator: (value) =>
                              validateStringNotEmpty(value, "last name"),
                          showTick: lastNameValidated,
                          onChanged: (value){
                            lastNameOnChange();
                          },
                        ),
                      ),
                      const VerticalWhiteSpace(height: 20),
                      Text(
                        "Umur",
                        style: TextStyle(
                            fontSize:user.textSizeScale *  themeOptions.textSize1,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const VerticalWhiteSpace(height: 2),
                      SizedBox(
                        child: RoundedTextFormField(
                          focusNode: ageFocusNode,
                          formFieldKey: _ageFieldKey,
                          label: "",
                          isDense: true,
                          borderRadius: BorderRadius.circular(5.sp),
                          controller: _ageTextEditingController,
                          validator: validateAge,
                          showTick: ageValidated,
                          onChanged: (value){
                            ageOnChange();
                          },
                        ),
                      ),
                      const VerticalWhiteSpace(height: 20),

                      Text(
                        "Negara",
                        style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize1,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const VerticalWhiteSpace(height: 2),
                      SizedBox(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(),
                                errorStyle: TextStyle(color: Colors.redAccent, fontSize: user.textSizeScale * 16.0),
                                hintText: 'Select Country',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeOptions.textColor,
                                    width: 0.5.sp,
                                  ),
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedCountry,
                                  isDense: true,
                                  onChanged: null,
                                  items: ["Malaysia"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const VerticalWhiteSpace(height: 20),

                      Text(
                        "Negeri",
                        style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize1,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const VerticalWhiteSpace(height: 2),
                      SizedBox(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(),
                                errorStyle: TextStyle(color: Colors.redAccent, fontSize: user.textSizeScale * 16.0),
                                hintText: 'Select State',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeOptions.textColor,
                                    width: 0.5.sp,
                                  ),
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                              ),
                              isEmpty: _currentSelectedState == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedState,
                                  isDense: true,
                                  onChanged: (String? value) {
                                    setState(() {
                                      if(value != null) {
                                        _currentSelectedState = value;
                                        state.didChange(value);
                                      }
                                    });
                                  },
                                  items: selectState.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const VerticalWhiteSpace(height: 20),
                      Text(
                        "Alamat E-mel",
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
                            emailOnChange();
                          },
                        ),
                      ),
                      const VerticalWhiteSpace(height: 20),
                      if (!_isSocialSignup) ...[
                        Text(
                          "Kata laluan",
                          style: TextStyle(
                              fontSize:user.textSizeScale *  themeOptions.textSize1,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        const VerticalWhiteSpace(height: 2),
                        Text(
                          "Kata laluan mesti mengandungi sekurang-kurangnya:",
                          style: TextStyle(fontSize:user.textSizeScale *  themeOptions.textSize3,),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HorizontalWhiteSpace(width: 20,),
                            Text("\u2022", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),),
                            const HorizontalWhiteSpace(width: 10,),
                            Expanded(
                              child: Text(
                                "8 aksara",
                                style: TextStyle(
                                  fontSize: user.textSizeScale * themeOptions.textSize3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HorizontalWhiteSpace(width: 20,),
                            Text("\u2022", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),),
                            const HorizontalWhiteSpace(width: 10,),
                            Expanded(
                              child: Text(
                                "Huruf besar dan huruf kecil",
                                style: TextStyle(
                                  fontSize: user.textSizeScale * themeOptions.textSize3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HorizontalWhiteSpace(width: 20,),
                            Text("\u2022", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),),
                            const HorizontalWhiteSpace(width: 10,),
                            Expanded(
                              child: Text(
                                "1 nombor",
                                style: TextStyle(
                                  fontSize: user.textSizeScale * themeOptions.textSize3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HorizontalWhiteSpace(width: 20,),
                            Text("\u2022", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),),
                            const HorizontalWhiteSpace(width: 10,),
                            Expanded(
                              child: Text(
                                "1 simbol",
                                style: TextStyle(
                                  fontSize: user.textSizeScale * themeOptions.textSize3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VerticalWhiteSpace(height: 10),
                        SizedBox(
                          child: RoundedTextFormField(
                            focusNode: passwordFocusNode,
                            formFieldKey: _passwordFieldKey,
                            label: "",
                            isPasswordField: true,
                            isDense: true,
                            borderRadius: BorderRadius.circular(5.sp),
                            controller: _passwordTextEditingController,
                            validator: (value) => validatePassword(false, value),
                            onChanged: (value){
                              passwordOnChange();
                            },
                          ),
                        ),
                        const VerticalWhiteSpace(height: 20),
                        Text(
                          "Sahkan kata laluan",
                          style: TextStyle(
                              fontSize: user.textSizeScale * themeOptions.textSize1,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        const VerticalWhiteSpace(height: 2),
                        SizedBox(
                          child: RoundedTextFormField(
                            focusNode: confirmPasswordFocusNode,
                            formFieldKey: _confirmFieldKey,
                            label: "",
                            isPasswordField: true,
                            isDense: true,
                            borderRadius: BorderRadius.circular(5.sp),
                            controller: _confirmPasswordTextEditingController,
                            validator: (value) =>
                                validateConfirmPassword(value, _passwordTextEditingController.text),
                            onChanged: (value){
                              passwordOnChange();
                            },
                          ),
                        ),
                      ],
                      const VerticalWhiteSpace(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: isChecked,
                              checkColor: themeOptions.primaryColorLight,
                              activeColor: themeOptions.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  if(value != null) {
                                    isChecked = value;
                                    checkButtonAllowed();
                                  }
                                });
                              },
                            ),
                          ),
                          const HorizontalWhiteSpace(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Saya telah membaca dan bersetuju dengan ",
                                style: TextStyle(
                                  color: themeOptions.textColor,
                                  fontSize: user.textSizeScale * themeOptions.textSize3,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Terma & Syarat ",
                                    style: TextStyle(
                                      color: themeOptions.primaryColor,
                                      fontSize: user.textSizeScale * themeOptions.textSize3,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () async{
                                      await _launchUrl("https://utusansarawak.com.my/terms-and-conditions/");
                                    },
                                  ),
                                  TextSpan(
                                    text: "dan ",
                                    style: TextStyle(
                                      color: themeOptions.textColor,
                                      fontSize: user.textSizeScale * themeOptions.textSize3,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Penafian Utusan Sarawak",
                                    style: TextStyle(
                                      color: themeOptions.primaryColor,
                                      fontSize: user.textSizeScale * themeOptions.textSize3,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () async {
                                      await _launchUrl("https://utusansarawak.com.my/disclaimer/");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VerticalWhiteSpace(height: 20),
                      const VerticalWhiteSpace(height: 20),
                      Center(
                        child: SizedBox(
                          width: 30.w,
                          child: RoundedTextButton(
                            text: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: themeOptions.textColorOnSecondary,
                                fontSize: user.textSizeScale * themeOptions.textSize2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: !buttonAllowed
                              ? (){
                                  setState(() {
                                    checkButtonAllowed();
                                  });
                                  showFToast(
                                    message: errorMessage,
                                    context: context,
                                    maxLine: 6,
                                    toastSeconds: 4,
                                    status: Status.error
                                  );
                                }
                              : () async{
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    ApiService apiService = GetIt.I<ApiService>();
                                    Map<String, dynamic> data = {
                                      "email" : _emailTextEditingController.text,
                                      "password" : _passwordTextEditingController.text,
                                      "first_name" : _firstNameTextEditingController.text,
                                      "last_name" : _lastNameTextEditingController.text,
                                      "age" : int.parse(_ageTextEditingController.text),
                                      "country" : _currentSelectedState,
                                    };
                                    await apiService.signup(data).then((response) async{
                                      String responseMessage = response['message'];
                                      if(response['status'] == "success"){
                                        showFToast(
                                          context: context,
                                          status: Status.success,
                                          message: responseMessage,
                                        );
                                        Map<String, dynamic> data = {
                                          "username" : _emailTextEditingController.text,
                                          "password" : _passwordTextEditingController.text,
                                        };
                                        await apiService.signIn(data).then((signinResponse) {
                                          if(signinResponse['status'] == "success"){
                                            user.rememberLogin(_emailTextEditingController.text, _passwordTextEditingController.text);
                                            user.login(signinResponse['details'][0], _emailTextEditingController.text);
                                            customBeamToNamed(context, 0.0, "/top");
                                          }
                                        });
                                      }else{
                                        showFToast(
                                          context: context,
                                          status: Status.error,
                                          maxLine: 4,
                                          message: responseMessage,
                                        );
                                      }
                                    });

                                    // if(response['status'] == "success"){
                                    //   Fluttertoast.showToast(
                                    //     msg: "Signup Successful",
                                    //     toastLength: Toast.LENGTH_LONG,
                                    //     gravity: ToastGravity.BOTTOM,
                                    //     timeInSecForIosWeb: 1,
                                    //     backgroundColor: themeOptions.successColor,
                                    //     textColor: Colors.white,
                                    //     fontSize: user.textSizeScale * 16.0
                                    //   );
                                    //   beamer.beamToNamed("/top");
                                    // }else{
                                    //   Fluttertoast.showToast(
                                    //       msg: response['message'],
                                    //       toastLength: Toast.LENGTH_LONG,
                                    //       gravity: ToastGravity.BOTTOM,
                                    //       timeInSecForIosWeb: 1,
                                    //       backgroundColor: themeOptions.errorColor,
                                    //       textColor: Colors.white,
                                    //       fontSize: user.textSizeScale * 16.0
                                    //   );
                                    // }

                                  }
                                },
                            foregroundColor: buttonAllowed ? themeOptions.primaryColor : themeOptions.secondaryColor,
                            backgroundColor: buttonAllowed ? themeOptions.primaryColor : themeOptions.secondaryColor,
                          ),
                        ),
                      ),
                      const VerticalWhiteSpace(height: 15),

                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
