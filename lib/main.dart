import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni/data/animal_data.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimalsPage(),
    );
  }
}

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({Key? key}) : super(key: key);

  @override
  _AnimalsPageState createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  List<Map> _animalInfo = AnimalData().animalInfo;
  String _animalImage = '';
  String _animalDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Animals"),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, _) {
            return MediaQuery.of(context).orientation == Orientation.portrait
                ? _pageBuilder(Axis.vertical)
                : _pageBuilder(Axis.horizontal);
          },
        ));
  }

  _pageBuilder(scrollDirection) {
    return scrollDirection == Axis.horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageBuilder(scrollDirection),
              _buttonsBuilder(scrollDirection)
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _imageBuilder(scrollDirection),
              _buttonsBuilder(scrollDirection)
            ],
          );
  }

  _imageBuilder(scrollDirection) {
    return Flexible(
      flex: 1,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        children: [
          Container(
            height: scrollDirection == Axis.horizontal
                ? MediaQuery.of(context).size.height * 0.7
                : MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _animalImage != ""
                    ? Image(
                        image: NetworkImage(_animalImage),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.black,
                      )),
          ),
          Text(
            _animalDescription,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _buttonsBuilder(orientation) {
    return Flexible(
      flex: 1,
      child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _animalInfo.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 1,
            crossAxisSpacing: MediaQuery.of(context).size.width * 0.1,
            mainAxisSpacing: MediaQuery.of(context).size.width * 0.1,
          ),
          itemBuilder: (BuildContext context, index) {
            return ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () => _changePhoto(_animalInfo[index]['url'],
                    _animalInfo[index]['description']),
                child: Text(
                  _animalInfo[index]['name'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ));
          }),
    );
  }

  _changePhoto(String url, String desc) {
    setState(() {
      _animalImage = url;
      _animalDescription = desc;
    });
  }
}
