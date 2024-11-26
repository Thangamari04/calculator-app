import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;

  // Method to pick an image from the camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final permissionGranted = await _requestPermission(source);

    if (permissionGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Save file as File
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied. Please allow access.')),
      );
    }
  }

  // Request permission for camera or gallery
  Future<bool> _requestPermission(ImageSource source) async {
    Permission permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    if (await permission.isGranted) {
      return true;
    }

    // Show the permission dialog with three options: Allow, While Using, Don't Allow
    final result = await showDialog<PermissionStatus>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Center (
            child: Icon(Icons.camera_alt,
            size: 40,
            color: Colors.green,),
          ),
          content: const Text(
              'Allow to take pictures and record videos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, PermissionStatus.granted);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('Allow'),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, PermissionStatus.limited);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('While Using the App'),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, PermissionStatus.denied);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('Don\'t Allow'),
            ),

          ],
        );
      },
    );

    if (result == PermissionStatus.granted) {
      permission.request();
      return true;
    } else if (result == PermissionStatus.limited) {
      permission.request();
      return true;
    } else if (result == PermissionStatus.denied) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied permanently.')),
      );
      return false;
    }
    return false;
  }

  
  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },),
            centerTitle: false,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Take a photo of document',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please ensure the photo is clear and visible.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showImagePickerModal(context),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: _image == null 
                        ?const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey,
                          )
                          :Image.file(_image!),

                  ),
                ),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white,),
                          onPressed: () => _showImagePickerModal(context),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                        onPressed: () {
                          // Handle saving the image
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Image saved successfully!')),
                          );
                        },
                        icon: const Icon(Icons.check_circle, color: Colors.white,),
                      ),
                      
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}