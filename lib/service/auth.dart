import 'package:ws54_flutter_speedrun5/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun5/service/sql_serivce.dart';

import 'data_model.dart';

class Auth {
  static Future<bool> loginAuth(String account, String password) async {
    try {
      UserData userData =
          await UserDAO.getUserDataByAccountAndPassword(account, password);

      await SharedPref.setLoggedUserID(userData.id);
      print("get registered userdata ${userData.id}");
      return true;
    } catch (e) {
      print("didnt get any registered userdata...");
      print(e);
      return false;
    }
  }

  static Future<bool> hasAccountBeenRegistered(String account) async {
    try {
      UserData userData = await UserDAO.getUserDataByAccount(account);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> registerAuith(UserData userData) async {
    await UserDAO.addUserData(userData);
    await SharedPref.setLoggedUserID(userData.id);
    print("registered data!");
  }

  static Future<void> logOut() async {
    await SharedPref.removeLoggedUserID();
    print('logged out!!!');
  }
}
