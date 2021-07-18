class AssetsPair implements Comparable<AssetsPair>{
  //Наименование валюты
  String name;

  //Стоп-цены для мониторинга, минимальная и максимальная граница
  String realPrice = '';
  double minPrice = -1;
  double maxPrice = -1;
  String pi_name = '';

  AssetsPair(this.name);

  AssetsPair.fromServer(this.name, this.pi_name);

  AssetsPair.fromDB(this.name, this.pi_name, this.minPrice, this.maxPrice);

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
    if (other.runtimeType != AssetsPair) return false;
    AssetsPair tmp = other as AssetsPair;
    return name == tmp.name;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  int compareTo(AssetsPair other) {
    return this.name.compareTo(other.name);
  }
}
