import 'package:cripto_market/app/core/repository/web_service_api.dart';
import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final WebServiceAPI _webService;

  const StatusWidget(this._webService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bit_image.jpg'),
            fit: BoxFit.fill,
          )),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
            future: _webService.fetchStatusServer(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              }
              return Padding(
                  padding: EdgeInsets.all(20), child: Text('Connect...'));
            },
          ),
        ),
      ),
    );
  }
}