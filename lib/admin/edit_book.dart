import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:rbooks/services/cloudinary_service.dart'; // Sử dụng CloudinaryService

class EditBookScreen extends StatefulWidget {
  final String bookId;
  final Map<String, dynamic> bookData;

  EditBookScreen({required this.bookId, required this.bookData});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late TextEditingController pdfUrlController;

  File? _selectedImage; // Ảnh được chọn
  String? _uploadedImageUrl; // URL ảnh đã upload

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.bookData['title']);
    authorController = TextEditingController(text: widget.bookData['author']);
    categoryController = TextEditingController(text: widget.bookData['category']);
    descriptionController = TextEditingController(text: widget.bookData['description']);
    pdfUrlController = TextEditingController(text: widget.bookData['pdf_url']);
    _uploadedImageUrl = widget.bookData['cover_url']; // URL ảnh ban đầu
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    pdfUrlController.dispose();
    super.dispose();
  }

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
          _uploadedImageUrl = imageUrl; // Cập nhật URL ảnh đã upload
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

  /// Cập nhật thông tin sách
  Future<void> _updateBook() async {
    final title = titleController.text.trim();
    final author = authorController.text.trim();
    final category = categoryController.text.trim();
    final description = descriptionController.text.trim();
    final pdfUrl = pdfUrlController.text.trim();

    if (title.isNotEmpty &&
        author.isNotEmpty &&
        category.isNotEmpty &&
        description.isNotEmpty &&
        pdfUrl.isNotEmpty &&
        _uploadedImageUrl != null) {
      try {
        await FirebaseFirestore.instance.collection('books').doc(widget.bookId).update({
          'title': title,
          'author': author,
          'category': category,
          'description': description,
          'cover_url': _uploadedImageUrl, // URL ảnh mới
          'pdf_url': pdfUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật sách thành công')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật sách: $e')),
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
        title: Text('Chỉnh sửa Sách'),
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

              // Hiển thị ảnh bìa
              _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                height: 150,
              )
                  : _uploadedImageUrl != null
                  ? Image.network(
                _uploadedImageUrl!,
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
              ElevatedButton(
                onPressed: _uploadToCloudinary,
                child: Text('Upload Ảnh Bìa'),
              ),
              SizedBox(height: 32),

              // Nút cập nhật sách
              ElevatedButton(
                onPressed: _updateBook,
                child: Text('Cập nhật Sách'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
