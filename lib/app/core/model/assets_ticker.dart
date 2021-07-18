import 'package:json_annotation/json_annotation.dart';

part 'assets_ticker.g.dart';


@JsonSerializable()
class AssetsTicker {
  List<String> a;
  List<String> b;
  List<String> c;
  List<String> v;
  List<String> p;
  List<int> t;
  List<String> l;
  List<String> h;
  String o;

  AssetsTicker(this.a, this.b, this.c, this.v,this.p, this.t, this.l, this.h, this.o);

  factory AssetsTicker.fromJson(Map<String, dynamic> json) =>
      _$AssetsTickerFromJson(json);
}

