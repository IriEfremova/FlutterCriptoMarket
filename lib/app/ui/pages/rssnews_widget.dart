import 'package:cripto_market/app/state/rssnews/rss_store.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class RssNewsWidget extends StatelessWidget {
  final height;

  RssNewsWidget(this.height);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final newsStore = Provider.of<RssStore>(context);
      return Container(
          padding: EdgeInsets.all(6),
          color: CustomColors.black,
          height: height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'In World:',
                      style: TextStyle(fontSize: 14, color: Colors.amber),
                    )),
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                      itemCount: newsStore.rssNewsList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return ListTile(
                            contentPadding: EdgeInsets.all(6),
                            leading: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                            tileColor: index % 2 == 0
                                ? Colors.black54
                                : Colors.black38,
                            title: Text(
                                newsStore.rssNewsList.elementAt(index).title),
                            onTap: () {});
                      }),
                ),
              ]));
    });
  }
}