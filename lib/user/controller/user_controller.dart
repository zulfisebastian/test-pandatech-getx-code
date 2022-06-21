import 'package:get/get.dart';

import '../model/user.dart';

class UserController extends GetxController {
  static UserController to = Get.find();
  RxList users = [].obs;

  addUser() async {
    try {
      var newUser = User(
        id: 1,
        name: "",
        email: "",
      );
      if (users.isNotEmpty) {
        newUser = User(
          id: users.last.id + 1,
          name: "",
          email: "",
        );
      }

      users.add(newUser);
    } catch (e) {
      //print(e);
    }
  }

  saveUser(User updateUser) async {
    users[users.indexWhere((element) => element.id == updateUser.id)] =
        updateUser;
  }

  deleteUser(User user) async {
    try {
      users.removeWhere((element) => element.id == user.id);
    } catch (e) {
      // print(e);
    }
  }
}
