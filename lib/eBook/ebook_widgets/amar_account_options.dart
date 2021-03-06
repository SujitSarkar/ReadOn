import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_on/controller/public_controller.dart';
import '../ebook_screens/money_return.dart';
import '../ebook_screens/profile_page.dart';
import '../ebook_screens/wallet_page.dart';
import 'package:read_on/login_page.dart';
import 'package:read_on/public_variables/color_variable.dart';
import 'package:read_on/public_variables/style_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmarAccountOptions extends StatelessWidget {
  Widget child;
  String title;

  AmarAccountOptions({Key? key, required this.child, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PublicController publicController = Get.find();
    double size = publicController.size.value;
    return GestureDetector(
      onTap: () async {
        if(title == 'প্রোফাইল') Get.to(() => Profile());
        if(title == 'টাকা ফেরত') Get.to(() => const MoneyReturnPage());
        if(title == 'কয়েন  ও পয়েন্ট') Get.to(() => const WalletPage());
        if(title == 'লগ আউট'){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('readOnUserId');
          // ignore: avoid_print
          print('logged out and removed readOnUserId');
          Get.offAll(() => LoginPage());
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * .04),
        ),
        child: Container(
          width: size * .22,
          height: size * .23,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [CColor.themeColor, CColor.themeColorLite]),
            borderRadius: BorderRadius.circular(size * .04),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              Text(
                title,
                textAlign: TextAlign.center,
                style: Style.buttonTextStyle(
                    size * .035, Colors.white, FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
