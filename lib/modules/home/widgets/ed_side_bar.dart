import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/translation/ui_strings.dart';
import '../../../global/user_service.dart';
import '../../../routes.dart';
import '../../widgets/ed_language_dropdown.dart';
import '../home_controller.dart';
import 'ed_main_sidebar_button.dart';
import 'ed_square_button.dart';

class EdSidebar extends GetView<HomeController> {
  const EdSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            "CogniVoice",
            style: GoogleFonts.notoSans(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: EdMainSidebarButton(
            icon: Icons.home,
            text: UiStrings.home,
            onPressed: () {
              Get.toNamed(
                AppRoutes.home,
              );
            },
          ),
        ),
        if (Get.find<UserService>().isUserAdmin)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: EdMainSidebarButton(
              icon: Icons.person_3,
              text: UiStrings.evaluators,
              onPressed: () {
                Get.toNamed(AppRoutes.evaluators);
              },
            ),
          ),
        Spacer(),
        EdProfileAvatar(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // EdSquareButton(
              //   icon: Icons.settings_rounded,
              //   backgroundColor: Colors.black,
              //   iconColor: Colors.white,
              //   onTap: () {},
              // ),
              SizedBox(width: 8.0),
              EdSquareButton(
                icon: Icons.logout_rounded,
                backgroundColor: Colors.black,
                iconColor: Colors.white,
                onTap: () {
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200, maxHeight: 35),
            child: EdLanguageDropdown(),
          ),
        )
      ],
    );
  }
}

class EdProfileAvatar extends StatelessWidget {
  const EdProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var homeController = Get.find<HomeController>();

    return Center(
      child: Obx(() {
        var user = homeController.user.value;
        if (user == null || homeController.isLoading.isTrue) {
          return CircularProgressIndicator(); // Or some placeholder
        }

        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.userProfileScreen);
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50.0,
                child: Image.asset('assets/profile-placeholder.png',
                    width: 300, height: 300),
              ),
              Text(
                user.name ?? 'Unknown Name',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                user.specialty ?? 'Unknown Specialty',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }),
    );
  }
}
