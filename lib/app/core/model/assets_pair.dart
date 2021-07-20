class AssetsPair implements Comparable<AssetsPair>{
  //Наименование валюты
  String name;

  //Стоп-цены для мониторинга, минимальная и максимальная граница
  double realPrice = -1;
  double minPrice = -1;
  double maxPrice = -1;
  String piName = '';

  AssetsPair(this.name);

  AssetsPair.fromServer(this.name, this.piName);

  AssetsPair.fromDB(this.name, this.piName, this.minPrice, this.maxPrice);

  factory AssetsPair.fromMap(Map<String, dynamic> map) => AssetsPair.fromDB(
        map['name'],
        map['piname'],
        map['min_price'],
        map['max_price'],
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AssetsPair &&
        name == other.name;
  }

  @override
  int compareTo(AssetsPair other) {
    return name.compareTo(other.name);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
