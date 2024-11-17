import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rbooks/screen/login.dart';
import 'package:rbooks/screen/home.dart';
import 'package:rbooks/admin/admin_home.dart';
import 'package:rbooks/admin/manage_book.dart';
import 'package:rbooks/admin/manage_users.dart';
import 'package:rbooks/admin/add_book.dart';
import 'admin/edit_book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().catchError((e) {
    print("Lỗi khi kết nối Firebase: $e");
  });
  print("Firebase đã kết nối thành công!");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng của tôi',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/admin-home': (context) => AdminScreen(),
        '/manage-books': (context) => ManageBooksScreen(),
        '/add-book': (context) => AddBookScreen(),
        '/manage-users': (context) => ManageUsersScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit-book') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args != null && args.containsKey('bookId') && args.containsKey('bookData')) {
            return MaterialPageRoute(
              builder: (context) => EditBookScreen(
                bookId: args['bookId'] as String,
                bookData: args['bookData'] as Map<String, dynamic>,
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text("Lỗi Route")),
                body: Center(child: Text("Tham số không hợp lệ cho EditBookScreen!")),
              ),
            );
          }
        }

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text("Route không tồn tại")),
            body: Center(child: Text("Không tìm thấy route: ${settings.name}")),
          ),
        );
      },
    );
  }
}
