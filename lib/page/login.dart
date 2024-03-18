import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun5/page/home.dart';
import 'package:ws54_flutter_speedrun5/page/register.dart';
import 'package:ws54_flutter_speedrun5/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun5/service/utilities.dart';
import 'package:ws54_flutter_speedrun5/widget/custom_text.dart';
import 'package:ws54_flutter_speedrun5/widget/text_button.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import 'add_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;

  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool doAuthWarning = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
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
                customText("登入", 30, AppColor.black, true),
                const SizedBox(height: 20),
                customText("帳號", 20, AppColor.black, false),
                const SizedBox(height: 20),
                accountTextForm(),
                const SizedBox(height: 20),
                customText("密碼", 20, AppColor.black, false),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                loginButton(),
                const SizedBox(height: 20),
                loginToRegisterTextColumn(),
              ],
            )),
      ),
    );
  }

  Widget loginButton() {
    return AppTextButton.textbutton(AppColor.black, "登入", 30, () async {
      bool result = await Auth.loginAuth(
          account_controller.text, password_controller.text);
      if (isAccountValid && isPasswordValid && !doAuthWarning) {
        if (result) {
          String userID = await SharedPref.getLoggedUserID();
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: userID)));
            Utilitie.showSnackBar(context, "歡迎回來", 2);
          }
        } else {
          setState(() {
            doAuthWarning = true;
          });
          if (mounted) {
            Utilitie.showSnackBar(context, "登入失敗!", 2);
          }
        }
      } else {
        if (mounted) {
          Utilitie.showSnackBar(context, "請確認您的輸入!", 2);
        }
      }
    });
  }

  Widget loginToRegisterTextColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        customText("尚未擁有帳號?", 20, AppColor.black, false),
        InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
          child: customText("註冊", 40, AppColor.darkBlue, true),
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
              return '錯誤的帳號或密碼';
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
}
