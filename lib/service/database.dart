import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_giuaki_app/model/product.dart';
import 'package:crud_giuaki_app/model/user.dart';
import 'package:crud_giuaki_app/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DatabaseMethods {
  // Future addProductDetails(
  //     Map<String, dynamic> productInfoMap, String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection("product")
  //       .doc(id)
  //       .set(productInfoMap);
  // }
  Future<void> addProductDetails(ProductModel product, String id) async {
    return await FirebaseFirestore.instance
        .collection("product")
        .doc(product.id)
        .set(product.toMap());
  }

  Future<Stream<QuerySnapshot>> getProductDetails(String userId) async {
    return await FirebaseFirestore.instance
        .collection("product")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  // Future updateProductDetail(String id, Map<String, dynamic> updateInfo) async {
  //   return await FirebaseFirestore.instance
  //       .collection("product")
  //       .doc(id)
  //       .update(updateInfo);
  // }
  Future<void> updateProductDetail(String id, ProductModel updatedProduct) async {
    return await FirebaseFirestore.instance
        .collection("product")
        .doc(id)
        .update(updatedProduct.toMap());
  }

  Future deleteProductDetail(String id) async {
    return await FirebaseFirestore.instance
        .collection("product")
        .doc(id)
        .delete();
  }

  // Future<Map<String, dynamic>?> getCurrentUser() async {
  //   // Get the current user from FirebaseAuth
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //
  //   // Fetch additional user data from Firestore if needed
  //   if (currentUser != null) {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUser.uid)
  //         .get();
  //
  //     // Return user data as a Map<String, dynamic>
  //     return userDoc.data() as Map<String, dynamic>?;
  //   }
  //
  //   // Return null if no user is logged in or no data found
  //   return null;
  // }
  Future<UserModel?> getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    }

    return null;
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }
}
