// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_ticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetsTicker _$AssetsTickerFromJson(Map<String, dynamic> json) {
  return AssetsTicker(
    (json['a'] as List<dynamic>).map((e) => e as String).toList(),
    (json['b'] as List<dynamic>).map((e) => e as String).toList(),
    (json['c'] as List<dynamic>).map((e) => e as String).toList(),
    (json['v'] as List<dynamic>).map((e) => e as String).toList(),
    (json['p'] as List<dynamic>).map((e) => e as String).toList(),
    (json['t'] as List<dynamic>).map((e) => e as int).toList(),
    (json['l'] as List<dynamic>).map((e) => e as String).toList(),
    (json['h'] as List<dynamic>).map((e) => e as String).toList(),
    json['o'] as String,
  );
}

Map<String, dynamic> _$AssetsTickerToJson(AssetsTicker instance) =>
    <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'c': instance.c,
      'v': instance.v,
      'p': instance.p,
      't': instance.t,
      'l': instance.l,
      'h': instance.h,
      'o': instance.o,
    };
