import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_webapp/helper/color.dart';

import '../controller/user_controller.dart';
import '../model/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColor.secondary,
      appBar: AppBar(
        backgroundColor: DSColor.primary,
        title: const Text(
          "REGISTER USERS",
        ),
        centerTitle: true,
        actions: [
          Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            color: DSColor.primary,
            child: InkWell(
              onTap: () {
                final form = _formKey.currentState;
                if (userController.users.isNotEmpty) {
                  if (form!.validate()) {
                    FocusScope.of(context).unfocus();
                    form.save();
                    Future.delayed(const Duration(seconds: 1), () {
                      Get.toNamed("/user-list");
                    });
                  }
                }
              },
              splashFactory: InkRipple.splashFactory,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: GetX<UserController>(
          builder: (controller) {
            if (controller.users.isEmpty) {
              return Center(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Text(
                      "Oops\nAdd form by tapping add button below",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (BuildContext context, int index) {
                  final TextEditingController nameController =
                      TextEditingController();
                  final TextEditingController emailController =
                      TextEditingController();
                  User user = controller.users.elementAt(index);
                  nameController.value = TextEditingValue(
                    text: user.name, // same thing as 10.toString()
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: user.name.length),
                    ),
                  );
                  emailController.value = TextEditingValue(
                    text: user.email, // same thing as 10.toString()
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: user.email.length),
                    ),
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            color: DSColor.primary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(
                                  width: 40,
                                ),
                                const Expanded(
                                  child: Text(
                                    "User Details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.deleteUser(user);
                                  },
                                  child: const SizedBox(
                                    width: 40,
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    autocorrect: false,
                                    controller: nameController,
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      if (_debounce?.isActive ?? false) {
                                        _debounce?.cancel();
                                      }
                                      _debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () {
                                        userController.saveUser(user.copyWith(
                                          name: nameController.text,
                                          email: emailController.text,
                                        ));
                                      });
                                    },
                                    validator: (val) {
                                      var regex = RegExp(r"^[a-zA-Z]");
                                      if (val == null) return null;
                                      if (val.isEmpty) {
                                        return "Full name is invalid.";
                                      }
                                      if (!regex.hasMatch(val)) {
                                        return "Full name is invalid.";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(
                                        Icons.person,
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 50,
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black38.withAlpha(50),
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black38.withAlpha(50),
                                          width: 0.5,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 0.5,
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black38.withAlpha(150),
                                      ),
                                      hintText: "Full Name",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    autocorrect: false,
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      var regex = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                      if (val == null) return null;
                                      if (val.isEmpty) {
                                        return "Email is invalid.";
                                      }
                                      if (!regex.hasMatch(val)) {
                                        return "Email is invalid.";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      if (_debounce?.isActive ?? false) {
                                        _debounce?.cancel();
                                      }
                                      _debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () {
                                        userController.saveUser(user.copyWith(
                                          name: nameController.text,
                                          email: emailController.text,
                                        ));
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(
                                        Icons.email,
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 50,
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black38.withAlpha(50),
                                          width: 0.5,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black38.withAlpha(50),
                                          width: 0.5,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 0.5,
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black38.withAlpha(150),
                                      ),
                                      hintText: "Email Address",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userController.addUser();
        },
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ), //
    );
  }
}
