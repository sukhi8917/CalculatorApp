import 'package:clothes_app/users/fragments/favorites_fragment_screen.dart';
import 'package:clothes_app/users/fragments/home_fragment_screen.dart';
import 'package:clothes_app/users/fragments/order_fragment_screen.dart';
import 'package:clothes_app/users/fragments/profile_fragment_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
class DashboardOfFragments extends StatelessWidget {

CurrentUser _rememberCurrentUser=Get.put(CurrentUser());

final List<Widget> _fragmentScreens=[
  HomeFragmentScreen(),
  FavoritesFragmentScreen(),
  OrderFragmentScreen(),
  ProfileFragmentScreen(),
];

final List _navigationButtonProperties=[
  {
    "active_icon":Icons.home,
    "non_active_icon":Icons.home_outlined,
    "lable":"Home",
  },
{
   "active_icon":Icons.favorite,
    "non_active_icon":Icons.favorite_border,
    "lable":"Favorites",
},

  {
    "active_icon":FontAwesomeIcons.boxOpen,
    "non_active_icon":FontAwesomeIcons.box,
    "lable":"Order",
  },

  {
    "active_icon":Icons.person,
    "non_active_icon":Icons.person_outline,
    "lable":"Profile",
  },


];

final RxInt _indexNumber=0.obs;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(), //var controller =Get.put(controller) ye code nahi likhna pdta controller ko inisilize ke liye
      //simple 'init ' controller ko inisiliz kr deta h 
      initState: (currentState){
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller){
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Obx(
                ()=> _fragmentScreens[_indexNumber.value]
            ),
          ),
          bottomNavigationBar: Obx(
              ()=>BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value){
                  _indexNumber.value=value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white24,
                items: List.generate(4, (index) {
                  var navBtnProperty=_navigationButtonProperties[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(navBtnProperty["non_active_icon"]),
                    activeIcon: Icon(navBtnProperty["active_icon"]),
                    label: navBtnProperty["lable"],
                  );
                }),


              )
          ),

        );
      },

    );
  }
}


