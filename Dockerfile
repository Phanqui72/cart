# =================================================================
# GIAI ĐOẠN 1: BUILD (Sử dụng Maven để biên dịch và đóng gói)
# =================================================================
# Bắt đầu với một image chứa sẵn Maven và JDK 17 (phiên bản ổn định)
# Đặt tên cho giai đoạn này là "build" để tham chiếu sau này
FROM maven:3.9.5-eclipse-temurin-17 AS build

# Đặt thư mục làm việc bên trong container là /app
WORKDIR /app

# Sao chép file pom.xml vào trước. Bước này giúp tận dụng cache của Docker.
# Nếu sau này chỉ code thay đổi mà pom.xml không đổi, Docker sẽ không cần
# tải lại toàn bộ thư viện, giúp build nhanh hơn rất nhiều.
COPY pom.xml .

# Sao chép toàn bộ mã nguồn của bạn vào thư mục làm việc /app
COPY src ./src

# Chạy lệnh build của Maven để tạo ra file .war
# Lệnh "clean package" sẽ biên dịch code, chạy test (nếu có), và đóng gói
# thành file .war trong thư mục /app/target/
# Cờ -DskipTests sẽ bỏ qua việc chạy unit test để quá trình build image nhanh hơn.
RUN mvn clean package -DskipTests


# =================================================================
# GIAI ĐOẠN 2: RUN (Chạy ứng dụng trên server Tomcat)
# =================================================================
# Bắt đầu một giai đoạn mới với một image Tomcat 11 chính thức.
# Chọn phiên bản -jdk17-temurin để tương thích với JDK đã dùng để build.
# Image này nhẹ và được tối ưu hóa cho việc chạy ứng dụng.
FROM tomcat:11.0-jdk17-temurin

# (Tùy chọn nhưng khuyến khích) Xóa các ứng dụng web mặc định của Tomcat
# để giảm kích thước image và loại bỏ các thành phần không cần thiết.
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file .war đã được tạo ra ở giai đoạn "build"
# vào thư mục webapps của Tomcat trong image hiện tại.
#
# --from=build: Chỉ định lấy file từ giai đoạn "build" ở trên.
# /app/target/add_your_cart.war: Đường dẫn đến file .war trong image "build".
# /usr/local/tomcat/webapps/ROOT.war: Đích đến. Việc đổi tên thành ROOT.war là
# một thủ thuật quan trọng để ứng dụng của bạn chạy ngay tại URL gốc
# (ví dụ: https://myapp.onrender.com) thay vì phải thêm context path
# (ví dụ: https://myapp.onrender.com/add_your_cart).
COPY --from=build /app/target/add_your_cart.war /usr/local/tomcat/webapps/ROOT.war

# Khai báo rằng container sẽ lắng nghe trên cổng 8080.
# Render và các nền tảng khác sẽ sử dụng thông tin này để điều hướng traffic.
EXPOSE 8080

# Lệnh mặc định sẽ được thực thi khi container khởi động.
# "catalina.sh run" sẽ khởi động server Tomcat và giữ cho nó chạy ở foreground,
# điều này cần thiết để container không bị tắt ngay lập tức.
CMD ["catalina.sh", "run"]