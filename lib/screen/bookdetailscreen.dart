import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String author;
  final String cover;
  final String description;

  const BookDetailScreen({
    required this.title,
    required this.author,
    required this.cover,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Ảnh bìa
          Image.network(
            cover,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          ),
          SizedBox(height: 16),

          // Tiêu đề sách
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          // Tác giả
          Text(
            'Tác giả: $author',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16),

          // Mô tả sách
          Text(
            description,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
