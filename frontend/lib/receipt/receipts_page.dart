import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/clothes/clothes_datasource.dart';
import 'package:frontend/employees/add_employee_dialog.dart';
import 'package:frontend/employees/employees_datasource.dart';
import 'package:frontend/receipt/receipt_datasource.dart';

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({super.key});

  @override
  State<ReceiptsPage> createState() => _PageState();
}

class _PageState extends State<ReceiptsPage> {
  final String baseUrl = 'http://localhost:3002';
  List<dynamic> employeeData = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  ReceiptDataSource? _dataSource;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData({
    String? orderBy,
    String? order,
  }) async {
    final response =
        await Dio().get('$baseUrl/api/hoadon?orderBy=$orderBy&order=$order');

    if (response.statusCode == 200) {
      employeeData.clear();
      employeeData = response.data;
      setState(() {
        _dataSource = ReceiptDataSource(
          data: employeeData,
          onEdit: (int id) => _showAddEmployeeDialog(id),
          onDelete: (int id) => _deleteEmployee(id),
        );
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dataSource == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    PaginatedDataTable(
                      header: _buildSearchField(),
                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: const <int>[5, 10, 20],
                      onRowsPerPageChanged: (int? value) {
                        setState(() {
                          _rowsPerPage = value ?? 10;
                        });
                      },
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      columns: <DataColumn>[
                        const DataColumn(
                          label: Text('Mã Hóa Đơn'),
                        ),
                        DataColumn(
                          label: const Text('Tên Ngày Lập'),
                          onSort: (columnIndex, ascending) {
                            fetchData(
                              orderBy: 'NgayLap',
                              order: ascending ? 'ASC' : 'DESC',
                            );
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        const DataColumn(
                          label: Text('Tên Khách Hàng'),
                        ),
                        const DataColumn(
                          label: Text('Tên Nhân Viên'),
                        ),
                        const DataColumn(
                          label: Text('Tên Máy Tính'),
                        ),
                        const DataColumn(
                          label: Text('Giá Bán'),
                        ),
                        const DataColumn(
                          label: Text('Số Lượng'),
                        ),
                        const DataColumn(label: Text('Chức Năng')),
                      ],
                      source: _dataSource ??
                          ClothesDataSource(
                            data: [],
                            onEdit: (int id) => _showAddEmployeeDialog(id),
                            onDelete: (int id) => _deleteEmployee(id),
                          ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _showAddEmployeeDialog(int? id) async {
    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Thêm Nhân Viên' : 'Sửa Nhân Viên'),
          content: AddEmployeeDialog(id: id),
        );
      },
    );
    if (result) {
      fetchData();
    }
  }

  void _deleteEmployee(int id) async {
    final response = await Dio().delete('$baseUrl/api/nhanvien/$id');
    if (response.statusCode == 200) {
      fetchData();
    }
  }

  Widget _buildSearchField() {
    return TextField(
        decoration: const InputDecoration(
          hintText: 'Tìm kiếm',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          //fetchData(keyword: value);
        });
  }
}
