import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun5/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun5/page/home.dart';
import 'package:ws54_flutter_speedrun5/service/data_model.dart';
import 'package:ws54_flutter_speedrun5/service/sql_serivce.dart';
import 'package:ws54_flutter_speedrun5/service/utilities.dart';
import 'package:ws54_flutter_speedrun5/widget/custom_text.dart';
import 'package:ws54_flutter_speedrun5/widget/text_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserData userData = UserData("", "", "", "", "");
  late TextEditingController username_contrller;
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController birthday_controller;

  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isUserNameValid = false;
  bool isBirthdayValid = false;

  @override
  void initState() {
    super.initState();
    setCurrentUserData();
    username_contrller = TextEditingController();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_contrller.dispose();
    account_controller.dispose();
    password_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  Future<void> setCurrentUserData() async {
    UserData _userData = await UserDAO.getUserDataByUserID(widget.userID);

    setState(() {
      username_contrller.text = _userData.username;
      account_controller.text = _userData.account;
      password_controller.text = _userData.password;
      birthday_controller.text = _userData.birthday;
    });
  }

  UserData packUserData() {
    return UserData(
        widget.userID,
        username_contrller.text,
        account_controller.text,
        password_controller.text,
        birthday_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: topBar()),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                customText("使用者名稱", 20, AppColor.black, false),
                const SizedBox(height: 20),
                usernameTextForm(),
                customText("帳號", 20, AppColor.black, false),
                const SizedBox(height: 20),
                accountTextForm(),
                customText("密碼", 20, AppColor.black, false),
                const SizedBox(height: 20),
                passwordTextForm(),
                customText("生日", 20, AppColor.black, false),
                const SizedBox(height: 20),
                birthdayTextForm(),
                const SizedBox(height: 20),
                editFinishButton()
              ],
            )),
      ),
    );
  }

  Widget editFinishButton() {
    return AppTextButton.textbutton(AppColor.black, "編輯完成", 30, () async {
      if (isAccountValid &&
          isBirthdayValid &&
          isPasswordValid &&
          isUserNameValid) {
        await UserDAO.updateUserData(packUserData());
        print("updated useradta!! ${username_contrller.text}");
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        }
      } else {
        if (mounted) {
          Utilitie.showSnackBar(context, "請確認輸入", 2);
        }
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: account_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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

  Widget usernameTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: username_contrller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isUserNameValid = false;
              return '請輸入';
            } else {
              isUserNameValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(width: 2.0))),
        ));
  }

  Widget birthdayTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: birthday_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () async {
            DateTime? _picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2026));
            if (_picked == null) {
              isUserNameValid = false;
            } else {
              setState(() {
                birthday_controller.text = _picked.toString().split(" ")[0];
              });
              isUserNameValid = true;
            }
          },
          readOnly: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isBirthdayValid = false;
              return '請輸入';
            } else {
              isBirthdayValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "YYYY-MM-DD",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(width: 2.0))),
        ));
  }

  Widget topBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColor.black,
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        },
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColor.white,
      title: const Text(
        "用戶基本資料",
        style: TextStyle(color: AppColor.black),
      ),
    );
  }
}
