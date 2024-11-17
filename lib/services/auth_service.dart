import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Đăng nhập người dùng
  Future<String> signIn(String email, String password) async {
    try {
      // Đăng nhập với Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy userId từ kết quả đăng nhập
      String userId = userCredential.user!.uid;

      // Lấy thông tin user từ Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        print('Đăng nhập thành công với vai trò: $role');

        // Trả về vai trò để sử dụng trong giao diện
        return role;
      } else {
        throw Exception('Tài khoản không hợp lệ');
      }
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi Firebase Authentication
      if (e.code == 'user-not-found') {
        throw Exception('Không tìm thấy tài khoản này.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Sai mật khẩu. Vui lòng thử lại.');
      } else {
        throw Exception('Lỗi đăng nhập: ${e.message}');
      }
    } catch (e) {
      // Xử lý lỗi khác
      throw Exception('Lỗi không xác định: $e');
    }
  }


  /// Đăng ký người dùng mới
  Future<void> registerWithRole(String email, String password, String name, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'name': name,
        'password': password, // Không khuyến khích lưu password rõ ràng (chỉ dùng tạm cho ví dụ)
        'role': role,
      });

      print('Đăng ký thành công!');
    } catch (e) {
      print('Lỗi đăng ký: $e');
    }
  }

  /// Đăng xuất người dùng
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Đăng xuất thành công!');
    } catch (e) {
      throw Exception('Lỗi đăng xuất: $e');
    }
  }

  /// Lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
