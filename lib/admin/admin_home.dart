import 'package:flutter/material.dart';
import 'package:rbooks/services/auth_service.dart'; // Import AuthService
import 'package:rbooks/admin/upload_image.dart'; // Import màn hình upload ảnh
import 'package:rbooks/screen/home.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Admin'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Quản lý Sách'),
            onTap: () {
              Navigator.pushNamed(context, '/manage-books');
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Quản lý Người dùng'),
            onTap: () {
              Navigator.pushNamed(context, '/manage-users');
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Upload Ảnh'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadImageScreen()), // Mở màn hình upload ảnh
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Giao diện Người dùng'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()), // Mở giao diện trang chủ người dùng
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
