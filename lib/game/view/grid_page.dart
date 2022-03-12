import 'package:flutter/material.dart';

class GridPage extends StatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var padding = deviceData.size.width * .015;
    const numCols = 3;
    const numRows = 1;

    var widgets = <Widget>[];

    for (var i = 0; i < numRows; i++) {
      var children = <Widget>[];

      for (var i = 0; i < numCols; i++) {
        children.add(const Puzzle());
      }

      var row = Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
        flex: 1,
      );

      widgets.add(row);
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widgets,
          ),
        ),
      ),
    );
  }
}

class Puzzle extends StatelessWidget {
  const Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var padding = deviceData.size.width * .008;

    return Expanded(
      flex: 1,
      child: Center(
        child: AspectRatio(
          aspectRatio: .9,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: padding / 2),
                const Expanded(
                  child: LinearProgressIndicator(
                    color: Colors.amber,
                    minHeight: 16,
                    value: .5,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
