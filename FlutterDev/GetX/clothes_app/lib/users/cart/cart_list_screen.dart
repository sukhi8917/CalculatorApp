import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controllers/cart_list_controller.dart';
import 'package:clothes_app/users/controllers/item_details_controller.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/order/order_now_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/Cart.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {
  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.getCartList),
          body: {
        //we are sending from flutter app to DB by currentOnlineUserId(key name)
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (responseBodyOfGetCurrentUserCartItems["success"] == true) {
          (responseBodyOfGetCurrentUserCartItems["currentUserCartData"] as List)
              .forEach((eachCurrentUserCartItemData) {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItemData));
          });
        } else {
          Fluttertoast.showToast(msg: "Your Cart List Is Empty");
        }
        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "status code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error : " + errorMsg.toString());
    }

    calculateTotalAmount();
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);
    if (cartListController.selectedItemList.length > 0) {
      cartListController.cartList.forEach((itemInCart) {
        if (cartListController.selectedItemList.contains(itemInCart.cart_id)) {
          double eachItemTotalAmount = (itemInCart.price!) *
              (double.parse(itemInCart.quantity.toString()));

          cartListController
              .setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
    }
  }


  deleteSelectedItemsFromUserCartList(int cartID) async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.deleteSelectedItemsFromCartList),
        body:
          {
            "cart_id":cartID.toString(),
          }
      );

      if(res.statusCode == 200)
        {
          var responseBodyFromDeleteCart = jsonDecode(res.body);

          if(responseBodyFromDeleteCart["success"] == true)
            {
              getCurrentUserCartList();
            }
        }
      else
        {
          Fluttertoast.showToast(msg: "Error, Status code is not 200");
        }
    }
    catch(errorMessage)
    {
      print("Error ::" + errorMessage.toString());

      Fluttertoast.showToast(msg:"Error ::" + errorMessage.toString() );
    }

  }

  updateQuantityInUserCart(int cartID,int newQuantity) async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.updateItemInCartList),
        body:
        {
          "cart_id":cartID.toString(),
          "quantity":newQuantity.toString(),
        }
      );
      if(res.statusCode == 200)
      {
        var responseBodyOfUpdateQuantity = jsonDecode(res.body);

        if(responseBodyOfUpdateQuantity["success"] == true)
        {
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status code is not 200");
      }
    }

    catch(errorMessage)
    {
      print("Error:" + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }


  List<Map<String,dynamic>> getSelectedCartListItemsInformation()
  {
    List<Map<String,dynamic>> selectedCartListItemsInformation = [];

    if(cartListController.selectedItemList.length > 0)
    {
      cartListController.cartList.forEach((selectedCartLIstItem)
      {
        //first we have to confirm either these(item in cart list) items in the selected item list

        //first we check there is a cart_id then we procced
        if(cartListController.selectedItemList.contains(selectedCartLIstItem.cart_id))
          {
            Map<String,dynamic> itemInformation =
                {
                  "item_id":selectedCartLIstItem.item_id,
                  "name":selectedCartLIstItem.name,
                  "image":selectedCartLIstItem.image,
                  "color":selectedCartLIstItem.color,
                  "size":selectedCartLIstItem.size,
                  "quantity":selectedCartLIstItem.quantity,
                  "totalAmount":selectedCartLIstItem.price! * selectedCartLIstItem.quantity!,
                  "price": selectedCartLIstItem.price!,
                };

            selectedCartListItemsInformation.add(itemInformation);
          }
      });
    }

    return selectedCartListItemsInformation;
    }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "My Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [

          //to select all items
          Obx(()=>
          IconButton(
            onPressed: ()
            {
              cartListController.setIsSelectedAllItems();
              cartListController.clearAllSelectedItems();

              //if this is true is simple means that user click on checkbox of all selected
              if(cartListController.isSelectedAll)
              {
                cartListController.cartList.forEach((eachItem)
                {
                  cartListController.addSelectedItem(eachItem.cart_id!);
                });
              }

              calculateTotalAmount();
            },
            icon: Icon(
              cartListController.isSelectedAll
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: cartListController.isSelectedAll
              ? Colors.white
              :Colors.grey,
            ),
          ),
          ),

          //to delete selected item/items
          GetBuilder(
            init: CartListController(),
            builder: (c)
            {
              if(cartListController.selectedItemList.length > 0)
                {
                  return IconButton(
                    onPressed: () async
                    {
                      var responseFromDialogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.grey,
                          title:const Text("Delete"),
                          content:const Text("Are you sure to delete selected items from your Cart list"),
                          actions: [
                            TextButton(
                                onPressed: ()
                                {
                                  Get.back();
                                },
                                child: const Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.black
                                  ),

                                ),
                            ),

                            TextButton(
                              onPressed: ()
                              {
                                Get.back(result: "yesDelete");
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.black
                                ),

                              ),
                            ),
                          ],
                        )
                      );
                      if(responseFromDialogBox == "yesDelete")
                        {
                          cartListController.selectedItemList.forEach((selectedItemUserCartID)
                          {
                            //delete selected items now
                            deleteSelectedItemsFromUserCartList(selectedItemUserCartID);
                          });

                        }

                      calculateTotalAmount();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      size: 26,
                      color: Colors.redAccent,
                    ),
                  );
                }
              else{
                return Container();
              }
            },
          )
        ],
      ),
      body: Obx(() => cartListController.cartList.length > 0
          ? ListView.builder(
        itemCount: cartListController.cartList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,index)
        {
          Cart cartModel = cartListController.cartList[index];

          Clothes clothesModel = Clothes(
            item_id: cartModel.item_id,
            colors: cartModel.colors,
            image: cartModel.image,
            name: cartModel.name,
            price: cartModel.price,
            rating: cartModel.rating,
            sizes: cartModel.sizes,
            description: cartModel.description,
            tags: cartModel.tags,
          );

          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                //checkbox
                GetBuilder(
                  init: CartListController(),
                  builder: (c)
                  {
                    return IconButton(
                      onPressed: ()
                      {
                        //if user click on any cart item then it will delete when user click on delete icon
                        if(cartListController.selectedItemList.contains(cartModel.cart_id))
                          {
                            cartListController.deleteSelectedItem(cartModel.cart_id!);
                          }
                       else{
                          cartListController.addSelectedItem(cartModel.cart_id!);
                        }
                        calculateTotalAmount();
                      },
                      icon: Icon(
                        cartListController.selectedItemList.contains(cartModel.cart_id)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: cartListController.isSelectedAll
                            ? Colors.white
                            :Colors.grey,
                      ),
                    );
                  },
                ),
                
                //name
                //color size + price
                //+ 2 -
                //image
                Expanded(
                  child: GestureDetector(
                    onTap: ()
                    {
                     Get.to(ItemDetailsScreen(itemInfo: clothesModel));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        0,
                        index == 0 ?16 : 8,
                        16,
                        index == cartListController.cartList.length - 1 ? 16 :8
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        boxShadow:
                        const[
                          BoxShadow(
                            offset: Offset(0,0),
                            blurRadius: 6,
                            color: Colors.white
                          ),
                        ]
                      ),
                      child: Row(
                        children: [


                          //name
                          //color size + price
                          //+ 2 -
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  //name
                                  Text(
                                    clothesModel.name.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  const SizedBox(height: 20,),

                                  //color  size + price
                                  Row(
                                    children: [
                                      //color size
                                      Expanded(
                                        child: Text(
                                          "Color: ${cartModel.color!.replaceAll('[','').replaceAll(']', '')}" + "\n" + "Size: ${cartModel.size!.replaceAll('[','').replaceAll(']', '')}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style:const TextStyle(
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ),


                                      //price
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12.0
                                        ),
                                        child: Text(
                                            "₹" + clothesModel.price.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.purpleAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 20,),
                                  
                                  //+ 2 -
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      
                                      //-
                                      IconButton(
                                        onPressed: ()
                                        {
                                          if(cartModel.quantity! - 1>=1)
                                          {
                                            updateQuantityInUserCart(
                                              cartModel.cart_id!,
                                              cartModel.quantity! -1,
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 10,),
                                      Text(
                                        cartModel.quantity.toString(),
                                        style: const TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      
                                      //+
                                      IconButton(
                                        onPressed: ()
                                        {
                                          updateQuantityInUserCart(
                                            cartModel.cart_id!,
                                            cartModel.quantity! +1,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  )


                                ],
                              ),
                            ),
                          ),
                          
                          //item image
                          ClipRRect(
                            borderRadius:const BorderRadius.only(
                             bottomRight: Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                            child: FadeInImage(
                              height: 185,
                              width: 150,
                              fit: BoxFit.cover,
                              placeholder:const AssetImage("images/place_holder.png"),
                              image: NetworkImage(
                                cartModel.image!,
                              ),
                              imageErrorBuilder: (context,error,stackTraceError)
                              {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                );
                              },

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),
          );
        },
      )
          : Center(
              child: Text("Cart is Empty"),
            )),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c)
        {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white24,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),

            child: Row(
              children: [
                //total amount
               const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4,),
                Obx(()=>
                Text(
                    "₹" + cartListController.total.toStringAsFixed(2),
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ),

               const Spacer(),

                //order now btn
                Material(
                  color: cartListController.selectedItemList.length > 0
                      ? Colors.purpleAccent
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: ()
                    {
                      //first we check that any item is select or not
                      cartListController.selectedItemList.length > 0
                          ? Get.to(OrderNowScreen(
                        selectedCartListItemInfo:getSelectedCartListItemsInformation() ,
                        totalAmount: cartListController.total,
                        selectedCartIDs:cartListController.selectedItemList,
                      ))
                          :null;
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,

                        ),

                      ),
                    ),
                  ),
                ),

              ],
            ),
          );

        },

      ),
    );
  }
}
