import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motoveys/Screens/cameraScreen.dart';
import 'package:motoveys/models/dataItemModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';

class UploadDocumentMainScreen extends StatefulWidget {
  final ClaimsDashboardItems selectedItem;
  const UploadDocumentMainScreen({required this.selectedItem});

  @override
  State<UploadDocumentMainScreen> createState() {
    return _UploadDocumentsScreen();
  }
}

class _UploadDocumentsScreen extends State<UploadDocumentMainScreen> {
  late PlatformFile? _pickedFile;
  Future pickFileFunction(String documentName) async {
    // final result = await
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        _saveFile(file, documentName);
        print('File picked: ${result.files.single.name}');
      } else {
        print('File picking canceled.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> _saveFile(File file, String documentName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String folderName = widget.selectedItem.requestNumber;

    Directory itemDirectory = Directory('${directory.path}/$folderName');
    if (!await itemDirectory.exists()) {
      await itemDirectory.create(recursive: true);
    }

    String fileName = '${documentName.replaceAll(' ', '_')}.pdf';
    String filePath = '${itemDirectory.path}/$fileName';
    await file.copy(filePath);

    print('File saved: $fileName');
  }

  Future openCameraFunction(String documentName) async {
    // print('Camera button pressed');
    // final cameras = await availableCameras();
    // final firstCamera = cameras.first;
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            camera: firstCamera,
            onPictureTaken: (File file) {
              _saveFile(file, documentName);
            },
          ),
        ),
      );
    } catch (e) {
      print('Error opening camera: $e');
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CameraScreen(camera: firstCamera),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    double widthAllowed = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Claim Processing'),
              const SizedBox(height: 5),
              Text(widget.selectedItem.requestNumber)
            ],
          ),
          backgroundColor: Color(0xFF610361),
        ),
        body: Container(
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
          width: widthAllowed,
          padding: EdgeInsets.only(left: 10),
          // child: Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   // mainAxisSize: widthAllowed,
          //   children: [
          //     const Text(
          //       "Ganpati Bappa Morya",
          //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          //     ),
          //     SizedBox(width: widthAllowed / 2.5),
          //     // FloatingActionButton(onPressed: pickFileFunction)
          //     IconButton(
          //       onPressed: pickFileFunction,
          //       icon: Icon(Icons.upload_file),
          //     ),

          //     IconButton(
          //       onPressed: pickFileFunction,
          //       icon: Icon(Icons.camera_alt_outlined),
          //     ),
          //     IconButton(
          //       onPressed: pickFileFunction,
          //       icon: Icon(Icons.photo_size_select_actual_outlined),
          //     )
          //   ],
          // ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Upload",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                _buildRow("Claim Form", widthAllowed),
                _buildRow("Crash Photos", widthAllowed),
                _buildRow("Driving License", widthAllowed),
                _buildRow("Estimate", widthAllowed),
                _buildRow("KYC Doc Address Proof", widthAllowed),
                _buildRow("KYC Doc Id Proof", widthAllowed),
                _buildRow("KYC Recent Photo", widthAllowed),
                _buildRow("KYC First Impression \n Internal", widthAllowed),
                _buildRow("RC Book", widthAllowed),
                _buildRow("Repair Bill", widthAllowed),
                _buildRow("Survey Fees Bill", widthAllowed)
              ],
            ),
          ),
        ));
  }

// building  fumctions for building multiple rows
  Widget _buildRow(String text, double givenWidth) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: const Color.fromARGB(54, 0, 0, 0), width: 1.5))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(width: givenWidth / 1.9),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //   onPressed: pickFileFunction,
                //   icon: Icon(Icons.upload_file),
                // ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Color.fromARGB(255, 107, 9, 116),
                    ),
                    onPressed: () => pickFileFunction(text),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(121, 12, 12, 1),
                            Color.fromARGB(255, 202, 32, 32)
                          ],
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.upload_file_outlined,
                        size: 20,
                      ),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Color.fromARGB(255, 107, 9, 116),
                    ),
                    onPressed: () => openCameraFunction(text),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(112, 12, 121, 1),
                            Color.fromARGB(255, 32, 35, 202)
                          ],
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 20,
                      ),
                    )),

                // IconButton(
                //   onPressed: pickFileFunction,
                //   icon: Icon(Icons.camera_alt_outlined),
                // ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Color.fromARGB(255, 107, 9, 116),
                    ),
                    onPressed: () => pickFileFunction(text),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(112, 12, 121, 1),
                            Color.fromARGB(255, 32, 35, 202)
                          ],
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.photo_size_select_actual_outlined,
                        size: 20,
                      ),
                    )),
                // IconButton(
                //   onPressed: pickFileFunction,
                //   icon: Icon(Icons.photo_size_select_actual_outlined),
                // ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
