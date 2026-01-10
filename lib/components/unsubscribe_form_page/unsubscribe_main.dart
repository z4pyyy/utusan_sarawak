import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import 'package:utusan_sarawak/components/common/rounded_text_form_field.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/enums/status.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/show_toast.dart';

import '../common/rounded_text_button.dart';

enum UnsubscribeReason { one, two, three }

class UnsubscribeFormMain extends StatefulWidget {
  const UnsubscribeFormMain({Key? key}) : super(key: key);

  @override
  State<UnsubscribeFormMain> createState() => _UnsubscribeFormMainState();
}

class _UnsubscribeFormMainState extends State<UnsubscribeFormMain> {
  UnsubscribeReason? reason = UnsubscribeReason.one;
  final reasonMap = {
    UnsubscribeReason.one : "I didn't find the content useful",
    UnsubscribeReason.two : "I'm no longer interested",
    UnsubscribeReason.three : "Others",
  };

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    final apiService = GetIt.I<ApiService>();

    final controller = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalWhiteSpace(height: 25),
          Text("YOU WILL BE MISSED!", style: TextStyle(fontSize: themeOptions.textSize1),),
          const Text("Please help us to understand why you are leaving"),
          ListTile(
            title: Text(reasonMap[UnsubscribeReason.one]!),
            leading: Radio<UnsubscribeReason>(
              value: UnsubscribeReason.one,
              groupValue: reason,
              onChanged: (UnsubscribeReason? value) {
                setState(() {
                  reason = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(reasonMap[UnsubscribeReason.two]!),
            leading: Radio<UnsubscribeReason>(
              value: UnsubscribeReason.two,
              groupValue: reason,
              onChanged: (UnsubscribeReason? value) {
                setState(() {
                  reason = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(reasonMap[UnsubscribeReason.three]!),
            leading: Radio<UnsubscribeReason>(
              value: UnsubscribeReason.three,
              groupValue: reason,
              onChanged: (UnsubscribeReason? value) {
                setState(() {
                  reason = value;
                });
              },
            ),
          ),
          if(reason == UnsubscribeReason.three)
            SizedBox(
              child: RoundedTextFormField(
                label: "",
                isDense: true,
                borderRadius: BorderRadius.circular(5.sp),
                controller: controller,
              ),
            ),

          const VerticalWhiteSpace(height: 100),

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 40.w,
              child: RoundedTextButton(
                text: Text(
                  "Berhenti Melanggan",
                  style: TextStyle(
                    color: themeOptions.textColorOnSecondary,
                    fontSize: user.textSizeScale * themeOptions.textSize2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () async{
                  // Map<String, dynamic> postData = {"id" : user.id, "user_id": user.user_id, "token" : user.token};
                  Map<String, dynamic> postData = {"id" : user.id, "user_id": user.userId};
                  await apiService.unsubscribe(postData).then((response) {
                    String responseMessage = response['message'];
                    showFToast(
                      context: context,
                      status: Status.success,
                      message: responseMessage,
                    );

                    if(response['status'] == 'success') {
                      setState(() {
                        user.logout();
                      });
                      customBeamToNamed(context, 0.0, "/profile");
                    }

                  });

                },
                foregroundColor: themeOptions.primaryColor,
                backgroundColor: themeOptions.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
