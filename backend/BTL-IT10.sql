-- Tạo CSDL
CREATE DATABASE LucyStore;
GO
-- Sử dụng CSDL
USE [LucyStore];
GO
-- Tạo bảng May Tinh
CREATE TABLE tblMayTinh (
    MaMayTinh INT IDENTITY(1,1) PRIMARY KEY,
    TenMayTinh NVARCHAR(255),
    GiaBan INT,
    SoLuong INT
);
GO
-- Chèn dữ liệu mẫu vào bảng MayTinh
INSERT INTO tblMayTinh VALUES
(N'Dell Insprion', 15000000, 100),
(N'HP Envy', 30000000, 150),
(N'Chromebook', 7000000, 80),
(N'LG Gram', 38000000, 50),
(N'Macbook Pro', 40000000, 120);
GO
-- Tạo bảng KhachHang
CREATE TABLE tblKhachHang (
    MaKhachHang INT IDENTITY(1,1) PRIMARY KEY,
    TenKhachHang NVARCHAR(255),
    DiaChi NVARCHAR(255),
    SDT VARCHAR(20)
);
GO
-- Chèn dữ liệu mẫu vào bảng KhachHang
INSERT INTO tblKhachHang VALUES
(N'Lê Văn Luyện', N'Bắc Giang', '0943020202'),
(N'Nguyễn Đức Nghĩa', N'Đà Nẵng', '0988230234'),
(N'Trần Đức Bo', N'TP. HCM', '0922934032'),
(N'Ngô Bá Khá', N'Bắc Ninh', '0977832032'),
(N'Nguyễn Đức Chung', N'Hà Nội', '0986868686');
GO
-- Tạo bảng NhanVien
CREATE TABLE tblNhanVien (
    MaNV INT IDENTITY(1,1) PRIMARY KEY,
    TenNV NVARCHAR(100),
    GioiTinh NVARCHAR(5),
    QueQuan NVARCHAR(255),
    SDT VARCHAR(20),
    NgayVaoLam DATE,
);
GO
INSERT INTO tblNhanVien VALUES
(N'Nguyễn Công Phượng', N'Nam', N'Bắc Giang', '0943020202', '2022-05-05'),
(N'Nguyễn Thị Toan', N'Nữ', N'Hà Nội', '0944534332', '2023-01-02'),
(N'Đào Thị Vân', N'Nữ', N'Hà Nội', '0977538832', '2021-09-02'),
(N'Hoàng Công Minh', N'Nam', N'Hà Nam', '0943538899', '2020-03-03'),
(N'Nguyễn Hồng Ngọc', N'Nữ', N'Hà Tây', '0968990232', '2020-08-08');
GO
CREATE TABLE tblHoaDon (
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    MaNV INT FOREIGN KEY REFERENCES tblNhanVien (MaNV) ON DELETE CASCADE,
    MaKhachHang INT FOREIGN KEY REFERENCES tblKhachHang(MaKhachHang) ON DELETE CASCADE,
    NgayLap DATE,
);
GO
INSERT INTO tblHoaDon VALUES
(1, 1, '2022-05-05'),
(2, 2, '2021-04-05'),
(3, 3, '2023-09-05'),
(4, 4, '2023-11-05'),
(5, 5, '2023-10-05');
GO
CREATE TABLE tblChiTietHoaDon (
    MaCTHD INT IDENTITY(1,1) PRIMARY KEY,
    MaHD INT FOREIGN KEY REFERENCES tblHoaDon (MaHD) ON DELETE CASCADE,
    MaMayTinh INT FOREIGN KEY REFERENCES tblMayTinh (MaMayTinh) ON DELETE CASCADE,
    SoLuong INT,
);
GO
INSERT INTO tblChiTietHoaDon VALUES
(1, 1, 10),
(2, 2, 5),
(3, 3, 20),
(4, 4, 4),
(5, 5, 13);
GO
-- Tạo view để lấy thông tin chi tiết hóa đơn
USE [LucyStore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewHoaDonChiTiet] AS
SELECT
    HoaDon.MaHD,
    HoaDon.NgayLap,
    KhachHang.TenKhachHang,
    NhanVien.TenNV,
    MayTinh.TenMayTinh,
    CTHoaDon.SoLuong,
    MayTinh.GiaBan
FROM
    tblHoaDon HoaDon
JOIN
    tblKhachHang KhachHang ON HoaDon.MaKhachHang = KhachHang.MaKhachHang
JOIN
    tblNhanVien NhanVien ON HoaDon.MaNV = NhanVien.MaNV
JOIN
    tblChiTietHoaDon CTHoaDon ON HoaDon.MaHD = CTHoaDon.MaHD
JOIN
    tblMayTinh MayTinh ON CTHoaDon.MaMayTinh = MayTinh.MaMayTinh;
GO
-- Sử dụng view để lấy thông tin chi tiết hóa đơn
SELECT * FROM ViewHoaDonChiTiet;
GO
-- Thủ tục tính tổng doanh thu theo ngày
CREATE PROCEDURE TinhTongDoanhThuTheoNgay
    @Ngay DATE
AS
BEGIN
    SELECT SUM(GiaBan * SoLuong) AS TongDoanhThu
    FROM tblHoaDon HoaDon
    JOIN tblCTHoaDon CTHoaDon ON HoaDon.MaHoaDon = CTHoaDon.MaHoaDon
    WHERE CONVERT(DATE, HoaDon.NgayTao) = @Ngay;
END;
GO
-- Trigger khi thêm mới hoá đơn, cập nhật tồn kho
CREATE TRIGGER TrgCapNhatTonKho
ON tblHoaDon
AFTER INSERT
AS
BEGIN
    UPDATE Q
    SET Q.SoLuong = Q.SoLuong - I.SoLuong
    FROM tblMayTinh Q
    JOIN inserted I ON Q.MaMayTinh = I.MaMayTinh;
END;
GO
-- Tạo người dùng
CREATE LOGIN User1 WITH PASSWORD = 'password1';
GO
-- Kết nối người dùng với CSDL
CREATE USER User1 FOR LOGIN User1;
GO
-- Phân quyền trên bảng, view, thủ tục
GRANT SELECT, INSERT, UPDATE, DELETE ON tblMayTinh TO User1;
GRANT EXECUTE ON TinhTongDoanhThuTheoNgay TO User1;
GO