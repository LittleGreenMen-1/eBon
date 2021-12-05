import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Barcode? result;
  Barcode? prev_result;
  QRViewController? controller;

  var storage =
      FirebaseStorage.instanceFor(bucket: 'gs://ebon-ae7b8.appspot.com');
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Dio downloader = Dio();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void UploadToFirebase(String filename) async {
    print("UPLOADING TO FIREBASE");

    String pdfName = filename
        .substring(filename.lastIndexOf("/"), filename.lastIndexOf("."))
        .replaceAll("/", "");

    final Directory systemTempDir = Directory.systemTemp;

    final byteData = await File(filename).readAsBytes();
    final file = File('${systemTempDir.path}/$pdfName.pdf');

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    TaskSnapshot snapshot =
        await storage.ref().child("Receipts/$pdfName").putFile(file);

    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      print(downloadUrl);
      await FirebaseFirestore.instance
          .collection("Receipts")
          .add({"url": downloadUrl, "name": pdfName});
    } else {
      print('Error from image repo ${snapshot.state.toString()}');
      throw ('This file is not an image');
    }
  }

  void processReceipt(String pathToPDF) async {
    PdfDocument document =
        PdfDocument(inputBytes: await File(pathToPDF).readAsBytes());

    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();

    RegExp regEx = new RegExp(r"");
    var match = regEx.firstMatch(text);
    var matchedText = match?.group(0);

    // Get name
    String name = text.split("\n")[0];

    // Get TOTAL
    regEx = new RegExp(r"TOTAL(|:)\s*[0-9]{1,9}(.|,)?[0-9]*",
        caseSensitive: true, multiLine: false);

    match = regEx.firstMatch(text);
    matchedText = match?.group(0);

    String total = matchedText.toString();

    regEx = new RegExp(r"[0-9.,]+", caseSensitive: true, multiLine: false);
    match = regEx.firstMatch(total);
    matchedText = match?.group(0);

    total = matchedText.toString();
    total = total.replaceAll(",", ".");

    print("TOTAL allMatches : " + matchedText.toString());

    // Get date
    regEx = new RegExp(r"[0-9]{2}[-.\\\/][0-9]{2}[-.\\\/](?:\d{4}|\d{2})",
        caseSensitive: true, multiLine: false);

    match = regEx.firstMatch(text);
    matchedText = match?.group(0);

    String date = matchedText.toString();

    print("DATE allMatches : " + matchedText.toString());

    // Get time
    regEx = new RegExp(r"[0-9]{2}[:][0-9]{2}([:][0-9]{2})?",
        caseSensitive: true, multiLine: false);

    match = regEx.firstMatch(text);
    matchedText = match?.group(0);

    String time = matchedText.toString();

    print("HOUR allMatches : " + matchedText.toString());

    // Get category
    String category = pathToPDF.split("_")[1];

    print("CATEGORY : " + category);

    String pdfName = pathToPDF
        .substring(pathToPDF.lastIndexOf("/"), pathToPDF.lastIndexOf("."))
        .replaceAll("/", "");
    pdfName += "_json";

    print(pdfName);

    var json = {
      "name": name,
      "total": total,
      "date": date,
      "time": time,
      "category": category
    };

    var jsonString = jsonEncode(json);

    final Directory systemTempDir = Directory.systemTemp;

    final byteData = Uint8List.fromList(utf8.encode(jsonString));
    final file = File('${systemTempDir.path}/$pdfName.json');

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    TaskSnapshot snapshot =
        await storage.ref().child("Data/$pdfName").putFile(file);

    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      print(downloadUrl);
      await FirebaseFirestore.instance
          .collection("Data")
          .add({"url": downloadUrl, "name": pdfName});
    } else {
      print('Error from image repo ${snapshot.state.toString()}');
      throw ('This file is not an image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          /*Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text('Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await Permission.storage.request().isGranted) {
                              String filename = basename(result!.code!);
                              String full_path = '/storage/emulated/0/Download/eBon/receipts/${filename}.pdf';

                              await downloader.download(result!.code!, full_path);
                              UploadToFirebase(full_path);
                            }
                          },
                          child: const Text('SCAAAn',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )*/
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.lightBlue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.9),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null && result != prev_result) {
          prev_result = result;

          downloadQR();
        }
      });
    });
  }

  void downloadQR() async {
    if (await Permission.storage.request().isGranted) {
      String filename = basename(result!.code!);
      String full_path =
          '/storage/emulated/0/Download/eBon/receipts/${filename}.pdf';

      try {
        await downloader.download(result!.code!, full_path);
        UploadToFirebase(full_path);
        processReceipt(full_path);
      } catch (e) {
        print(e);
      }
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
