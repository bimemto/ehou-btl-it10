import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddClothDialog extends StatefulWidget {
  final int? id;

  const AddClothDialog({super.key, this.id});

  @override
  State<AddClothDialog> createState() => _AddClothDialogState();
}

class _AddClothDialogState extends State<AddClothDialog> {
  final String baseUrl = 'http://localhost:3002';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    if (widget.id != null) {
      Dio().get('$baseUrl/api/maytinh/${widget.id}').then((value) {
        if (value.statusCode == 200) {
          final data = value.data;
          _nameController.text = data[0]['TenMayTinh'];
          _priceController.text = data[0]['GiaBan'].toString();
          _quantityController.text = data[0]['SoLuong'].toString();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Tên Máy Tính',
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Giá Bán',
          ),
          keyboardType: TextInputType.number,
          controller: _priceController,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Số Lượng',
          ),
          keyboardType: TextInputType.number,
          controller: _quantityController,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _addCloth,
          child: Text(widget.id == null ? 'Thêm Máy Tính' : 'Cập Nhật'),
        ),
      ],
    );
  }

  _addCloth() {
    final name = _nameController.text;
    final price = _priceController.text;
    final quantity = _quantityController.text;

    if (name.isNotEmpty && price.isNotEmpty && quantity.isNotEmpty) {
      if (widget.id == null) {
        Dio().post('$baseUrl/api/maytinh', data: {
          'TenMayTinh': name,
          'GiaBan': price,
          'SoLuong': quantity,
        }).then((value) {
          if (value.statusCode == 200) {
            Navigator.of(context).pop(true);
          }
        });
      } else {
        Dio().put('$baseUrl/api/maytinh/${widget.id}', data: {
          'TenMayTinh': name,
          'GiaBan': price,
          'SoLuong': quantity,
        }).then((value) {
          if (value.statusCode == 200) {
            Navigator.of(context).pop(true);
          }
        });
      }
    }
  }
}
