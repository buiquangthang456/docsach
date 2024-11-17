import 'package:flutter/material.dart';
import 'package:rbooks/services/auth_service.dart'; // Import AuthService
import 'register.dart'; // Import giao diện đăng ký

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService(); // Khởi tạo AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                try {
                  // Gọi hàm đăng nhập từ AuthService
                  String role = await authService.signIn(email, password);

                  // Phân quyền dựa vào role
                  if (role == 'admin') {
                    Navigator.pushReplacementNamed(context, '/admin-home');
                  } else if (role == 'user') {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Role không xác định!')),
                    );
                  }
                } catch (error) {
                  // Hiển thị lỗi nếu đăng nhập thất bại
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${error.toString()}')),
                  );
                }
              },
              child: Text('Đăng nhập'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Điều hướng sang giao diện đăng ký
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: Text('Chưa có tài khoản? Đăng ký ngay!'),
            ),
          ],
        ),
      ),
    );
  }
}
