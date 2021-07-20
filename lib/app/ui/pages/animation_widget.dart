import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationWidget extends StatelessWidget {
  final Color color;
  final double widthWidget;

  AnimationWidget({
    Key? key,
    required this.color,
    required this.widthWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favouriteStore = Provider.of<FavoritesStore>(context);
    final webChannel = Provider.of<WebChannelAPI>(context);
    webChannel.subscribeTicker(favouriteStore.assetsPair.piName);
    return StreamBuilder<List<double>>(
      stream: webChannel.getDataStream,
      builder: (context, AsyncSnapshot<List<double>> snapshot) {
        if (snapshot.hasData) {
          return Center(
              child: Container(
            color: CustomColors.black,
            width: widthWidget,
            height: 300,
            child: CustomPaint(
              painter: AnimationWidgetPainter(
                  snapshot.data!,
                  color,
                  favouriteStore.assetsPair.minPrice,
                  favouriteStore.assetsPair.maxPrice),
            ),
          ));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Unable to subscribe to currency ' +
                  favouriteStore.assetsPair.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class AnimationWidgetPainter extends CustomPainter {
  final List<double> _listValue;
  final double _minPrice;

  final double _maxPrice;
  final Color _color;

  AnimationWidgetPainter(
      this._listValue, this._color, this._minPrice, this._maxPrice);

  @override
  void paint(Canvas canvas, Size size) {
    if (_listValue.isNotEmpty) {
      var tmp = _listValue.getRange(
          _listValue.length < 80 ? 0 : _listValue.length - 80,
          _listValue.length);
      List tmp1 = tmp.toList();
      tmp1.sort();
      var minListValue = tmp1.first;
      var maxListValue = tmp1.last;

      final paintBorder = Paint()
        ..color = Colors.purpleAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final step = size.width / 100;
      var index = 0.0;

      final paint = Paint()
        ..color = _color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final min = (_minPrice == -1) ? minListValue : _minPrice;
      final max = (_maxPrice == -1) ? maxListValue : _maxPrice;

      canvas.drawLine(
          Offset(-size.width / 2, 20), Offset(size.width, 20), paintBorder);
      canvas.drawLine(
          Offset(-size.width / 2, 260), Offset(size.width, 260), paintBorder);

      var list = <double>[];
      tmp = _listValue.getRange(
          _listValue.length < 80 ? 0 : _listValue.length - 80,
          _listValue.length);
      for (var element in tmp) {
        list.add(20 + (240 * (element - min)) / (max - min));
      }

      final path = Path()..moveTo(-size.width / 2, 0);
      for (var element in list) {
        path.lineTo(index, element);
        index += step;
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
