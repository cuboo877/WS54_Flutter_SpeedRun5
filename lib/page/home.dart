import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun5/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun5/page/login.dart';
import 'package:ws54_flutter_speedrun5/page/user.dart';
import 'package:ws54_flutter_speedrun5/service/auth.dart';
import 'package:ws54_flutter_speedrun5/service/data_model.dart';
import 'package:ws54_flutter_speedrun5/widget/text_button.dart';

import '../service/sql_serivce.dart';
import 'add_password.dart';
import 'edit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List passwordList = [];
  bool isSearching = false;
  bool hasFav = false;
  int isFav = 1;
  late TextEditingController tag_cotroller;
  late TextEditingController url_cotroller;
  late TextEditingController password_cotroller;
  late TextEditingController login_cotroller;
  late TextEditingController id_cotroller;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setCurrentAllPasswordDataList();
      print("get passwordlist :${passwordList.length}");
    });
    super.initState();
    tag_cotroller = TextEditingController();
    url_cotroller = TextEditingController();
    password_cotroller = TextEditingController();
    login_cotroller = TextEditingController();
    id_cotroller = TextEditingController();
  }

  @override
  void dispose() {
    tag_cotroller.dispose();
    url_cotroller.dispose();
    password_cotroller.dispose();
    login_cotroller.dispose();
    id_cotroller.dispose();
    super.dispose();
  }

  void setCurrentAllPasswordDataList() async {
    setState(() {
      isSearching = false;
    });
    List<PasswordData> _passwordList =
        await PasswordDAO.getPasswordListDataByUserID(widget.userID);
    setState(() {
      passwordList = _passwordList;
    });
  }

  void setPasswordListByCondition() async {
    setState(() {
      isSearching = true;
    });
    List<PasswordData> _passwordList =
        await PasswordDAO.getPasswordListDataByCondition(
            widget.userID,
            tag_cotroller.text,
            url_cotroller.text,
            login_cotroller.text,
            password_cotroller.text,
            id_cotroller.text,
            hasFav,
            isFav);
    setState(() {
      passwordList = _passwordList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPasswordPage(userID: widget.userID)))),
      drawer: navDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: topBar()),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [searchBar(), passwordListViewBuilder()],
            )),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      child: Column(children: [
        TextFormField(
          controller: tag_cotroller,
          decoration: const InputDecoration(hintText: "tag"),
        ),
        TextFormField(
          controller: url_cotroller,
          decoration: const InputDecoration(hintText: "url"),
        ),
        TextFormField(
          controller: login_cotroller,
          decoration: const InputDecoration(hintText: "login"),
        ),
        TextFormField(
          controller: password_cotroller,
          decoration: const InputDecoration(hintText: "password"),
        ),
        TextFormField(
          controller: id_cotroller,
          decoration: const InputDecoration(hintText: "id"),
        ),
        CheckboxListTile(
            title: const Text("包含我的最愛"),
            value: (hasFav),
            onChanged: (value) => setState(() {
                  hasFav = !hasFav;
                })),
        CheckboxListTile(
            enabled: hasFav,
            title: const Text("我的最愛"),
            value: (isFav == 0 ? false : true),
            onChanged: (value) => setState(() {
                  isFav = isFav == 0 ? 1 : 0;
                })),
        Row(
          children: [
            AppTextButton.textbutton(AppColor.black, "搜尋", 20, () {
              setPasswordListByCondition();
            }),
            AppTextButton.textbutton(AppColor.black, "取消設定", 20, () {
              setState(() {
                tag_cotroller.text = "";
                url_cotroller.text = "";
                login_cotroller.text = "";
                password_cotroller.text = "";
                id_cotroller.text = "";
              });
            }),
            AppTextButton.textbutton(AppColor.black, "取消搜尋", 20, () {
              setCurrentAllPasswordDataList();
            }),
          ],
        )
      ]),
    );
  }

  Widget passwordListViewBuilder() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: passwordList.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: passwordContainer(passwordList[index]),
          );
        }));
  }

  Widget passwordContainer(PasswordData data) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: AppColor.black, width: 2.0)),
      child: Column(
        children: [
          Text(data.tag),
          Text(data.url),
          Text(data.login),
          Text(data.password),
          Row(
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          data.isFav == 0 ? AppColor.white : AppColor.red,
                      iconColor:
                          data.isFav == 0 ? AppColor.red : AppColor.white,
                      side: const BorderSide(color: AppColor.red, width: 2.0),
                      shape: const CircleBorder()),
                  onPressed: () async {
                    setState(() {
                      data.isFav = data.isFav == 0 ? 1 : 0;
                    });
                    await PasswordDAO.upadtePasswordData(data);
                  },
                  child: const Icon(Icons.favorite)),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColor.green,
                      shape: const CircleBorder()),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPage(data: data))),
                  child: const Icon(
                    Icons.edit,
                    color: AppColor.white,
                  )),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColor.red,
                      shape: const CircleBorder()),
                  onPressed: () async {
                    await PasswordDAO.deletePasswordDataByPasswordID(data.id);
                    //TODO: setPasswrodList
                    setState(() {
                      if (isSearching) {
                        setPasswordListByCondition();
                      } else {
                        setCurrentAllPasswordDataList();
                      }
                    });
                  },
                  child: const Icon(
                    Icons.delete,
                    color: AppColor.white,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget navDrawer() {
    return Drawer(
      width: 320,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                  Image.asset(
                    "assets/icon.png",
                    width: 23,
                    height: 23,
                  )
                ],
              ),
              ListTile(
                onTap: () => Navigator.of(context).pop(),
                leading: const Icon(Icons.home),
                title: const Text("主畫面"),
              ),
              ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserPage(userID: widget.userID))),
                leading: const Icon(Icons.person),
                title: const Text("帳戶設置"),
              ),
              ListTile(
                onTap: () async {
                  await Auth.logOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  }
                },
                leading: const Icon(Icons.logout),
                title: const Text("登出"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topBar() {
    return AppBar(
      backgroundColor: AppColor.black,
      title: const Text("主畫面"),
      centerTitle: true,
    );
  }
}
