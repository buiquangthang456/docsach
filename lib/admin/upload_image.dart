import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart'; // Đảm bảo đường dẫn đúng

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _selectedImage;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Upload ảnh lên Cloudinary
  Future<void> _uploadImageToCloudinary() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn ảnh trước khi upload')),
      );
      return;
    }

    try {
      final cloudinaryService = CloudinaryService();
      final imageUrl = await cloudinaryService.uploadImage(_selectedImage!);

      if (imageUrl != null) {
        setState(() {
          _uploadedImageUrl = imageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload ảnh thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload ảnh thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi upload ảnh: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Ảnh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              height: 200,
            )
                : Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Text('Chưa chọn ảnh'),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Chọn Ảnh'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImageToCloudinary,
              child: Text('Upload Ảnh'),
            ),
            SizedBox(height: 16),
            _uploadedImageUrl != null
                ? Text(
              'URL ảnh: $_uploadedImageUrl',
              textAlign: TextAlign.center,
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
