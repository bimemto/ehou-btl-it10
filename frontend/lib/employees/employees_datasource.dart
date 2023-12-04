import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeDataSource extends DataTableSource {
  List<dynamic> data;
  final Function(int id) onEdit;
  final Function(int id) onDelete;

  EmployeeDataSource({
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
        DataCell(Text(data[index]['MaNV'].toString())),
        DataCell(Text(data[index]['TenNV'])),
        DataCell(Text(data[index]['GioiTinh'])),
        DataCell(Text(data[index]['QueQuan'])),
        DataCell(Text(data[index]['SDT'])),
        DataCell(Text(
          DateFormat('dd/MM/yyyy').format(
            DateTime.parse(data[index]['NgayVaoLam']),
          ),
        )),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () => onEdit(data[index]['MaNV']),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => onDelete(data[index]['MaNV']),
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
