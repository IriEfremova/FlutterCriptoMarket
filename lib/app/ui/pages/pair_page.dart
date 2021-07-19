import 'package:cripto_market/app/core/model/user_event.dart';
import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/state/userevents/userevents_store.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:cripto_market/app/ui/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PairPage extends StatelessWidget {
  const PairPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webChannel = Provider.of<WebChannelAPI>(context);
    final favouriteStore = Provider.of<FavoritesStore>(context);
    return MaterialApp(
        theme: mainThemeData,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: Image.asset('assets/images/bitkoin.png'),
              title: Text('Cripto Market'),
            ),
            body: LayoutBuilder(builder: (contextL, constraints) {
              return Container(
                child: Column(
                  children: <Widget>[
                    BaseWidget(),
                    AnimationWidget(
                        color: Colors.amber, widthWidget: constraints.maxWidth),
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        webChannel
                            .clearSubscribe(favouriteStore.assetsPair.name);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            })));
  }
}

class BaseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favouriteStore = Provider.of<FavoritesStore>(context);
    final userStore = Provider.of<UserEventsStore>(context);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(6),
      color: CustomColors.black,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(3),
                  child: Text(
                    'Currency: ${favouriteStore.assetsPair.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Minimum price: ',
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                          ),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Maximum price: ',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  favouriteStore.assetsPair.minPrice == -1
                                      ? ''
                                      : favouriteStore.assetsPair.minPrice
                                          .toString(),
                              keyboardType: TextInputType.number,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                fillColor: CustomColors.background,
                                filled: true,
                                border: const OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              onFieldSubmitted: (String value) {
                                if (value.isNotEmpty) {
                                  userStore.addToUserEvents(UserEvent(
                                      favouriteStore.assetsPair.name,
                                      userStore.currentTimeInSeconds(),
                                      'Update Minimum Price'));
                                  favouriteStore.assetsPair
                                      .updateMinPrice(double.tryParse(value));
                                  favouriteStore.updateFavoritesMinPrice(
                                      favouriteStore.assetsPair);
                                }
                              },
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  favouriteStore.assetsPair.maxPrice == -1
                                      ? ''
                                      : favouriteStore.assetsPair.maxPrice
                                          .toString(),
                              keyboardType: TextInputType.number,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                fillColor: CustomColors.background,
                                filled: true,
                                border: const OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              onFieldSubmitted: (String value) {
                                if (value.isNotEmpty) {
                                  userStore.addToUserEvents(UserEvent(
                                      favouriteStore.assetsPair.name,
                                      userStore.currentTimeInSeconds(),
                                      'Update Maximum Price'));
                                  favouriteStore.assetsPair
                                      .updateMaxPrice(double.tryParse(value));
                                  favouriteStore.updateFavoritesMaxPrice(
                                      favouriteStore.assetsPair);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

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
            //padding: EdgeInsets.all(20),
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
              "Unable to subscribe to currency " +
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
    final paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final paintBorder = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()..moveTo(-size.width / 2, 0);
    final step = size.width / 100;
    double index = 0;

    final min = (_minPrice == -1) ? _listValue.first - 10 : _minPrice;
    final max = (_maxPrice == -1 || _maxPrice <= _listValue.first) ? _listValue.first + 10 : _maxPrice;
    print('paint11 $min : $max');

    final tmp = _listValue.getRange(
        _listValue.length < 80 ? 0 : _listValue.length - 80, _listValue.length);
    List<double> list = <double>[];
    // tmp.forEach((element) => list.add(element - _listValue.first));
    tmp.forEach(
        (element) => list.add(20 + (240 * (element - min)) / (max - min)));

    print('paint ${list.toString()}');

    index = 0;
    list.forEach((element) {
      path.lineTo(index, element);
      index += step;
    });

    //final stepVert = value  / (_maxPrice - _minPrice) / 240;
    canvas.drawPath(path, paint);
    canvas.drawLine(
        Offset(-size.width / 2, 20), Offset(size.width, 20), paintBorder);
    canvas.drawLine(
        Offset(-size.width / 2, 260), Offset(size.width, 260), paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
