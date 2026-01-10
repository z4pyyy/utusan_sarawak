import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/rounded_text_button.dart';
import 'package:utusan_sarawak/components/common/rounded_text_form_field.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/enums/status.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/show_toast.dart';
import 'package:utusan_sarawak/utils/validation_helpers.dart';
import 'package:sizer/sizer.dart';

class EditProfileMain extends StatefulWidget {
  const EditProfileMain({Key? key}) : super(key: key);

  @override
  State<EditProfileMain> createState() => EditProfileMainState();
}

class EditProfileMainState extends State<EditProfileMain> {

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

  bool buttonAllowed = true;
  bool emailValidated = true;
  bool passwordValidated = true;
  bool firstNameValidated = true;
  bool confirmPasswordValidated = true;
  bool lastNameValidated = true;
  bool ageValidated = true;

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

  late User user;

  void checkButtonAllowed(){
    if(emailValidated && passwordValidated && firstNameValidated &&
        lastNameValidated && confirmPasswordValidated && ageValidated){
      buttonAllowed = true;
    }else{
      buttonAllowed = false;
    }
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
    confirmPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode.addListener(() {
      setState(() {
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

  Future<Map<String, dynamic>> submitEditProfile(ApiService apiService, ThemeOptions themeOptions) async{
    user.firstName = _firstNameTextEditingController.text;
    user.lastName = _lastNameTextEditingController.text;
    user.age = int.parse(_ageTextEditingController.text);
    user.email = _emailTextEditingController.text;
    user.password = _passwordTextEditingController.text;
    user.state = _currentSelectedState;

    Map<String, dynamic> postData = {
      "id" : user.id,
      "user_id" : user.userId,
      "first_name" : user.firstName,
      "last_name" : user.lastName,
      "age" : user.age,
      "email" : user.email,
      "password" : user.password,
      "state" : user.state
    };

    final response = await apiService.editProfile(postData);
    return response;
  }

  void initializeForm(User user){
    _firstNameTextEditingController.text = user.firstName!;
    _lastNameTextEditingController.text = user.lastName!;
    _ageTextEditingController.text = user.age.toString();
    _emailTextEditingController.text = user.email!;
  }

  @override
  void initState() {
    super.initState();
    initializeFocusNode();
    user = GetIt.I<User>();
    initializeForm(user);
    _currentSelectedState = user.state ?? "Sarawak";
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final apiService = GetIt.I<ApiService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: themeOptions.whiteBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalWhiteSpace(height: 10),
                  Text(
                    "Nama diberi",
                    style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize1,
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
                    ),
                  ),
                  const VerticalWhiteSpace(height: 20),
                  Text(
                    "Umur",
                    style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize1,
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

                  // CSCPicker(
                  //   showStates: true,
                  //   showCities: false,
                  //   flagState: CountryFlag.DISABLE,
                  //   currentCountry: user.country,
                  //   currentState: user.state,
                  //   dropdownDecoration: BoxDecoration(
                  //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //       color: Colors.white,
                  //       border:
                  //       Border.all(color: themeOptions.textColor, width: 0.5.sp)
                  //   ),
                  //   countrySearchPlaceholder: "Country",
                  //   stateSearchPlaceholder: "State",
                  //   countryDropdownLabel: "Country",
                  //   stateDropdownLabel: "State",
                  //   cityDropdownLabel: "City",
                  //   disableCountry: false,
                  //   selectedItemStyle: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: user.textSizeScale * 14,
                  //   ),
                  //   dropdownHeadingStyle: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: user.textSizeScale * 17,
                  //       fontWeight: FontWeight.bold
                  //   ),
                  //   dropdownItemStyle: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: user.textSizeScale * 14,
                  //   ),
                  //   dropdownDialogRadius: 10.0,
                  //   searchBarRadius: 10.0,
                  //   onCountryChanged: (value) {
                  //     setState(() {
                  //       countryValue = value;
                  //       print(value);
                  //     });
                  //   },
                  //   onStateChanged: (value) {
                  //     setState(() {
                  //       stateValue = value;
                  //     });
                  //   },
                  // ),

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
                      readonly: true,
                      focusNode: emailFocusNode,
                      formFieldKey: _emailFieldKey,
                      label: "",
                      isDense: true,
                      borderRadius: BorderRadius.circular(5.sp),
                      controller: _emailTextEditingController,
                      validator: validateEmail,
                      showTick: false,
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
                  Text(
                    "Kata laluan mesti mengandungi sekurang-kurangnya:",
                    style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3,),
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
                      validator: (value) => validateEditPassword(false, value),
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
                    ),
                  ),
                  const VerticalWhiteSpace(height: 20),
                  Center(
                    child: SizedBox(
                      width: 30.w,
                      child: RoundedTextButton(
                        text: Text(
                          "Update",
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    final beamer = Beamer.of(context);
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      title: const Text("Edit Profile",),
                                      content: const Text("Are you sure to change your profile details?"),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context).textTheme.labelLarge,
                                          ),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              color: themeOptions.secondaryColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            beamer.popRoute();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context).textTheme.labelLarge,
                                          ),
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              color: themeOptions.primaryColor,
                                            ),
                                          ),
                                          onPressed: () async{
                                            await submitEditProfile(apiService, themeOptions).then((response) {
                                              String responseMessage = response['message'];
                                              showFToast(
                                                context: context,
                                                status: Status.success,
                                                message: responseMessage
                                              );

                                              if(response['status'] == 'success'){
                                                customBeamToNamed(context, 0.0, "/profile");
                                              }
                                            });

                                          },
                                        ),
                                      ],
                                    );
                                  }
                                );

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
      ),
    );
  }
}
