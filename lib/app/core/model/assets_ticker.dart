import 'package:json_annotation/json_annotation.dart';

part 'assets_ticker.g.dart';

@JsonSerializable(createToJson: false)
class AssetsTicker {
  @JsonKey(name: 'a')
  List<String> ask;
  @JsonKey(name: 'b')
  List<String> bid;
  @JsonKey(name: 'c')
  List<String> change;
  @JsonKey(name: 'v')
  List<String> volume;
  @JsonKey(name: 'p')
  List<String> pair;
  @JsonKey(name: 't')
  List<int> tag;
  @JsonKey(name: 'l')
  List<String> leverage;
  @JsonKey(name: 'h')
  List<String> h;
  @JsonKey(name: 'o')
  String openInterest;

  AssetsTicker(this.ask, this.bid, this.change, this.volume,this.pair, this.tag, this.leverage, this.h, this.openInterest);

  factory AssetsTicker.fromJson(Map<String, dynamic> json) =>
      _$AssetsTickerFromJson(json);
}

