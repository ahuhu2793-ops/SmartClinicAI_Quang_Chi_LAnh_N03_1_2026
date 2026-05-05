# CLINIC AI MANAGER

## BAI TAP THUC HANH SO 02 - NHOM 03

## 1. Mô tả bài thực hành
Sinh viên có thể làm việc theo nhóm hoặc cá nhân dựa trên nội dung bài tập nhóm.
Đề tài thực hiện: CLINIC AI MANAGER.

Mục tiêu bài thực hành số 2:
- Sử dụng biến trong file main.dart.
- Sử dụng Collections (Array, List, Map) để quản lý dữ liệu đối tượng.
- Hiển thị dữ liệu Collections trên giao diện Flutter trong hàm build.

## 2. Thông tin nhóm
- Lớp: N03 - Đại học Phenikaa
- Đề tài: CLINIC AI MANAGER

Thành viên:
1. Chi
2. Quang
3. Anh

## 3. Yêu cầu bài thực hành và cách thực hiện

3.1. Sử dụng biến trong main.dart

Trong main.dart đã khai báo các biến mô tả bối cảnh phòng khám và đối tượng liên quan:
- tenPhongKham
- nhomThucHien
- idBacSi
- tenBacSi
- chuyenKhoa
- phongLamViec

Ý nghĩa:
- Nhóm biến String dùng để mô tả tên phòng khám, tên bác sĩ, chuyên khoa.
- Biến int dùng để định danh đối tượng (ví dụ idBacSi).

3.2. Sử dụng Collections (Map, List)

Map đối tượng đơn:
- thongTinBenhNhan gồm các key: id, tenBenhNhan, tinhTrang, chanDoanAI.

List các Map:
- listLichKhambenh là danh sách các phiếu dịch vụ/lịch khám.
- Mỗi phần tử gồm các trường: idPhieu, dichVu, soLuong, phong, gioHen.

Nội dung này tương ứng yêu cầu đề bài về listNguoiMuon và listSach, nhưng đã được điều chỉnh theo bối cảnh quản lý phòng khám.

3.3. Hiển thị dữ liệu trong Widget build

Đã hiển thị 02 danh sách/chòm dữ liệu trên giao diện:
- Thông tin bệnh nhân: hiển thị bằng Text và Row trong một khối Container.
- Danh sách lịch khám: hiển thị theo dạng hàng (Row) gồm header và các dòng dữ liệu tạo từ List.

Kết quả:
- Dữ liệu Collections được render trực tiếp lên màn hình.
- Đáp ứng yêu cầu hiển thị bằng Row hoặc Text.

## 4. Cấu trúc file liên quan
- lib/main.dart: Chứa toàn bộ biến, collections và giao diện hiển thị theo yêu cầu bài 2.
- pubspec.yaml: Cấu hình dependency và môi trường Dart/Flutter.
- README.md: Tài liệu mô tả bài thực hành.

## 5. Hướng dẫn chạy dự án
Bước 1: Cài dependency
flutter pub get

Bước 2: Kiểm tra thiết bị
flutter devices

Bước 3: Chạy ứng dụng
flutter run

Nếu cần chỉ định thiết bị:
flutter run -d ten_thiet_bi

## 6. Đánh giá kết quả bài tập
- Đã sử dụng biến trong main.dart.
- Đã sử dụng Collections gồm Map và List cho đối tượng dữ liệu.
- Đã hiển thị 02 khối dữ liệu trên giao diện bằng Row/Text.
- Hoàn thành đúng trọng tâm yêu cầu Bài tập thực hành số 02.

## 7. Hướng phát triển tiếp
- Tách đối tượng thành model riêng (BenhNhan, LichKham).
- Đưa dữ liệu từ giả lập sang dữ liệu động (form nhập liệu).
- Bổ sung chức năng tìm kiếm và lọc lịch khám.
- Tích hợp trang chi tiết cho từng bệnh nhân.
