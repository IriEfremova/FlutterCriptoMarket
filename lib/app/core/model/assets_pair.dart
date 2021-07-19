class AssetsPair implements Comparable<AssetsPair>{
  //Наименование валюты
  String name;

  //Стоп-цены для мониторинга, минимальная и максимальная граница
  String realPrice = '';
  double minPrice = -1;
  double maxPrice = -1;
  String piName = '';

  AssetsPair(this.name);

  AssetsPair.fromServer(this.name, this.piName);

  AssetsPair.fromDB(this.name, this.piName, this.minPrice, this.maxPrice);

  factory AssetsPair.fromMap(Map<String, dynamic> map) => new AssetsPair.fromDB(
        map["name"],
        map["piname"],
        map["min_price"],
        map["max_price"],
      );

  updateMinPrice(double value){
    minPrice = value;
  }

  updateMaxPrice(double value){
    maxPrice = value;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AssetsPair &&
        this.name == other.name;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  int compareTo(AssetsPair other) {
    return this.name.compareTo(other.name);
  }
}
