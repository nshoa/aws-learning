# ☁️ EC2 - Elastic Compute Cloud

## 📝 Mô tả (1 câu)
Dịch vụ cung cấp máy chủ ảo (virtual servers) có thể tùy chỉnh cấu hình và thay đổi quy mô theo nhu cầu.

---

### 🎯 Use Cases
- Chạy ứng dụng web, máy chủ game.
- Xử lý các tác vụ tính toán hiệu năng cao (HPC).
- Chạy backend cho ứng dụng di động.

---

### 🔑 Khái Niệm Cốt Lõi
- **AMI (Amazon Machine Image):** Khuôn mẫu để khởi tạo instance (chứa HĐH, phần mềm).
- **Instance Types:** Các loại cấu hình phần cứng (CPU, RAM, Network). VD: t2.micro, m5.large.
- **Security Groups:** Tường lửa ảo ở cấp độ instance, kiểm soát traffic ra/vào.
- **EBS (Elastic Block Store):** Ổ cứng mạng cho EC2.
- **Pricing Models:** On-Demand, Reserved, Spot, Savings Plans.

---

### 🆚 So sánh & Từ khóa
- **So sánh:**
    - **EC2 vs. Lambda:** EC2 là máy chủ ảo (IaaS), bạn quản lý HĐH. Lambda là serverless (FaaS), bạn chỉ cần đưa code.
    - **EC2 vs. Beanstalk:** Beanstalk là PaaS, tự động hóa việc triển khai và quản lý EC2.
- **Từ khóa:** "máy chủ ảo", "virtual server", "IaaS", "kiểm soát hoàn toàn HĐH", "root access".

---

### ⚠️ Lưu ý Thi Cử (Exam Tips / Gotchas)
- **Security Group** là stateful, **NACL** là stateless.
- Không thể giảm kích thước của EBS volume sau khi đã tạo.
- Metadata của instance có thể truy cập qua địa chỉ `169.254.169.254`.