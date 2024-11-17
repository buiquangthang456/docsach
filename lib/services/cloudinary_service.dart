import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  final String cloudName = "dvljbhcjz"; // Cloud name từ dashboard
  final String apiKey = "737591379819193"; // API Key từ dashboard
  final String apiSecret = "t932li5-knuOo_-aRg3wVINY10w"; // API Secret từ dashboard

  /// Hàm upload ảnh lên Cloudinary
  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest('POST', url);

      // Thêm các tham số cần thiết
      request.fields['upload_preset'] = 'unsigned_preset'; // Nếu bạn sử dụng upload preset
      request.fields['api_key'] = apiKey;
      request.fields['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
      request.fields['folder'] = 'book_covers'; // Thư mục trên Cloudinary
      // Đọc file và thêm vào request
      final file = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(file);

      // Gửi request
      final response = await request.send();

      // Kiểm tra kết quả
      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final data = json.decode(responseBody.body);
        return data['secure_url']; // Trả về URL ảnh
      } else {
        print('Lỗi upload: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi upload ảnh: $e');
      return null;
    }
  }

}
