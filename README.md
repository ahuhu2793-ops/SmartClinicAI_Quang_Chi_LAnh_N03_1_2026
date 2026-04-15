# SmartClinicAI
ỨNG DỤNG QUẢN LÝ PHÒNG KHÁM THÔNG MINH TÍCH HỢP AI

Hệ thống Quản lý phòng khám thông minh tích hợp AI là ứng dụng giúp số hóa toàn bộ quy trình vận hành của phòng khám, từ quản lý bệnh nhân, bác sĩ, lịch hẹn đến bệnh án, dịch vụ và thanh toán.
## Thành viên
- Nguyễn Danh Quang - 23010230
- Dương Kim Chi - 23010831
- Nguyễn Thị Lan Anh - 23010823
## Mục tiêu
Giảm thao tác thủ công
Tránh sai sót trong quản lý
Tăng hiệu quả vận hành
Dễ dàng mở rộng và tích hợp
## Công nghệ sử dụng
Frontend
- Flutter (Dart)
Kiến trúc: Clean Architecture
- Backend
REST API (Spring Boot)
Xác thực: JWT (JSON Web Token)
Phân quyền: RBAC (Role-Based Access Control)
- Database
MySQL
## Các đối tượng trong hệ thống
* Admin
Quản lý bác sĩ
Quản lý dịch vụ và giá
Xem báo cáo, thống kê
Xem và tính lương bác sĩ
* Doctor (Bác sĩ)
Xem lịch khám
Cập nhật bệnh án
Ghi nhận dịch vụ đã thực hiện
* Receptionist (Lễ tân)
Quản lý bệnh nhân
Đặt lịch khám
Tạo hóa đơn
Thanh toán
  * Patient (Bệnh nhân)
Đăng ký lịch khám
Xem lịch hẹn
Xem lịch sử khám
## Chức năng chính
# Quản lý bác sĩ
CRUD thông tin bác sĩ
Quản lý chuyên môn
Theo dõi lịch làm việc
Thống kê hiệu suất
# Quản lý bệnh nhân & bệnh án
Lưu trữ hồ sơ bệnh nhân
Theo dõi lịch sử khám
Quản lý bệnh án theo từng lần khám
Theo dõi tình trạng từng răng
# Quản lý lịch hẹn
Đặt lịch khám theo bác sĩ
Kiểm tra trùng lịch
Nhắc lịch khám
# Quản lý dịch vụ
Danh sách dịch vụ (trám răng, nhổ răng, tẩy trắng,...)
Cấu hình giá dịch vụ
# Thanh toán & hóa đơn
Tạo hóa đơn
Thêm nhiều dịch vụ vào hóa đơn
Tính tổng tiền tự động
Lưu lịch sử thanh toán
# Báo cáo & thống kê
Doanh thu theo ngày/tháng
Số lượng bệnh nhân
Hiệu suất bác sĩ
