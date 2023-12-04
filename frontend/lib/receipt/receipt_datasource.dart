import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptDataSource extends DataTableSource {
  List<dynamic> data;
  final Function(int id) onEdit;
  final Function(int id) onDelete;

  ReceiptDataSource({
    required this.data,
    required this.onDelete,
    required this.onEdit,
  });

  void sort<T>(String field, bool ascending) {
    data.sort((dynamic a, dynamic b) {
      final Comparable<T> aValue = a[field];
      final Comparable<T> bValue = b[field];
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(data[index]['MaHD'].toString())),
        DataCell(
          Text(
            DateFormat('dd/MM/yyyy').format(
              DateTime.parse(data[index]['NgayLap']),
            ),
          ),
        ),
        DataCell(Text(data[index]['TenKhachHang'])),
        DataCell(Text(data[index]['TenNV'])),
        DataCell(Text(data[index]['TenMayTinh'])),
        DataCell(Text(data[index]['SoLuong'].toString())),
        DataCell(Text(data[index]['GiaBan'].toString())),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () => onEdit(data[index]['MaHD']),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => onDelete(data[index]['MaHD']),
              icon: const Icon(Icons.delete),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
