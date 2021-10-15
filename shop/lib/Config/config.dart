import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp {
  static const String appName = 'e-Shop';
  static SharedPreferences sharedPreferences;

  static Firestore firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String qrcodes = 'qrcodes';
  static String subCollectionAddress = 'userAddress';
  static String collectionCategories = "Category";

  static String qrId = 'qrId';
  static String imageUrl = 'imageUrl';
  static String imageURL = 'imageURL';

  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String categoryID = 'categoryIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
  static String collectionOnaylanan = "Onaylanan";

  static final String CardOwnerName = 'CON';
  static final String CardNumber = 'cnumber';
  static final String CardDate = 'cardDate';
  static final String orderDate = 'orderDate';
  static final String CVV = 'cvv';
  static final String isCash = 'nakitMi';
  static String message = 'message';

  //static final String quantity = 'totalQuantity';
  static final String urunMiktari = 'urunMiktari';
}
