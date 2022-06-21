import 'package:get/get.dart';

import 'user/view/user_list_page.dart';
import 'user/view/user_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/user',
      page: () => const UserPage(),
    ),
    GetPage(
      name: '/user-list',
      page: () =>
          const UserListPage(), //(uncomment here to swith to todo app)TodoList(),
    ),
  ];
}
