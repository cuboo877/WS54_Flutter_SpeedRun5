import 'package:flutter/material.dart';

import '../constant/style_guide.dart';
import '../service/data_model.dart';
import '../service/sql_serivce.dart';
import '../service/utilities.dart';
import '../widget/custom_text.dart';
import '../widget/text_button.dart';
import 'home.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.data});
  final PasswordData data;
  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  int isFav = 0;
  bool isTagValid = true;
  bool isUrlValid = true;
  bool isLoginValid = true;
  bool isPasswordValid = true;

  bool hasLowerCase = true;
  bool hasUpperCase = true;
  bool hasSymbol = true;
  bool hasNumber = true;
  int length = 16;

  late TextEditingController custom_controller;
  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController(text: widget.data.tag);
    url_controller = TextEditingController(text: widget.data.url);
    login_controller = TextEditingController(text: widget.data.login);
    password_controller = TextEditingController(text: widget.data.password);
    isFav = widget.data.isFav;
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
        widget.data.id,
        widget.data.userID,
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
                submitUpdateButton(context)
              ],
            )),
      ),
    );
  }

  Widget submitUpdateButton(BuildContext context) {
    return AppTextButton.textbutton(AppColor.black, "編輯完成", 30, () async {
      print("$isLoginValid, $isPasswordValid, $isTagValid, $isUrlValid");
      if (isLoginValid && isPasswordValid && isTagValid && isUrlValid) {
        await PasswordDAO.upadtePasswordData(packPasswordData());
        print("update password data");
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.data.userID)));
        }
      } else {
        if (mounted) {
          Utilitie.showSnackBar(context, "請輸入資料", 2);
        }
      }
    });
  }

  //FIXME
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
        "編輯您的密碼",
        style: TextStyle(color: AppColor.black),
      ),
      centerTitle: true,
      backgroundColor: AppColor.white,
    );
  }
}
