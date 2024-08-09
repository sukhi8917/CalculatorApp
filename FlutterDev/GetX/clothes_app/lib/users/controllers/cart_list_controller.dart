import 'dart:ffi';

import 'package:clothes_app/users/model/Cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController
{
 RxList<Cart> _cartlist = <Cart>[].obs; //user all items in cart
 RxList<int> _selectedItemList = <int>[].obs; //user selected items for which user want to proceed and want to place final order
 RxBool _isSelectedAll = false.obs;
 RxDouble _totel = 0.0.obs;

 List<Cart> get cartList => _cartlist.value;
 List<int> get selectedItemList => _selectedItemList.value;
 bool get isSelectedAll => _isSelectedAll.value;
 double get total => _totel.value;

 setList(List<Cart> list){
   _cartlist.value = list;
 }

 addSelectedItem(int SelectedItemCartID){
   _selectedItemList.value.add(SelectedItemCartID);
   update();
 }

 deleteSelectedItem(int SelectedItemCartID){
   _selectedItemList.value.remove(SelectedItemCartID);
   update();
 }

 setIsSelectedAllItems(){
                          //true
   _isSelectedAll.value = !_isSelectedAll.value;
 }

 clearAllSelectedItems(){
   _selectedItemList.value.clear();
   update();
 }

 setTotal(double overallTotal){
   _totel.value = overallTotal;
 }


}