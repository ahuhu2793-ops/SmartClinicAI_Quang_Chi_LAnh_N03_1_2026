import 'package:flutter/material.dart';

void main() {
  runApp(const ClinicAIApp());
}

class ClinicAIApp extends StatelessWidget {
  const ClinicAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clinic AI Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const ClinicDashboard(),
    );
  }
}

class ClinicDashboard extends StatelessWidget {
  const ClinicDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // ---------------------------------------------------------
    // 1. Thực hiện sử dụng các biến (Dựa trên yêu cầu bài tập)
    // Chuyển đổi từ Sách -> Hồ sơ khám bệnh / Thiết bị AI
    // ---------------------------------------------------------
    String tenPhongKham = "PHÒNG KHÁM THÔNG MINH TÍCH HỢP AI";
    String nhomThucHien = "Chi - Quang - Anh";

    // Khai báo các biến mô tả thực thể (Ví dụ cho 1 bác sĩ phụ trách)
    int idBacSi = 101;
    String tenBacSi = "Dr. Nguyễn Văn A";
    String chuyenKhoa = "Chẩn đoán hình ảnh AI";
    String phongLamViec = "Phòng AI-01";

    // ---------------------------------------------------------
    // 2. Thực hiện sử dụng Collections (Array, List, Map)
    // ---------------------------------------------------------
    
    // Map cho dữ liệu Bệnh nhân (Tương ứng listNguoiMuon trong bài tập)
    var thongTinBenhNhan = {
      'id': 'BN99',
      'tenBenhNhan': 'NGUYỄN BẢO LA',
      'tinhTrang': 'Ổn định',
      'chanDoanAI': 'Cần theo dõi thêm'
    };

    // List các Map cho dữ liệu Lịch khám/Thiết bị (Tương ứng listSach trong bài tập)
    var listLichKhambenh = [
      {
        'idPhieu': 1,
        'dichVu': 'Siêu âm AI',
        'soLuong': 1,
        'phong': 'Phòng 01',
        'gioHen': '08:00'
      },
      {
        'idPhieu': 2,
        'dichVu': 'Chụp X-Quang 4.0',
        'soLuong': 1,
        'phong': 'Phòng 05',
        'gioHen': '09:30'
      },
      {
        'idPhieu': 3,
        'dichVu': 'Xét nghiệm máu',
        'soLuong': 2,
        'phong': 'Lab-AI',
        'namXB': '2024', // Giữ nguyên key để khớp logic bài tập cũ nếu cần
        'gioHen': '10:45'
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tenPhongKham, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị thông tin nhóm thực hiện
            Center(
              child: Text(
                'Thực hiện: $nhomThucHien',
                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Hiển thị dữ liệu Bệnh nhân
            const Text(
              'THÔNG TIN BỆNH NHÂN:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text('ID: ${thongTinBenhNhan['id']} - Tên: ${thongTinBenhNhan['tenBenhNhan']}'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.psychology, size: 20, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text('Gợi ý AI: ${thongTinBenhNhan['chanDoanAI']}'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 3. Hiển thị danh sách dữ liệu theo dạng hàng (Row)
            const Text(
              'DANH SÁCH LỊCH KHÁM CHI TIẾT:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),

            // Tiêu đề bảng (Header Row)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              color: Colors.teal,
              child: const Row(
                children: [
                  Expanded(flex: 2, child: Text('Dịch vụ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Phòng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Giờ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            // Dữ liệu danh sách (Rows)
            ...listLichKhambenh.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(item['dichVu'].toString())),
                    Expanded(flex: 2, child: Text(item['phong'].toString())),
                    Expanded(flex: 1, child: Text(item['gioHen'].toString())),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Thực hiện hiển thị 02 danh sách trên màn hình",
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            )
          ],
        ),
      ),
    );
  }
}