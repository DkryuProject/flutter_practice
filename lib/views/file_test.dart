import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class FilePickerTest extends StatefulWidget {
  const FilePickerTest({Key? key}) : super(key: key);

  @override
  FilePickerTestState createState() => FilePickerTestState();
}

class FilePickerTestState extends State<FilePickerTest> {
  String showFileName = "No file selected";
  Color defaultColor = Colors.blue;
  bool isUploading = false;
  final Dio dio = Dio(); // ✅ Dio 인스턴스 생성
  final ImagePicker _picker = ImagePicker(); // ✅ ImagePicker 인스턴스 생성

  Future<void> uploadFile(File file) async {
    setState(() {
      isUploading = true;
    });

    try {
      var formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });

      var response = await dio.post(
        "https://your-api.com/upload", // ✅ 업로드할 API 엔드포인트
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint("Upload successful: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Upload successful: ${response.data['message']}")),
        );
      } else {
        debugPrint("Upload failed: ${response.statusMessage}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${response.statusMessage}")),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> pickAndUploadFile() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // ✅ 갤러리에서 이미지 선택

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      setState(() {
        showFileName = "Now File Name: ${file.path.split('/').last}";
      });

      await uploadFile(file);
    }
  }

  Container makeFilePicker() {
    return Container(
      width: double.infinity,
      height: 200.0,
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: defaultColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isUploading ? null : pickAndUploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Find and Upload"),
                        const SizedBox(width: 5),
                        const Icon(Icons.upload_rounded),
                      ],
                    ),
            ),
            Text(
              "(*.jpg, *.png, *.gif, etc.)",
              style: TextStyle(color: defaultColor),
            ),
            const SizedBox(height: 10),
            Text(
              showFileName,
              style: TextStyle(color: defaultColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Picker & Upload")),
      body: Center(child: makeFilePicker()),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FilePickerTest(),
  ));
}
