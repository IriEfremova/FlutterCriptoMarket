import 'package:cripto_market/app/state/marketlist/marketlist_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final marketStore = Provider.of<MarketListStore>(context);
    return Container(
      padding: EdgeInsets.only(left: 5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 26, 25, 39),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (String value) {
                marketStore.setSearchText(value);
              },
            ),
          ),
          IconButton(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () {marketStore.setSearchText('');
            _controller.clear();},
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
