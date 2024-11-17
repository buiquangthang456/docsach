import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_book.dart';
import 'edit_book.dart';

class ManageBooksScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Sách'),
      ),
      body: StreamBuilder(
        stream: firestore.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final books = snapshot.data!.docs;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final bookData = book.data() as Map<String, dynamic>;

              return ListTile(
                leading: bookData['cover_url'] != null
                    ? Image.network(
                  bookData['cover_url'], // URL ảnh bìa từ Firestore
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                )
                    : Icon(Icons.book), // Icon mặc định nếu không có ảnh
                title: Text(bookData['title'] ?? 'Không có tiêu đề'),
                subtitle: Text('Tác giả: ${bookData['author'] ?? 'Không có tác giả'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Điều hướng sang màn hình chỉnh sửa sách
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBookScreen(
                              bookId: book.id,
                              bookData: bookData,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        // Xóa sách
                        await firestore.collection('books').doc(book.id).delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng sang màn hình thêm sách
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
