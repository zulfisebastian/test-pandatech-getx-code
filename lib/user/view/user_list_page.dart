import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/color.dart';
import '../controller/user_controller.dart';
import '../widgets/user_list_item.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.close,
          ),
        ),
        backgroundColor: DSColor.primary,
        title: const Text(
          "LIST OF USERS",
        ),
        centerTitle: true,
      ),
      body: GetX<UserController>(builder: (controller) {
        return ListView.separated(
          itemCount: controller.users.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 4,
              color: Colors.black26,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return UserListItem(
              data: controller.users[index],
            );
          },
        );
      }),
    );
  }
}
