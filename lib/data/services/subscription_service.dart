import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _isSubscribed = false;

  bool get isSubscribed => _isSubscribed;
  List<ProductDetails> get products => _products;

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    const Set<String> _kIds = {'premium_monthly', 'premium_yearly'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);
    
    _products = response.productDetails;

    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // Handle error
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        _isSubscribed = true;
        // Verify purchase with backend if necessary
      }
      
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> buySubscription(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void dispose() {
    _subscription.cancel();
  }
}
