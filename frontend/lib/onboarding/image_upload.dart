import 'dart:io';
import 'dart:math' as math;
import 'package:catalyst/utils/text_fade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  UploadTask? _uploadTask;
  bool nextButtonEnabled = false;
  String buttonUnenabledMsg = '';
  bool _isUploading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final currentUserId = user?.uid;

    Future<void> _pickAndUploadImage(String userId) async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isUploading = true;
        });

        try {
          final ref =
              FirebaseStorage.instance.ref().child('user_images/$userId');
          _uploadTask = ref.putFile(_image!);

          final snapshot = await _uploadTask!.whenComplete(() {
            setState(() {
              _isUploading = false; // Stop uploading
            });
          });
          final url = await snapshot.ref.getDownloadURL();
          print('Download URL: $url');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload complete!'),
              duration: Duration(seconds: 2),
            ),
          );
          nextButtonEnabled = true;
        } catch (e) {
          print(e);
          setState(() {
            _isUploading = false; // Stop uploading
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error occurred during upload.'),
            ),
          );
        }
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.325),
            const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                child: Icon(Icons.emoji_emotions, size: 50)),
            const SizedBox(height: 20),
            const Text('Profile image',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Every user profile requires an image. Please upload one below.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            // if (_image != null) Image.file(_image!),
            SizedBox(height: 25),
            CupertinoButton(
                onPressed: () => _pickAndUploadImage(currentUserId.toString()),
                color: Color(0xff09CBC8),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: SizedBox(
                  height: 35,
                  width: 175,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload),
                      SizedBox(width: 5),
                      Text(
                        'Upload images',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 25),
            if (_isUploading) CircularProgressIndicator(),
            SizedBox(height: 25),
            if (!nextButtonEnabled)
              Text(buttonUnenabledMsg,
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
              child: SizedBox(
                  height: 75,
                  width: 75,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(width: 3.5, color: Colors.transparent),
                        gradient: const LinearGradient(
                          transform: GradientRotation(math.pi / 4),
                          colors: [
                            Color(0xff7301E4),
                            Color(0xff0E8BFF),
                            Color(0xff09CBC8),
                            Color(0xff33D15F),
                          ],
                        )),
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: TextButton(
                        child: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black),
                        onPressed: () {
                          if (nextButtonEnabled == true) {
                            setState(() {
                              buttonUnenabledMsg = '';
                            });
                            Navigator.pushNamed(context, '/hobbies');
                          } else {
                            setState(() {
                              buttonUnenabledMsg =
                                  'An image must be uploaded to continue.';
                            });
                          }
                        },
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
