# 🦷 Dental Clinic Management System

Hệ thống quản lý phòng khám nha khoa được xây dựng bằng Dart nhằm hỗ trợ quản lý bệnh nhân, lịch hẹn, bác sĩ và các dịch vụ nha khoa một cách hiệu quả.

## 👥 Thành viên & Phân công công việc

| Họ và tên | MSSV | Vai trò | Đóng góp |
|---|---|---|---|
| Nguyễn Danh quang | 23010230 | Leader / Developer | Phân tích yêu cầu hệ thống, thiết kế giao diện và phát triển chức năng quản lý bệnh nhân |
| Nguyễn Thị Lan Anh | 23010823 | Frontend Developer | Xây dựng giao diện Flutter/Dart và tối ưu trải nghiệm người dùng |
| Dương Kim Chi | 23010831  | Backend Developer |Thiết kế cơ sở dữ liệu, xử lý logic hệ thống và kết nối dữ liệu |

## 📌 Giới thiệu

Ứng dụng giúp phòng khám nha khoa:
- Quản lý thông tin bệnh nhân
- Đặt và theo dõi lịch hẹn
- Quản lý bác sĩ và nhân viên
- Theo dõi hồ sơ khám bệnh
- Quản lý dịch vụ và hóa đơn
- Hỗ trợ thống kê doanh thu


## 🚀 Công nghệ sử dụng

- Dart
- Flutter
- SQLite / MySQL
- Provider / Riverpod
- REST API


## 📂 Cấu trúc dự án

```bash
lib/
│
├── models/          
├── services/        
├── screens/         
├── widgets/         
├── database/        
├── utils/           
└── main.dart        
```

## ⚙️ Chức năng chính

### 👨‍⚕️ Quản lý bác sĩ
- Thêm / sửa / xóa bác sĩ
- Quản lý chuyên môn
- Theo dõi lịch làm việc

### 🧑‍💼 Quản lý bệnh nhân
- Lưu thông tin cá nhân
- Quản lý lịch sử khám bệnh
- Theo dõi tình trạng điều trị

### 📅 Quản lý lịch hẹn
- Đặt lịch khám
- Kiểm tra lịch trống
- Nhắc lịch hẹn

### 💳 Thanh toán & hóa đơn
- Tạo hóa đơn dịch vụ
- Quản lý chi phí điều trị
- Thống kê doanh thu

### 📊 Báo cáo thống kê
- Tổng số bệnh nhân
- Doanh thu theo tháng
- Dịch vụ được sử dụng nhiều nhất


## 🛠️ Cài đặt dự án

### Clone project

```bash
git clone https://github.com/your-username/dental-clinic-management.git
```

### Cài dependencies

```bash
dart pub get
```

Hoặc:

```bash
flutter pub get
```

### Chạy ứng dụng

```bash
dart run
```

Hoặc:

```bash
flutter run
```


## 🔒 Phân quyền người dùng

| Vai trò | Quyền |
|---|---|
| Admin | Quản lý toàn hệ thống |
| Doctor | Quản lý khám bệnh |
| Receptionist | Đặt lịch và tiếp nhận |
| Patient | Xem lịch hẹn |


## 📈 Hướng phát triển

- Tích hợp AI hỗ trợ chẩn đoán
- Đặt lịch online
- Gửi thông báo tự động
- Đồng bộ dữ liệu cloud
- Xuất PDF hóa đơn





