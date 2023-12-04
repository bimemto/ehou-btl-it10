const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');
const cors = require('cors');

const app = express();
app.use(cors());

const port = 3002;

// Cấu hình kết nối CSDL SQL Server
const config = {
  user: 'sa',
  password: 'Smilelife123',
  server: 'localhost',
  port: 1433,
  database: 'LucyStore',
  options: {
    encrypt: false, // Nếu sử dụng kết nối qua SSL/TLS
  },
};

// Middleware sử dụng body-parser để xử lý dữ liệu gửi lên từ frontend
app.use(bodyParser.json());

// Middleware để xử lý lỗi và đóng kết nối sau mỗi request
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something went wrong!');
  sql.close();
});

/**
 * Api quần áo
 */
// Endpoint để lấy dữ liệu quần áo
app.get('/api/maytinh', async (req, res) => {
  try {
    const orderBy = req.query.orderBy || 'MaMayTinh';
    const order = req.query.order || 'ASC';
    const keyword = req.query.keyword || '';
    // Kết nối đến CSDL
    await sql.connect(config);

    // Truy vấn dữ liệu từ bảng quần áo
    let q = 'SELECT * FROM tblMayTinh ORDER BY ' + orderBy + ' ' + order;
    if (keyword.length > 0) {
      q = `SELECT * FROM tblMayTinh WHERE TenMayTinh LIKE N'%${keyword}%' ORDER BY ${orderBy} ${order}`;
    }
    const result = await sql.query(q);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

// Endpoint để thêm quần áo
app.post('/api/maytinh', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { TenMayTinh, GiaBan, SoLuong } = req.body;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`INSERT INTO tblMayTinh (TenMayTinh, GiaBan, SoLuong) VALUES (N'${TenMayTinh}', ${GiaBan}, ${SoLuong})`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

// Endpoint để sửa quần áo
app.put('/api/maytinh/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    const { TenMayTinh, GiaBan, SoLuong } = req.body;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(
      `UPDATE tblMayTinh SET TenMayTinh = N'${TenMayTinh}', GiaBan = ${GiaBan}, SoLuong = ${SoLuong} WHERE MaMayTinh = ${id}`
    );

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

//Endpoint để xóa quần áo
app.delete('/api/maytinh/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`DELETE FROM tblMayTinh WHERE MaMayTinh = ${id}`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

//Endpoint để lấy quần áo theo id
app.get('/api/maytinh/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`SELECT * FROM tblMayTinh WHERE MaMayTinh = ${id}`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

/**
 * Api nhân viên
 */
// Endpoint để lấy dữ liệu nhân viên
app.get('/api/nhanvien', async (req, res) => {
  try {
    const orderBy = req.query.orderBy || 'MaNV';
    const order = req.query.order || 'ASC';
    const keyword = req.query.keyword || '';
    // Kết nối đến CSDL
    await sql.connect(config);

    // Truy vấn dữ liệu từ bảng quần áo
    let q = 'SELECT * FROM tblNhanVien ORDER BY ' + orderBy + ' ' + order;
    if (keyword.length > 0) {
      q = `SELECT * FROM tblNhanVien WHERE TenNV LIKE N'%${keyword}%' ORDER BY ${orderBy} ${order}`;
    }
    const result = await sql.query(q);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

// Endpoint để thêm nhân viên
app.post('/api/nhanvien', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { TenNV, GioiTinh, QueQuan, SDT, NgayVaoLam } = req.body;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(
      `INSERT INTO tblNhanVien (TenNV, GioiTinh, QueQuan, SDT, NgayVaoLam) VALUES (N'${TenNV}', N'${GioiTinh}', N'${QueQuan}', '${SDT}', '${NgayVaoLam}')`
    );

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

// Endpoint để sửa nhân viên
app.put('/api/nhanvien/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    const { TenNV, GioiTinh, QueQuan, SDT, NgayVaoLam } = req.body;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(
      `UPDATE tblNhanVien SET TenNV = N'${TenNV}', GioiTinh = N'${GioiTinh}', QueQuan = N'${QueQuan}', SDT = '${SDT}', NgayVaoLam = '${NgayVaoLam}' WHERE MaNV = ${id}`
    );

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

//Endpoint để xóa nhân viên
app.delete('/api/nhanvien/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`DELETE FROM tblNhanVien WHERE MaNV = ${id}`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

//Endpoint để lấy nhân viên theo id
app.get('/api/nhanvien/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`SELECT * FROM tblNhanVien WHERE MaNV = ${id}`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

/**
 * Api khách hàng
 */
// Endpoint để lấy dữ liệu khách hàng
app.get('/api/khachhang', async (req, res) => {
  try {
    const orderBy = req.query.orderBy || 'MaKhachHang';
    const order = req.query.order || 'ASC';
    const keyword = req.query.keyword || '';
    // Kết nối đến CSDL
    await sql.connect(config);

    // Truy vấn dữ liệu từ bảng quần áo
    let q = 'SELECT * FROM tblKhachHang ORDER BY ' + orderBy + ' ' + order;
    if (keyword.length > 0) {
      q = `SELECT * FROM tblKhachHang WHERE TenKhachHang LIKE N'%${keyword}%' ORDER BY ${orderBy} ${order}`;
    }
    const result = await sql.query(q);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

// Endpoint để thêm nhân viên
app.post('/api/khachhang', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { TenKhachHang, DiaChi, SDT } = req.body;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`INSERT INTO tblKhachHang (TenKhachHang, DiaChi, SDT) VALUES (N'${TenKhachHang}', N'${DiaChi}', '${SDT}')`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

// Endpoint để sửa nhân viên
app.put('/api/khachhang/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    const { TenKhachHang, DiaChi, SDT } = req.body;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(
      `UPDATE tblKhachHang SET TenNV = N'${TenKhachHang}', DiaChi = N'${DiaChi}', SDT = '${SDT}' WHERE MaKhachHang = ${id}`
    );

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

//Endpoint để xóa nhân viên
app.delete('/api/khachhang/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`DELETE FROM tblKhachHang WHERE MaKhachHang = ${id}`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

//Endpoint để lấy nhân viên theo id
app.get('/api/khachhang/:id', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);
    const { id } = req.params;
    // Truy vấn dữ liệu từ bảng quần áo
    const result = await sql.query(`SELECT * FROM tblKhachHang WHERE MaKhachHang = ${id}`);

    res.json(result.recordset);
  } catch (error) {
    // Gửi thông báo lỗi về client và log lỗi ra console
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    // Đóng kết nối sau khi hoàn thành (lược bỏ nếu có lỗi xảy ra)
    await sql.close();
  }
});

/**
 * Api hóa đơn
 */
// Endpoint để lấy dữ liệu hóa đơn
app.get('/api/hoadon', async (req, res) => {
  try {
    // Kết nối đến CSDL
    await sql.connect(config);

    // Truy vấn dữ liệu từ bảng quần áo
    let q = 'SELECT * FROM ViewHoaDonChiTiet';
    const result = await sql.query(q);

    res.json(result.recordset);
  } catch (error) {
    console.error(error.message);
    res.status(500).send('Internal Server Error');
  } finally {
    await sql.close();
  }
});

// Mở cổng nghe
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
