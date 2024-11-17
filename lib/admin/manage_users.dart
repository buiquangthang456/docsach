import 'package:flutter/material.dart';

class ManageUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Người dùng'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Người dùng 1'),
            subtitle: Text('Email: user1@example.com'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Chỉnh sửa người dùng
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Xóa người dùng
                  },
                ),
              ],
            ),
          ),
          // Thêm các người dùng khác...
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thêm người dùng mới
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
