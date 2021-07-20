import 'package:cripto_market/app/ui/pages/favourite_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'events_widget.dart';

class FavouritePage extends StatelessWidget {
  FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contextL, constraints) {
      return Container(
        child: Column(
          children: <Widget>[
            UserEventWidget(),
            FavouriteWidget(constraints.maxHeight - 150 - 18),
          ],
        ),
      );
    });
  }
}

