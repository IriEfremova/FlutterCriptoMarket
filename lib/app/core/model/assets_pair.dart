class AssetsPair {
  //Наименование валюты
  String name;

  //Стоп-цены для мониторинга, минимальная и максимальная граница
  double minPrice;
  double maxPrice;

  AssetsPair(this.name, this.minPrice, this.maxPrice);

  factory AssetsPair.fromMap(Map<String, dynamic> map) => new AssetsPair(
    map["name"],
    map["min_price"],
    map["max_price"],
  );
}
