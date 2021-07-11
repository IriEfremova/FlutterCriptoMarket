import 'package:json_annotation/json_annotation.dart';

part 'assets_info.g.dart';

/*
@JsonSerializable()
class Assets {
  late String aclass;
  late String altname;
  late int decimals;
  late int display_decimals;

  Assets(this.aclass, this.altname, this.decimals, this.display_decimals);

  factory Assets.fromJson(Map<String, dynamic> json) =>
      _$AssetsFromJson(json);
}

 */

@JsonSerializable()
class AssetsInfo {
  final Map<String, dynamic> data;

  AssetsInfo(this.data);

  factory AssetsInfo.fromJson(dynamic json) =>
     _$AssetsInfoFromJson(json);

}

