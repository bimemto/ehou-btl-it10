import 'package:flutter/material.dart';

class ClothesDataSource extends DataTableSource {
  List<dynamic> data;
  final Function(int id) onEdit;
  final Function(int id) onDelete;

  ClothesDataSource({
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
        DataCell(Text(data[index]['MaMayTinh'].toString())),
        DataCell(Text(data[index]['TenMayTinh'] ?? '')),
        DataCell(Text(data[index]['GiaBan'].toString())),
        DataCell(Text(data[index]['SoLuong'].toString())),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () => onEdit(data[index]['MaMayTinh']),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => onDelete(data[index]['MaMayTinh']),
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
