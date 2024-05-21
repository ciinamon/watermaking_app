import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_watermark/image_watermark.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final _picker = ImagePicker();
  Uint8List? imgMaster;
  Uint8List? imgWatermark;
  Uint8List? imgGenerated;
  XFile? _image;
  bool isLoading = false;
  String imgname = "empty";

  chooseImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _image = image;
      var t = await image.readAsBytes();
      imgMaster = Uint8List.fromList(t);
    }
    setState(() {});
  }

  chooseWatermark() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _image = image;
      imgname = image.name;
      var t = await image.readAsBytes();
      imgWatermark = Uint8List.fromList(t);
    }
    setState(() {});
  }

  generate() async {
    isLoading = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    imgGenerated = await ImageWatermark.addImageWatermark(
      originalImageBytes: imgMaster!,
      waterkmarkImageBytes: imgWatermark!,
      dstX: 10,
      dstY: 10,
      imgHeight: 100,
      imgWidth: 100,
    );
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watermaking App'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => chooseImage(),
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    width: 600,
                    height: 250,
                    child: _image == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo),
                              SizedBox(height: 10),
                              Text('Click here to choose image')
                            ],
                          )
                        : Image.memory(imgMaster!, width: 600, height: 200, fit: BoxFit.fitHeight),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => chooseWatermark(), child: const Text('choose watermark')),
                const SizedBox(height: 10),
                Text(imgname),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: imgMaster == null || imgWatermark == null ? null : () => generate(),
                  child: const Text('generate'),
                ),
                const SizedBox(height: 10),
                isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
                imgGenerated == null ? const SizedBox.shrink() : Image.memory(imgGenerated!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
