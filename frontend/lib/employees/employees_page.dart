import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/clothes/clothes_datasource.dart';
import 'package:frontend/employees/add_employee_dialog.dart';
import 'package:frontend/employees/employees_datasource.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _PageState();
}

class _PageState extends State<EmployeesPage> {
  final String baseUrl = 'http://localhost:3002';
  List<dynamic> employeeData = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  EmployeeDataSource? _dataSource;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData(
      {String? orderBy, String? order, String? keyword}) async {
    orderBy ??= 'MaNV';
    order ??= 'ASC';
    keyword ??= '';
    final response = await Dio().get(
        '$baseUrl/api/nhanvien?orderBy=$orderBy&order=$order&keyword=$keyword');

    if (response.statusCode == 200) {
      employeeData.clear();
      employeeData = response.data;
      setState(() {
        _dataSource = EmployeeDataSource(
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
                    ElevatedButton(
                      onPressed: () => _showAddEmployeeDialog(null),
                      child: const Text('Thêm Nhân Viên'),
                    ),
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
                          label: Text('Mã Nhân Viên'),
                        ),
                        DataColumn(
                          label: const Text('Tên Nhân Viên'),
                          onSort: (columnIndex, ascending) {
                            fetchData(
                              orderBy: 'TenNV',
                              order: ascending ? 'ASC' : 'DESC',
                            );
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        const DataColumn(
                          label: Text('Giới Tính'),
                        ),
                        const DataColumn(
                          label: Text('Quê Quán'),
                        ),
                        const DataColumn(
                          label: Text('Số ĐT'),
                        ),
                        const DataColumn(
                          label: Text('Ngày Vào Làm'),
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
          fetchData(keyword: value);
        });
  }
}
