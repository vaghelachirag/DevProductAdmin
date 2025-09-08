class AddProductModel {
  final String id;
  final String action;
  final String productName;
  final String category;
  final String  purchasePrice;
  final String  sellingPrice;
  final String quantity;

  AddProductModel({
    required this.id,
    required  this.action,
    required this.productName,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
  });

  Map<String, String> toJson() {
    return {
      'Id': id.toString(),
      'action': action.toString(),
      'Category': category,
      'ProductName': productName,
      'PurchasePrice': purchasePrice.toString(),
      'SellingPrice': sellingPrice.toString(),
      'Qty': quantity.toString()
    };
  }

}
