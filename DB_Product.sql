USE master
GO
--Gỡ database nếu đã có tồn tại trước đây
IF EXISTS(SELECT name FROM sys.databases WHERE name = 'QLSX')
   DROP DATABASE QLSX
GO
--Tạo lại database
CREATE DATABASE QLSX
ON (NAME ='QLSX_DATA',FILENAME = 'F:\\Dani SQL\Quản Lý Sản Xuất\QLSX.MDF')
LOG ON(NAME = 'QLSX_LOG',FILENAME = 'F:\\Dani SQL\Quản Lý Sản Xuất\QLSX.LDF')
GO
--Backup database
BACKUP DATABASE QLSX TO DISK = 'F:\\Dani SQL\Quản Lý Sản Xuất\QLSX.BAK'
GO
--Dùng database
USE QLSX
GO
--Loai(MaLoai, TenLoai)
--SanPham(MaSP, TenSP, MaLoai)
--NhanVien(MaNV, HoTen, NgaySinh, Phai)
--PhieuXuat(MaPX, NgayLap, MaNV)
--CTPX(MaPX, MaSP, SoLuong)
--+ Tên sản phẩm là duy nhất nhưng không là khóa chính.
--+ Mã phiếu xuất là số nguyên tự động tăng.
--+ Các mã số của các bảng còn lại là phải nhập vào và có kiểu là char(5)
--+ Số lượng xuất kho là số nguyên dương.
--+ Phái của nhân viên có giá trị là 1 (nếu là nam) hoặc 0 (nếu là nữ), mặc định là 0.
--+ Giá trị cho ngày sinh của nhân viên là >=18  tuổi và <=55 tuổi.
--                     TABLE            --
--Loai(MaLoai, TenLoai)
CREATE TABLE LOAI
(
	MALOAI CHAR(5) PRIMARY KEY,TENLOAI NVARCHAR(30) NOT NULL
)
GO
--SanPham(MaSP, TenSP, MaLoai)
CREATE TABLE SANPHAM
(
	MASP CHAR(5) PRIMARY KEY,TENSP NVARCHAR(30) UNIQUE NOT NULL,MALOAI CHAR(5)
	CONSTRAINT MALOAI_SANPHAM FOREIGN KEY(MALOAI) REFERENCES dbo.LOAI(MALOAI)
)
GO
--NhanVien(MaNV, HoTen, NgaySinh, Phai)
--+ Phái của nhân viên có giá trị là 1 (nếu là nam) hoặc 0 (nếu là nữ), mặc định là 0.
--+ Giá trị cho ngày sinh của nhân viên là >=18  tuổi và <=55 tuổi.
CREATE TABLE NHANVIEN
(
	MANV CHAR(5) PRIMARY KEY,HOTEN NVARCHAR(30),
	NGAYSINH DATE CHECK(YEAR(GETDATE())-YEAR(NGAYSINH) >= 18 AND YEAR(GETDATE())- YEAR(NGAYSINH) <= 55),
	PHAI BIT CHECK(PHAI = 0 OR PHAI = 1)
)
GO
--PhieuXuat(MaPX, NgayLap, MaNV)
--+ Mã phiếu xuất là số nguyên tự động tăng.
CREATE TABLE PHIEUXUAT
(
	MAPX INT IDENTITY(1,1) PRIMARY KEY,NGAYLAP DATE,MANV CHAR(5)
	CONSTRAINT MANV_PX FOREIGN KEY(MANV) REFERENCES dbo.NHANVIEN(MANV)
)
GO
--CTPX(MaPX, MaSP, SoLuong)
--+ Số lượng xuất kho là số nguyên dương.
CREATE TABLE CTPX
(
	PRIMARY KEY(MAPX,MASP),
	MAPX INT,MASP CHAR(5),SOLUONG INT CHECK(SOLUONG > 0)
	CONSTRAINT MAPX_CTPX FOREIGN KEY(MAPX) REFERENCES dbo.PHIEUXUAT(MAPX),
	CONSTRAINT MASP_CTPX FOREIGN KEY(MASP) REFERENCES dbo.SANPHAM(MASP)
)
GO
--                         DATA                    --
INSERT INTO dbo.LOAI(MALOAI,TENLOAI) VALUES('1',N'Vật Liệu Xây Dựng')
INSERT INTO dbo.LOAI(MALOAI,TENLOAI) VALUES('2',N'Hàng Tiêu Dùng')
INSERT INTO dbo.LOAI(MALOAI,TENLOAI) VALUES('3',N'Ngũ cốc')
GO
INSERT INTO dbo.SANPHAM(MASP,TENSP,MALOAI) VALUES('1',N'Xi Măng',1)
INSERT INTO dbo.SANPHAM(MASP,TENSP,MALOAI) VALUES('2',N'Gạch',1)
INSERT INTO dbo.SANPHAM(MASP,TENSP,MALOAI) VALUES('3',N'Gạo Nàng Hương',2)
INSERT INTO dbo.SANPHAM(MASP,TENSP,MALOAI) VALUES('4',N'Bột Mì',3)
INSERT INTO dbo.SANPHAM(MASP,TENSP,MALOAI) VALUES('5',N'Kệ Chén',2)
INSERT INTO dbo.SANPHAM(MASP,TENSP,MALOAI) VALUES('6',N'Đậu xanh',3)
GO
SET DATEFORMAT DMY;
INSERT INTO dbo.NHANVIEN(MANV,HOTEN,NGAYSINH,PHAI) VALUES('NV01',N'Nguyễn Mai Thi','15-05-1982',0)
INSERT INTO dbo.NHANVIEN(MANV,HOTEN,NGAYSINH,PHAI) VALUES('NV02',N'Trần Đình Chiến','02-12-1980',1)
INSERT INTO dbo.NHANVIEN(MANV,HOTEN,NGAYSINH,PHAI) VALUES('NV03',N'Lê Thị Chi','23-01-1979',0)
GO
INSERT INTO dbo.PHIEUXUAT(NGAYLAP,MANV) VALUES ('12-03-2010','NV01')
INSERT INTO dbo.PHIEUXUAT(NGAYLAP,MANV) VALUES ('03-02-2010','NV02')
INSERT INTO dbo.PHIEUXUAT(NGAYLAP,MANV) VALUES ('01-06-2010','NV03')
INSERT INTO dbo.PHIEUXUAT(NGAYLAP,MANV) VALUES ('16-06-2010','NV01')
GO
INSERT INTO dbo.CTPX(MAPX,MASP,SOLUONG) VALUES (1,'1',10)
INSERT INTO dbo.CTPX(MAPX,MASP,SOLUONG) VALUES (1,'2',15)
INSERT INTO dbo.CTPX(MAPX,MASP,SOLUONG) VALUES (1,'3',5)
INSERT INTO dbo.CTPX(MAPX,MASP,SOLUONG) VALUES (2,'2',20)
INSERT INTO dbo.CTPX(MAPX,MASP,SOLUONG) VALUES (3,'1',20)
INSERT INTO dbo.CTPX(MAPX,MASP,SOLUONG) VALUES (3,'3',25)
INSERT INTO dbo.CTPX(MAPX,MASP,SOLUONG) VALUES (4,'5',12)
GO
--                   TRUY VẤN                --
--                   VIEW                    --
--1.Cho biết mã sản phẩm, tên sản phẩm, tổng số lượng xuất của từng sản phẩm trong năm 2010. Lấy dữ liệu từ View này sắp xếp tăng dần theo tên sản phẩm.
CREATE VIEW V1 AS
	SELECT A.MASP[Mã Sản Phẩm],A.TENSP[Tên Sản Phẩm],SUM(B.SOLUONG)[Tổng Số Lượng]
	FROM dbo.SANPHAM A ,dbo.CTPX B,dbo.PHIEUXUAT C
	WHERE A.MASP = B.MASP AND B.MAPX = C.MAPX AND YEAR(C.NGAYLAP) = 2010
	GROUP BY A.MASP,A.TENSP
GO
--2.Cho biết mã sản phẩm, tên sản phẩm, tên loại sản phẩm mà đã được bán từ ngày 1/1/2010 đến 30/6/2010.
CREATE VIEW V2 AS
	SELECT A.MASP,A.TENSP,B.TENLOAI
	FROM dbo.SANPHAM A,dbo.LOAI B,dbo.CTPX C,dbo.PHIEUXUAT D
	WHERE A.MALOAI=B.MALOAI AND A.MASP=C.MASP AND C.MAPX=D.MAPX
		  AND (D.NGAYLAP >= '01/01/2010' AND D.NGAYLAP <= '30/06/2010') 
GO
--3.	Cho biết số lượng sản phẩm trong từng loại sản phẩm gồm các thông tin: mã loại sản phẩm, tên loại sản phẩm, số lượng các sản phẩm.
CREATE VIEW V3 AS
	SELECT B.MALOAI,B.TENLOAI,COUNT(A.MALOAI)[Số Lượng]
	FROM dbo.SANPHAM A,dbo.LOAI B
	WHERE A.MALOAI = B.MALOAI
	GROUP BY  B.MALOAI,B.TENLOAI
GO
--4.	Cho biết tổng số lượng phiếu xuất trong tháng 6 năm 2010
CREATE VIEW V4 AS
	SELECT COUNT(B.MAPX)[Số lượng]
	FROM dbo.PHIEUXUAT A INNER JOIN dbo.CTPX B ON A.MAPX = B.MAPX
	WHERE MONTH(A.NGAYLAP) = 6 AND YEAR(A.NGAYLAP) = 2010
GO
--5. Cho biết thông tin về các phiếu xuất mà nhân viên có mã NV01 đã xuất.
CREATE VIEW V5 AS
	SELECT C.MAPX,C.MASP,C.SOLUONG,B.NGAYLAP
	FROM dbo.NHANVIEN A,dbo.PHIEUXUAT B,dbo.CTPX C
	WHERE A.MANV = B.MANV AND B.MAPX = C.MAPX AND A.MANV = 'NV01'
	GROUP BY C.MAPX,C.MASP,C.SOLUONG,B.NGAYLAP
GO
--6.	Cho biết danh sách nhân viên nam có tuổi trên 25 nhưng dưới 40.
CREATE VIEW V6 AS
	SELECT MANV[Mã Nhân Viên],HOTEN[Tên],(CASE PHAI WHEN 0 THEN N'Nữ' ELSE 'Nam' END)[Phái]
	FROM dbo.NHANVIEN
	WHERE YEAR(GETDATE()) - YEAR(NGAYSINH) > 25 AND YEAR(GETDATE()) - YEAR(NGAYSINH) < 40
GO
--7.	Thống kê số lượng phiếu xuất theo từng nhân viên.
CREATE VIEW V7 AS
	SELECT COUNT(B.MAPX)[Số lượng],B.MANV[Mã Nhân Viên]
	FROM NHANVIEN A ,dbo.PHIEUXUAT B
	WHERE A.MANV=B.MANV
	GROUP BY B.MANV
GO
--8.	Thống kê số lượng sản phẩm đã xuất theo từng sản phẩm.
CREATE VIEW V8 AS
	SELECT COUNT(A.MAPX)[Số lượng],B.MASP[Mã sản phẩm],B.TENSP[Tên sản phẩm]
	FROM dbo.CTPX A,dbo.SANPHAM B
	WHERE A.MASP=B.MASP
	GROUP BY B.MASP,B.TENSP
GO
--9.	Lấy ra tên của nhân viên có số lượng phiếu xuất lớn nhất.
CREATE VIEW V9 AS
	SELECT TOP 1 WITH ties COUNT(B.MAPX)[Số lượng],B.MANV[Mã Nhân Viên]
	FROM NHANVIEN A ,dbo.PHIEUXUAT B
	WHERE A.MANV=B.MANV
	GROUP BY B.MANV
	ORDER BY COUNT(B.MAPX) DESC
GO
--10.	Lấy ra tên sản phẩm được xuất nhiều nhất trong năm 2010.
CREATE VIEW V10 AS
	SELECT TOP 1 WITH ties B.TENSP
	FROM dbo.CTPX A,dbo.SANPHAM B
	WHERE A.MASP=B.MASP
	GROUP BY B.TENSP
	ORDER BY COUNT(A.MASP) DESC
GO
--                 FUNCTION             --
--1.Function F1 có 2 tham số vào là: tên sản phẩm, năm. Function cho biết: số lượng xuất kho của tên sản phẩm đó trong năm này. 
--(Chú ý: Nếu tên sản phẩm đó không tồn tại thì phải trả về 0)
CREATE FUNCTION F1(@tensp NVARCHAR(30),@nam INT)
RETURNs INT AS
BEGIN
	DECLARE @dem int
	IF @tensp NOT IN(SELECT TENSP FROM dbo.SANPHAM)
		SET @dem = 0
	ELSE
		SET @dem = (SELECT COUNT(B.MASP) FROM dbo.PHIEUXUAT A,dbo.CTPX B,dbo.SANPHAM C 
						  WHERE A.MAPX = B.MAPX AND B.MASP = C.MASP AND C.TENSP = @tensp AND YEAR(A.NGAYLAP) = @nam)
	RETURN @dem
END
GO
--2.Function F2 có 1 tham số nhận vào là mã nhân viên. Function trả về số lượng phiếu xuất của nhân viên truyền vào. 
--Nếu nhân viên này không tồn tại thì trả về 0.
CREATE FUNCTION F2(@manv CHAR(5))
RETURNS INT AS
BEGIN
	DECLARE @dem INT
	IF @manv NOT IN(SELECT MANV FROM dbo.NHANVIEN)
		SET @dem = 0;
	ELSE
		SET @dem = (SELECT COUNT(B.MAPX) FROM dbo.PHIEUXUAT A,dbo.CTPX B WHERE A.MAPX = B.MAPX AND A.MANV = @manv)
	RETURN @dem
END
GO
--3.Function F3 có 1 tham số vào là năm, trả về danh sách các sản phẩm được xuất trong năm truyền vào. 
CREATE FUNCTION F3(@nam int)
RETURNS TABLE AS
	RETURN 
		SELECT C.MASP,C.TENSP,C.MALOAI
		FROM dbo.PHIEUXUAT A,dbo.CTPX B,dbo.SANPHAM C
		WHERE A.MAPX = B.MAPX AND B.MASP = C.MASP AND YEAR(A.NGAYLAP) = @nam
		GROUP BY  C.MASP,C.TENSP,C.MALOAI
GO
--4.Function F4 có một tham số vào là mã nhân viên để trả về danh sách các phiếu xuất của nhân viên đó. 
--Nếu mã nhân viên không truyền vào thì trả về tất cả các phiếu xuất.
CREATE FUNCTION F4(@manv CHAR(5))
RETURNS TABLE AS
	RETURN 
		SELECT A.MAPX,NGAYLAP,B.MASP,B.SOLUONG
		FROM dbo.PHIEUXUAT A,dbo.CTPX B
		WHERE A.MAPX = B.MAPX AND (MANV = @manv OR @manv = '') 
GO
--5.Function F5 để cho biết tên nhân viên của một phiếu xuất có mã phiếu xuất là tham số truyền vào.
CREATE FUNCTION F5(@mapx INT)
RETURNS NVARCHAR AS
BEGIN
	DECLARE @tennv NVARCHAR(30)
	SET @tennv = (SELECT A.HOTEN FROM dbo.NHANVIEN A,dbo.PHIEUXUAT B WHERE A.MANV = B.MANV AND B.MAPX = @mapx)
	RETURN @tennv
END
GO
--6.Function F6 để cho biết danh sách các phiếu xuất từ ngày T1 đến ngày T2. (T1, T2 là tham số truyền vào). Chú ý: T1 <= T2
CREATE FUNCTION F6 (@T1 DATE,@T2 DATE)
RETURNs TABLE AS
	RETURN 
		SELECT A.MAPX,A.NGAYLAP,A.MANV
		FROM dbo.PHIEUXUAT A
		WHERE A.NGAYLAP >= @T1 AND A.NGAYLAP <= @T2
GO
--7.	Function F7 để cho biết ngày xuất của một phiếu xuất với mã phiếu xuất là tham số truyền vào.
CREATE FUNCTION F7(@mapx INT)
RETURNS TABLE AS
	RETURN
		SELECT A.NGAYLAP
		FROM dbo.PHIEUXUAT A
		WHERE A.MAPX = @mapx
GO
--                   PROCEDURE              --
--1.Procedure tên là P1 cho có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong năm 2010 
--(Không viết lại truy vấn, hãy sử dụng Function F1 ở câu 4 để thực hiện)
CREATE PROCEDURE P1 (@tensp NVARCHAR(30))
AS BEGIN
	DECLARE @demsl INT
	SELECT @demsl = COUNT(B.MASP)
	FROM SANPHAM A,dbo.CTPX B,dbo.PHIEUXUAT C
	WHERE A.MASP = B.MASP AND B.MAPX = C.MAPX AND 
		  YEAR(C.NGAYLAP) = 2010 AND A.TENSP = @tensp
	PRINT N'Tổng số lượng sản phẩm ' + @tensp + N' trong năm 2010 la: ' + CONVERT(VARCHAR(5),@demsl)
END
GO
--Sử dụng Function F1
CREATE PROCEDURE P1_2(@tensp NVARCHAR(30))
AS BEGIN
	DECLARE @sl INT
	SET @sl = dbo.F1(@tensp,2010)
	PRINT N'Số lượng sản phẩm ' + @tensp + N' trong năm 2010 là : '+ CONVERT(VARCHAR(10),@sl) 
END
GO
--2.	Procedure tên là P2 có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010 
--(Chú ý: Nếu tên sản phẩm này không tồn tại thì trả về 0)
CREATE PROCEDURE P2 (@tensp NVARCHAR(30),@dem INT)
AS BEGIN
	IF @tensp NOT IN (SELECT TENSP FROM dbo.SANPHAM)
	BEGIN
		SET @dem = 0;
		PRINT N'Tổng số lượng sản phẩm ' + @tensp + N' xuất kho vào 4/2010 -> 6/2010 là : ' + CONVERT(VARCHAR(10),@dem)
	END
	ELSE
	BEGIN
		SELECT @dem = COUNT(B.MASP)
		FROM dbo.SANPHAM A,dbo.CTPX B,dbo.PHIEUXUAT C
		WHERE A.MASP = B.MASP AND B.MAPX = C.MAPX AND 
		(YEAR(C.NGAYLAP) = 2010 AND (MONTH(C.NGAYLAP) >= 4 OR MONTH(C.NGAYLAP) <= 6))
		AND A.TENSP = @tensp
		PRINT N'Tổng số lượng sản phẩm ' + @tensp + N' xuất kho vào 4/2010 -> 6/2010 là : ' + CONVERT(VARCHAR(10),@dem)
	END
END
GO
--3.	Procedure tên là P3 chỉ có duy nhất 1 tham số nhận vào là tên sản phẩm. 
--Trong Procedure này có khai báo 1 biến cục bộ được gán giá trị là: 
--số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010. 
--Việc gán trị này chỉ được thực hiện bằng cách gọi Procedure P2
CREATE PROCEDURE P3 (@tensp NVARCHAR(30))
AS BEGIN
	DECLARE @count INT
	EXEC P2 @tensp,@count
	PRINT @count
END
GO
--4.	Procedure P4 để INSERT một record vào trong table LOAI. Giá trị các field là tham số truyền vào.
CREATE PROCEDURE P4 (@maloai CHAR(5),@tenloai NVARCHAR(30))
AS
	INSERT INTO LOAI VALUES (@maloai,@tenloai)
GO
--5.	Procedure P5 để DELETE một record trong Table NhânViên theo mã nhân viên. Mã NV là tham số truyền vào.
CREATE PROCEDURE P5 (@manv CHAR(5))
AS 
	DELETE FROM NHANVIEN WHERE MANV = @manv
GO
--                         TRIGGER                --
--1.	Chỉ cho phép một phiếu xuất có tối đa 5 chi tiết phiếu xuất.
CREATE TRIGGER T1 ON dbo.CTPX
FOR INSERT,UPDATE AS
BEGIN
	DECLARE @count INT,@mapx INT
	SELECT @mapx = Inserted.MAPX FROM Inserted
	SELECT @count = COUNT(MASP) FROM dbo.CTPX WHERE MAPX = @mapx
	IF @count > 5
	BEGIN
		PRINT N'Chỉ cho phép có tối đa 5 phiếu xuất'
		ROLLBACK TRAN
	END
	ELSE
		PRINT N'Hoàn thành công việc'
END
GO
--2.	Chỉ cho phép một nhân viên lập tối đa 10 phiếu xuất trong một ngày.
CREATE TRIGGER T2 ON dbo.PHIEUXUAT
FOR INSERT , UPDATE AS
BEGIN
	DECLARE @dem INT,@ngayxp DATE,@manv CHAR(5)
	SELECT @manv = Inserted.MANV,@ngayxp = Inserted.NGAYLAP FROM Inserted
	SELECT @dem = COUNT(MAPX) FROM dbo.PHIEUXUAT WHERE MANV = @manv AND NGAYLAP = @ngayxp
	IF @dem > 10
	BEGIN
		PRINT N'Nhân viên này đã vượt hơn 10 phiếu'
		ROLLBACK TRAN
	END
	ELSE
		PRINT N'Thành Công'
END
GO
--3.	Khi người dùng viết 1 câu truy vấn nhập 1 dòng cho bảng chi tiết phiếu xuất thì CSDL kiểm tra, 
--nếu mã phiếu xuất mới đó chưa tồn tại trong bảng phiếu xuất thì CSDL sẽ không cho phép nhập 
--và thông báo lỗi “Phiếu xuất này không tồn tại”. Hãy viết 1 trigger đảm bảo điều này.
CREATE TRIGGER T3 ON dbo.CTPX
FOR INSERT , UPDATE AS
BEGIN
	DECLARE @mapx INT
	SELECT @mapx = Inserted.MAPX FROM Inserted
	IF @mapx NOT IN (SELECT MAPX FROM dbo.PHIEUXUAT)
	BEGIN
		PRINT N'Không tồn tại mã phiếu xuất này'
		ROLLBACK TRAN
	END
	ELSE
		PRINT N'Thành Công'
END
GO