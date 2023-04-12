// ignore: import_of_legacy_library_into_null_safe
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/main.dart';
import 'package:tflite/tflite.dart';

class Sad extends StatefulWidget {
  @override
  _SadState createState() => _SadState();
}

class _SadState extends State<Sad> {
  CameraImage cameraImage;
  CameraController cameraController;
  String output = '';

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadmodel();
  }

  loadCamera() {
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  int sad_score = 0;
  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);

      predictions.forEach((element) {
        setState(() {
          output = element['label'];
          if (output == '1 sad') {
            sad_score += 1;
          }
        });
      });
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('CopyMe', style: TextStyle(fontSize: 20))),
        body: Column(children: [
          SizedBox(height: 20),
          Row(children: [
            Column(children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Image.asset("assets/images/Sad.jpeg",
                          fit: BoxFit.fill))),
              Text(" Sad ", style: TextStyle(fontSize: 27))
            ]),
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: !cameraController.value.isInitialized
                            ? Container()
                            : AspectRatio(
                                aspectRatio: cameraController.value.aspectRatio,
                                child: CameraPreview(cameraController)))),
                Text(output,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
              ],
            )
          ]),
          SizedBox(height: 20),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              actions: [
                                // ignore: deprecated_member_use
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("surprise");
                                    },
                                    child: Text("Next"))
                              ],
                              title: Text("Great!"),
                              content: Text("Score: " +
                                  sad_score.toString() +
                                  "                                     You copied this emotion correctly *_^ "));
                        });
                  },
                  child: Text("Next emotion ..")))
        ]));
  }
}
