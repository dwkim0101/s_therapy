import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class Purchase {
  //Support for android
  StreamSubscription<List<PurchaseDetails>> _subscription;
  ProductDetails targetProductDetails;
  void Function() onPurchased;
  Purchase(){
    InAppPurchaseConnection.instance.isAvailable().then((v){
      print("inapp purchase ready state : $v");
      if (v == false) return ;
      const Set<String> _kIds = {'android.test.purchased'};

      InAppPurchaseConnection.instance.queryProductDetails(_kIds).then((response){
        if (response.notFoundIDs.isNotEmpty) {
          print("not found IDs is Not Empty");
        }

        List<ProductDetails> products = response.productDetails;
        products.forEach((p){
          targetProductDetails = p;
        });
      });

      InAppPurchaseConnection.instance.queryPastPurchases().then((response){
        print("query Past Purchases");
        if (response.error != null) {
          print("response error ${response.error.details}");
        }
        for (PurchaseDetails purchase in response.pastPurchases) {
          print("skuDetail transactionDate[${purchase.transactionDate}]");
          print("skuDetail productID[${purchase.productID}]");
          print("skuDetail purchaseID[${purchase.purchaseID}]");
          //_verifyPurchase(purchase);  // Verify the purchase following the best practices for each storefront.
          //_deliverPurchase(purchase); // Deliver the purchase to the user in your app.
        }
      });
    });
  }
  void startListener(){
    final Stream purchaseUpdates = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      //_handlePurchaseUpdates(purchases);
      if (purchases == null) print("purchases is null");
      if (purchases != null) {
        for (PurchaseDetails purchase in purchases) {
          print("purchases response ");
          if (purchase.productID == null) print("purchase cancel");
          if (purchase.productID != null) {
            InAppPurchaseConnection.instance.consumePurchase(purchase);
            onPurchased?.call();
          }
          print("skuDetail transactionDate[${purchase.transactionDate}]");
          print("skuDetail productID[${purchase.productID}]");
          print("skuDetail purchaseID[${purchase.purchaseID}]");
          //_verifyPurchase(purchase);  // Verify the purchase following the best practices for each storefront.
          //_deliverPurchase(purchase); // Deliver the purchase to the user in your app.
        }
      }
    });
  }
  void stopListener() => _subscription.cancel();
  void setOnPurchased(void Function() cb){
    onPurchased = cb;
  }
  void purchase() {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: targetProductDetails);
    InAppPurchaseConnection.instance.buyConsumable(purchaseParam: purchaseParam);

  }

}