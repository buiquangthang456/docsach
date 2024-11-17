import 'package:flutter/material.dart';
import 'package:rbooks/services/auth_service.dart'; // Import AuthService

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController(); // Thêm tên người dùng

  final AuthService authService = AuthService(); // Khởi tạo AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Tên'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
                  );
                  return;
                }

                await authService.registerWithRole(email, password, name, 'user'); // Role mặc định là 'user'

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đăng ký thành công!')),
                );

                // Chuyển về màn hình đăng nhập
                Navigator.pop(context);
              },
              child: Text('Đăng ký'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Quay lại giao diện đăng nhập
                Navigator.pop(context);
              },
              child: Text('Đã có tài khoản? Đăng nhập ngay!'),
            ),
          ],
        ),
      ),
    );
  }
}
