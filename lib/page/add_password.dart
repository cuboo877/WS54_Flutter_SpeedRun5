import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun5/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun5/page/home.dart';
import 'package:ws54_flutter_speedrun5/service/data_model.dart';
import 'package:ws54_flutter_speedrun5/service/sql_serivce.dart';
import 'package:ws54_flutter_speedrun5/service/utilities.dart';
import 'package:ws54_flutter_speedrun5/widget/custom_text.dart';
import 'package:ws54_flutter_speedrun5/widget/text_button.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  int isFav = 0;
  bool isTagValid = false;
  bool isUrlValid = false;
  bool isLoginValid = false;
  bool isPasswordValid = false;

  bool hasLowerCase = true;
  bool hasUpperCase = true;
  bool hasSymbol = true;
  bool hasNumber = true;
  int length = 16;

  late TextEditingController custom_controller;
  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    custom_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    custom_controller.dispose();
    super.dispose();
  }

  PasswordData packPasswordData() {
    return PasswordData(
        Utilitie.randomID(),
        widget.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(context),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                customText("標籤", 20, AppColor.black, false),
                const SizedBox(height: 20),
                tagTextForm(),
                const SizedBox(height: 20),
                customText("網址", 20, AppColor.black, false),
                const SizedBox(height: 20),
                urlTextForm(),
                const SizedBox(height: 20),
                customText("登入帳號", 20, AppColor.black, false),
                const SizedBox(height: 20),
                loginTextForm(),
                const SizedBox(height: 20),
                customText("密碼", 20, AppColor.black, false),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                favButton(),
                const SizedBox(height: 20),
                randomPasswordSettingButton(context),
                const SizedBox(height: 20),
                submitCreateButton(context)
              ],
            )),
      ),
    );
  }

  Widget submitCreateButton(BuildContext context) {
    return AppTextButton.textbutton(AppColor.black, "創建", 30, () async {
      print("$isLoginValid, $isPasswordValid, $isTagValid, $isUrlValid");
      if (isLoginValid && isPasswordValid && isTagValid && isUrlValid) {
        await PasswordDAO.addPasswordData(packPasswordData());
        print("create password data");
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        }
      } else {
        if (mounted) {
          Utilitie.showSnackBar(context, "請輸入資料", 2);
        }
      }
    });
  }

  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: isFav == 0 ? AppColor.white : AppColor.red,
            iconColor: isFav == 0 ? AppColor.red : AppColor.white,
            side: const BorderSide(color: AppColor.red, width: 2.0),
            shape: const CircleBorder()),
        onPressed: () {
          setState(() {
            isFav = isFav == 0 ? 1 : 0;
          });
        },
        child: const Icon(Icons.favorite));
  }

  Widget tagTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: tag_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isTagValid = false;
            return "請輸入";
          } else {
            isTagValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "tag",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide: const BorderSide(width: 2.0))),
      ),
    );
  }

  Widget urlTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: url_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isUrlValid = false;
            return "請輸入";
          } else {
            isUrlValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "url",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide: const BorderSide(width: 2.0))),
      ),
    );
  }

  Widget loginTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: login_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isLoginValid = false;
            return "請輸入";
          } else {
            isLoginValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "login",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide: const BorderSide(width: 2.0))),
      ),
    );
  }

  Widget randomPasswordSettingButton(BuildContext context) {
    return AppTextButton.textbutton(
      AppColor.black,
      "隨機密碼設定",
      25,
      () async {
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Text("隨機密碼設定"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: custom_controller,
                        decoration:
                            const InputDecoration(hintText: "ex: cuboo"),
                      ),
                      CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text("包含小寫字母"),
                          value: (hasLowerCase),
                          onChanged: (value) => setState(() {
                                hasLowerCase = !hasLowerCase;
                              })),
                      CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text("包含大寫字母"),
                          value: (hasUpperCase),
                          onChanged: (value) => setState(() {
                                hasUpperCase = !hasUpperCase;
                              })),
                      CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text("包含符號"),
                          value: (hasSymbol),
                          onChanged: (value) => setState(() {
                                hasSymbol = !hasSymbol;
                              })),
                      CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text("包含數字"),
                          value: (hasNumber),
                          onChanged: (value) => setState(() {
                                hasNumber = !hasNumber;
                              })),
                      Row(
                        children: [
                          Slider(
                              divisions: 19,
                              max: 20,
                              min: 1,
                              value: (length.toDouble()),
                              onChanged: (value) =>
                                  setState(() => length = value.toInt())),
                          Text(length.toString())
                        ],
                      )
                    ],
                  ),
                );
              });
            });
      },
    );
  }

  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: password_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isPasswordValid = false;
            return "請輸入";
          } else {
            isPasswordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.casino),
              onPressed: () {
                setState(() {
                  password_controller.text = Utilitie.randomPassword(
                      hasLowerCase,
                      hasUpperCase,
                      hasSymbol,
                      hasNumber,
                      custom_controller.text,
                      length);
                });
              },
            ),
            hintText: "password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide: const BorderSide(width: 2.0))),
      ),
    );
  }

  Widget topBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColor.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0,
      title: const Text(
        "創建您的密碼",
        style: TextStyle(color: AppColor.black),
      ),
      centerTitle: true,
      backgroundColor: AppColor.white,
    );
  }
}
