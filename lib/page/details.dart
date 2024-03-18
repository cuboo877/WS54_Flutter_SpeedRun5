import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun5/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun5/page/home.dart';
import 'package:ws54_flutter_speedrun5/service/auth.dart';
import 'package:ws54_flutter_speedrun5/service/data_model.dart';
import 'package:ws54_flutter_speedrun5/service/utilities.dart';
import 'package:ws54_flutter_speedrun5/widget/custom_text.dart';
import 'package:ws54_flutter_speedrun5/widget/text_button.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});
  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController username_controller;
  late TextEditingController birthday_contoller;

  bool isUserNameValid = false;
  bool isBirthdayValid = false;
  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_contoller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_contoller.dispose();
    super.dispose();
  }

  UserData packUserData() {
    return UserData(Utilitie.randomID(), username_controller.text,
        widget.account, widget.password, birthday_contoller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topbar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            customText("使用者基本資料", 30, AppColor.black, true),
            const SizedBox(height: 20),
            customText("使用者名稱", 20, AppColor.black, false),
            const SizedBox(height: 20),
            usernameTextForm(),
            const SizedBox(height: 20),
            customText("生日", 20, AppColor.black, false),
            const SizedBox(height: 20),
            birthdayTextForm(),
            const SizedBox(height: 20),
            startButton()
          ]),
        ),
      ),
    );
  }

  Widget startButton() {
    return AppTextButton.textbutton(AppColor.black, "開始使用", 30, () async {
      if (isBirthdayValid && isUserNameValid) {
        UserData _userData = packUserData();
        await Auth.registerAuith(_userData);
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: _userData.id)));
          Utilitie.showSnackBar(context, "歡迎", 2);
        }
      } else {
        if (mounted) {
          Utilitie.showSnackBar(context, "請確認輸入的基本資料", 2);
        }
      }
    });
  }

  Widget usernameTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: username_controller,
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
          controller: birthday_contoller,
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
                birthday_contoller.text = _picked.toString().split(" ")[0];
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

  Widget topbar() {
    return AppBar(
      backgroundColor: AppColor.black,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text("即將完成註冊"),
    );
  }
}
