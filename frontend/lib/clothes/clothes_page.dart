import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/clothes/add_cloth_dialog.dart';
import 'package:frontend/clothes/clothes_datasource.dart';

class ClothesPage extends StatefulWidget {
  const ClothesPage({super.key});

  @override
  State<ClothesPage> createState() => _ClothesPageState();
}

class _ClothesPageState extends State<ClothesPage> {
  final String baseUrl = 'http://localhost:3002';
  List<dynamic> mayTinhData = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  ClothesDataSource? _clothesDataSource;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData(
      {String? orderBy, String? order, String? keyword}) async {
    orderBy ??= 'MaMayTinh';
    order ??= 'ASC';
    keyword ??= '';
    final response = await Dio().get(
        '$baseUrl/api/maytinh?orderBy=$orderBy&order=$order&keyword=$keyword');

    if (response.statusCode == 200) {
      mayTinhData.clear();
      mayTinhData = response.data;
      setState(() {
        _clothesDataSource = ClothesDataSource(
          data: mayTinhData,
          onEdit: (int id) => _showAddClothesDialog(id),
          onDelete: (int id) => _deleteCloth(id),
        );
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _clothesDataSource == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _showAddClothesDialog(null),
                      child: const Text('Thêm Máy Tính'),
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
                          label: Text('Mã Máy Tính'),
                        ),
                        DataColumn(
                          label: const Text('Tên Máy Tính'),
                          onSort: (columnIndex, ascending) {
                            fetchData(
                              orderBy: 'TenMayTinh',
                              order: ascending ? 'ASC' : 'DESC',
                            );
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text('Giá Bán'),
                          onSort: (columnIndex, ascending) {
                            fetchData(
                              orderBy: 'GiaBan',
                              order: ascending ? 'ASC' : 'DESC',
                            );
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text('Số Lượng'),
                          onSort: (columnIndex, ascending) {
                            fetchData(
                              orderBy: 'SoLuong',
                              order: ascending ? 'ASC' : 'DESC',
                            );
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        const DataColumn(label: Text('Chức Năng')),
                      ],
                      source: _clothesDataSource ??
                          ClothesDataSource(
                            data: [],
                            onEdit: (int id) => _showAddClothesDialog(id),
                            onDelete: (int id) => _deleteCloth(id),
                          ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _showAddClothesDialog(int? id) async {
    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Thêm Máy Tính' : 'Sửa Máy Tính'),
          content: AddClothDialog(id: id),
        );
      },
    );
    if (result) {
      fetchData();
    }
  }

  void _deleteCloth(int id) async {
    final response = await Dio().delete('$baseUrl/api/maytinh/$id');
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
