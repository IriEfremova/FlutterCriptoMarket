import 'package:cripto_market/app/core/repository/web_service_api.dart';
import 'package:cripto_market/app/ui/pages/events_widget.dart';
import 'package:cripto_market/app/ui/pages/rssnews_widget.dart';
import 'package:cripto_market/app/ui/pages/status_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final WebServiceAPI _webService;
  const HomePage(this._webService, {Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contextL, constraints) {
      return Container(
        child: Column(
          children: <Widget>[
            StatusWidget(_webService),
            UserEventWidget(),
            RssNewsWidget(constraints.maxHeight - 12 - 230),
          ],
        ),
      );
    });
  }
}




