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

    return Container(
      color: Colors.black87,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: padding,
          crossAxisSpacing: padding,
          childAspectRatio: .9,
          children: const [
            Puzzle(),
            Puzzle(),
            Puzzle(),
            Puzzle(),
            Puzzle(),
            Puzzle(),
          ],
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

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: Colors.amber,
          ),
        ),
        SizedBox(height: padding),
        const Expanded(
          child: LinearProgressIndicator(
            color: Colors.amber,
            minHeight: 16,
            value: .5,
          ),
        )
      ],
    );
  }
}
