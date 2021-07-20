import 'package:cripto_market/app/ui/pages/list_widget.dart';
import 'package:cripto_market/app/ui/pages/search_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketPage extends StatelessWidget {
  MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(6),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: SearchWidget(),
              ),
              Expanded(
                flex: 10,
                child:   ListWidget(),
              ),
            ]));
  }
}



