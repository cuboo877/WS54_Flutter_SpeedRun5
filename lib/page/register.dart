import 'package:flutter/material.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/sharedPref.dart';
import '../service/utilities.dart';
import '../widget/custom_text.dart';
import '../widget/text_button.dart';
import 'details.dart';
import 'home.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController confirm_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isConfirmValid = false;
  bool doAuthWarning = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    confirm_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    confirm_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                customText("54全國技能競賽", 50, AppColor.black, true),
                const SizedBox(height: 20),
                customText("註冊", 30, AppColor.black, true),
                const SizedBox(height: 20),
                customText("帳號", 20, AppColor.black, false),
                const SizedBox(height: 20),
                accountTextForm(),
                const SizedBox(height: 20),
                customText("密碼", 20, AppColor.black, false),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                confirmTextForm(),
                const SizedBox(height: 20),
                registerButton(),
                const SizedBox(height: 20),
                RegisterToLoginTextColumn(),
              ],
            )),
      ),
    );
  }

  Widget registerButton() {
    return AppTextButton.textbutton(AppColor.black, "註冊", 30, () async {
      if (isAccountValid &&
          isConfirmValid &&
          isPasswordValid &&
          !doAuthWarning) {
        bool hasRegistered =
            await Auth.hasAccountBeenRegistered(account_controller.text);
        if (hasRegistered) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        } else {
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DetailsPage(
                    account: account_controller.text,
                    password: password_controller.text)));
          }
        }
      } else {
        if (mounted) {
          Utilitie.showSnackBar(context, "請確認輸入!", 1);
        }
      }
    });
  }

  Widget RegisterToLoginTextColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        customText("已經擁有帳號?", 20, AppColor.black, false),
        InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginPage())),
          child: customText("登入", 40, AppColor.darkBlue, true),
        )
      ],
    );
  }

  Widget accountTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: account_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) => setState(() {
            doAuthWarning = false;
          }),
          validator: (value) {
            if (doAuthWarning) {
              isAccountValid = false;
              return '';
            } else if (value == null || value.trim().isEmpty) {
              isAccountValid = false;
              return '請輸入';
            } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                .hasMatch(value)) {
              isAccountValid = false;
              return '請輸入正確的格式';
            } else {
              isAccountValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(width: 2.0))),
        ));
  }

  bool obscure = true;
  Widget passwordTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: password_controller,
          obscureText: obscure,
          onChanged: (value) => setState(() {
            doAuthWarning = false;
          }),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (doAuthWarning) {
              isPasswordValid = false;
              return '';
            } else if (value == null || value.trim().isEmpty) {
              isPasswordValid = false;
              return '請輸入';
            } else {
              isPasswordValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () => setState(() {
                        obscure = !obscure;
                      }),
                  icon:
                      Icon(obscure ? Icons.visibility_off : Icons.visibility)),
              hintText: "password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(width: 2.0))),
        ));
  }

  bool obscure2 = true;
  Widget confirmTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: confirm_controller,
          obscureText: obscure2,
          onChanged: (value) => setState(() {
            doAuthWarning = false;
          }),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (doAuthWarning) {
              isConfirmValid = false;
              return '錯誤的帳號或密碼';
            } else if (value == null || value.trim().isEmpty) {
              isConfirmValid = false;
              return '請輸入';
            } else if (value != password_controller.text) {
              isConfirmValid = false;
              return '請重新確認密碼!';
            } else {
              isConfirmValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () => setState(() {
                        obscure2 = !obscure2;
                      }),
                  icon:
                      Icon(obscure ? Icons.visibility_off : Icons.visibility)),
              hintText: "confirm password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(width: 2.0))),
        ));
  }
}
