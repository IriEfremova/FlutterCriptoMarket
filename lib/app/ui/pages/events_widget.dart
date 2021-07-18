import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/state/userevents/userevents_store.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class UserEventWidget extends StatelessWidget {
  List<String> listEvent = <String>[];

  @override
  Widget build(BuildContext context) {
    final userEventsStore = Provider.of<UserEventsStore>(context);

    return Observer(builder: (context) {
      return Container(
          margin: EdgeInsets.all(6),
          padding: EdgeInsets.all(6),
          color: CustomColors.black,
          height: 150,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        'Your Events:',
                        style: TextStyle(fontSize: 14, color: Colors.amber),
                      )),
                      Flexible(child:
                        Container(
                        child: TextButton(
                          child: const Text('Clear', style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            userEventsStore.removeFromUserEvents();
                          },
                        ),)
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: userEventsStore.userEventsList.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.waves,
                            color: Colors.grey,
                            size: 24.0,
                          ),
                        )
                      : ListView.builder(
                          itemCount: userEventsStore.userEventsList.length,
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
                                title: Text(userEventsStore.userEventsList
                                    .elementAt(index)),
                                onTap: () {});
                          }),
                ),
              ]));
    });
  }
}
