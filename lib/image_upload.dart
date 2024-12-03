import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ValueNotifier<File?> _imageNotifier = ValueNotifier<File?>(null);

  // Method to pick an image from the camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final permissionGranted = await _requestPermission(source);

    if (permissionGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        _imageNotifier.value = File(pickedFile.path); // Update image using ValueNotifier
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
          title: const Center(
            child: Icon(
              Icons.camera_alt,
              size: 40,
              color: Colors.blue,
            ),
          ),
          content: const Text('Allow Radical Start to take pictures and record videos?',textAlign:TextAlign.center,),
          
          actions: [
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, PermissionStatus.limited);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('WHILE USING THE APP', textAlign:TextAlign.center,),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, PermissionStatus.granted);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('ONLY THIS TIME', textAlign:TextAlign.center,),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, PermissionStatus.denied);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('DONT ALLOW', textAlign:TextAlign.center,),
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
  void dispose() {
    _imageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    // ignore: unused_local_variable
    final screenWidth = mediaQuery.size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: null,
        toolbarHeight: screenHeight * 0.15,
          //flexibleSpace: Padding(
            //padding: EdgeInsets.all(screenWidth * 0.02),
            //child: Align(
              //alignment: Alignment.topLeft,
              //child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLS83XErb0zP7lBJnTQv9C2onf30pSb7PFgfO7G-0HRYv4THiKre-UvZ2k_0t0dUFDrAo&usqp=CAU',
              //height: screenHeight *0.1,
              //fit:BoxFit.contain,
              //),
            //),
          //),
        centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: LayoutBuilder(
          builder: (context,constraints) {

          final screenHeight=constraints.maxHeight;
          final screenWidth=constraints.maxWidth;
        return Center(
        
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Upload Image',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showImagePickerModal(context),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: ValueListenableBuilder<File?>(
                      valueListenable: _imageNotifier,
                      builder: (context, image, child) {
                        return image == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey,
                              )
                            : Image.file(image);
                      },
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<File?>(
                valueListenable: _imageNotifier,
                builder: (context, image, child) {
                  return image != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: screenWidth * 0.03 ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _showImagePickerModal(context),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // Handle saving the image
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Image saved successfully!')),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        );
          },
        ),
      ),
    );
  }
}