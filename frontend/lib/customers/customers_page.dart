import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/clothes/clothes_datasource.dart';
import 'package:frontend/customers/add_customer_dialog.dart';
import 'package:frontend/customers/customers_datasource.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _PageState();
}

class _PageState extends State<CustomersPage> {
  final String baseUrl = 'http://localhost:3002';
  List<dynamic> customerData = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  CustomersDataSource? _dataSource;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData(
      {String? orderBy, String? order, String? keyword}) async {
    orderBy ??= 'MaKhachHang';
    order ??= 'ASC';
    keyword ??= '';
    final response = await Dio().get(
        '$baseUrl/api/khachhang?orderBy=$orderBy&order=$order&keyword=$keyword');

    if (response.statusCode == 200) {
      customerData.clear();
      customerData = response.data;
      setState(() {
        _dataSource = CustomersDataSource(
          data: customerData,
          onEdit: (int id) => _showAddCustomerDialog(id),
          onDelete: (int id) => _deleteCustomer(id),
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
                      onPressed: () => _showAddCustomerDialog(null),
                      child: const Text('Thêm Khách Hàng'),
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
                          label: Text('Mã Khách Hàng'),
                        ),
                        DataColumn(
                          label: const Text('Tên Khách Hàng'),
                          onSort: (columnIndex, ascending) {
                            fetchData(
                              orderBy: 'TenKhachHang',
                              order: ascending ? 'ASC' : 'DESC',
                            );
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        const DataColumn(
                          label: Text('Địa Chỉ'),
                        ),
                        const DataColumn(
                          label: Text('Số ĐT'),
                        ),
                        const DataColumn(label: Text('Chức Năng')),
                      ],
                      source: _dataSource ??
                          ClothesDataSource(
                            data: [],
                            onEdit: (int id) => _showAddCustomerDialog(id),
                            onDelete: (int id) => _deleteCustomer(id),
                          ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _showAddCustomerDialog(int? id) async {
    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Thêm Khách Hàng' : 'Sửa Khách Hàng'),
          content: AddCustomerDialog(id: id),
        );
      },
    );
    if (result) {
      fetchData();
    }
  }

  void _deleteCustomer(int id) async {
    final response = await Dio().delete('$baseUrl/api/khachhang/$id');
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
