import '../entities/stock_status.dart';

// this part determines the stock status of an item based on its current quantity
StockStatus checkStock({
  required int? currentStock,
  int threshold = 5,
}){
  // missing or invalid stock values default to in stock
  if (currentStock == null || currentStock < 0){
    return StockStatus.inStock;
  }
  // zero stock means the item is out of stock
  if (currentStock == 0){
    return StockStatus.outOfStock;
  }
  // stock at or below the threshold is considered low
  if (currentStock <= threshold){
    return StockStatus.lowStock;
  }
  // otherwise, the item is in stock
  return StockStatus.inStock;
}