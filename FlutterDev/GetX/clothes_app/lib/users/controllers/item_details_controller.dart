import 'package:get/get.dart';


/*This code defines a class called ItemDetailsController,
 which is responsible for managing the details of an item,
 like its quantity, size, color, and whether it’s marked as a favorite.
  It uses GetX, a state management library for Flutter,
  to make these item properties reactive (meaning they automatically update the UI
   when their values change).
   It uses reactive variables (RxInt, RxBool) to automatically update the UI
    whenever these properties change.
   */
class ItemDetailsController extends GetxController
{
  RxInt _quantityItem = 1.obs;
  RxInt _sizeItem = 0.obs;
  RxInt _colorItem = 0.obs;
  RxBool _isFavorite = false.obs;

  int get quantity => _quantityItem.value;
  int get size => _sizeItem.value;
  int get color => _colorItem.value;
  bool get isFavorite => _isFavorite.value;

  setQuantityItem(int quantityOfItem){
    _quantityItem.value=quantityOfItem;
  }

  setSizeItem(int sizeOfItem){
    _sizeItem.value=sizeOfItem;
  }

  setColorItem(int colorOfItem){
    _colorItem.value=colorOfItem;
  }

  setIsFavorite(bool isFavorite){
    _isFavorite.value=isFavorite;
  }
}