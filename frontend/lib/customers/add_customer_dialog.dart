import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddCustomerDialog extends StatefulWidget {
  final int? id;

  const AddCustomerDialog({super.key, this.id});

  @override
  State<AddCustomerDialog> createState() => _DialogState();
}

class _DialogState extends State<AddCustomerDialog> {
  final String baseUrl = 'http://localhost:3002';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneTownController = TextEditingController();

  @override
  void initState() {
    if (widget.id != null) {
      Dio().get('$baseUrl/api/khachhang/${widget.id}').then((value) {
        if (value.statusCode == 200) {
          final data = value.data;
          _nameController.text = data[0]['TenKhachHang'];
          _addressController.text = data[0]['DiaChi'];
          _phoneTownController.text = data[0]['SDT'];
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
            labelText: 'Tên Khách Hàng',
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Địa Chỉ',
          ),
          keyboardType: TextInputType.text,
          controller: _addressController,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Số ĐT',
          ),
          keyboardType: TextInputType.text,
          controller: _phoneTownController,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _addCloth,
          child: Text(widget.id == null ? 'Thêm Khách Hàng' : 'Cập Nhật'),
        ),
      ],
    );
  }

  _addCloth() {
    final name = _nameController.text;
    final address = _addressController.text;
    final phone = _phoneTownController.text;

    if (name.isNotEmpty && address.isNotEmpty && phone.isNotEmpty) {
      if (widget.id == null) {
        Dio().post('$baseUrl/api/khachhang', data: {
          'TenKhachHang': name,
          'DiaChi': address,
          'SDT': phone,
        }).then((value) {
          if (value.statusCode == 200) {
            Navigator.of(context).pop(true);
          }
        });
      } else {
        Dio().put('$baseUrl/api/khachhang/${widget.id}', data: {
          'TenKhachHang': name,
          'DiaChi': address,
          'SDT': phone,
        }).then((value) {
          if (value.statusCode == 200) {
            Navigator.of(context).pop(true);
          }
        });
      }
    }
  }
}
