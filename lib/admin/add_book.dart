import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rbooks/services/cloudinary_service.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pdfUrlController = TextEditingController();

  File? _selectedImage; // File được chọn
  String? _uploadedImageUrl; // URL ảnh sau khi upload

  final ImagePicker _picker = ImagePicker();

  /// Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  /// Upload ảnh lên Cloudinary
  Future<void> _uploadToCloudinary() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn ảnh bìa')),
      );
      return;
    }

    try {
      final cloudinaryService = CloudinaryService();
      final imageUrl = await cloudinaryService.uploadImage(_selectedImage!);

      if (imageUrl != null) {
        setState(() {
          _uploadedImageUrl = imageUrl; // Lưu URL đã upload
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload ảnh thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi upload ảnh')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }


  /// Thêm sách
  Future<void> _addBook() async {
    final title = titleController.text.trim();
    final author = authorController.text.trim();
    final category = categoryController.text.trim();
    final description = descriptionController.text.trim();
    final pdfUrl = pdfUrlController.text.trim();

    if (title.isNotEmpty &&
        author.isNotEmpty &&
        category.isNotEmpty &&
        description.isNotEmpty &&
        _uploadedImageUrl != null &&
        pdfUrl.isNotEmpty) {
      try {
        // Lưu dữ liệu vào Firestore
        await FirebaseFirestore.instance.collection('books').add({
          'title': title,
          'author': author,
          'category': category,
          'description': description,
          'cover_url': _uploadedImageUrl, // URL ảnh từ Cloudinary
          'pdf_url': pdfUrl,
          'created_at': FieldValue.serverTimestamp(), // Thời gian tạo
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm sách thành công')),
        );
        Navigator.pop(context); // Quay lại màn hình trước
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thêm sách: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Sách'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Tên sách'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Tác giả'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Thể loại'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: pdfUrlController,
                decoration: InputDecoration(labelText: 'URL PDF'),
              ),
              SizedBox(height: 16),

              // Hiển thị ảnh đã chọn
              _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                height: 150,
              )
                  : SizedBox.shrink(),

              SizedBox(height: 16),

              // Nút chọn ảnh
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Chọn Ảnh Bìa'),
              ),
              SizedBox(height: 16),

              // Nút upload ảnh
              // Nút upload ảnh
              ElevatedButton(
                onPressed: _uploadToCloudinary, // Đổi tên thành _uploadToCloudinary
                child: Text('Upload Ảnh Bìa'),
              ),
              SizedBox(height: 32),

              // Nút thêm sách
              ElevatedButton(
                onPressed: _addBook,
                child: Text('Thêm Sách'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
