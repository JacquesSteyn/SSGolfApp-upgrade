import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool showActions;
  CustomAppBar({this.title, this.showActions = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(Icons.arrow_back),
      ),
      actions: showActions
          ? [
              IconButton(
                onPressed: () {
                  Get.offAndToNamed(AppRoutes.appRoot);
                  // toNamed(AppRoutes.appRoot);
                },
                icon: Icon(Icons.home),
              ),
            ]
          : [],
      // : [IconButton(onPressed: () {}, icon: Icon(Icons.visibility_outlined))],
      centerTitle: true,
      title: Text(
        title,
      ),
    );
  }
}
