import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class AddEmployeeDialog extends StatefulWidget {
  final int? id;

  const AddEmployeeDialog({super.key, this.id});

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final String baseUrl = 'http://localhost:3002';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _homeTownController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _joinedDateController =
      MaskedTextController(mask: '0000-00-00');

  @override
  void initState() {
    if (widget.id != null) {
      Dio().get('$baseUrl/api/nhanvien/${widget.id}').then((value) {
        if (value.statusCode == 200) {
          final data = value.data;
          _nameController.text = data[0]['TenNV'];
          _genderController.text = data[0]['GioiTinh'];
          _homeTownController.text = data[0]['QueQuan'];
          _phoneController.text = data[0]['SDT'];
          _joinedDateController.text = data[0]['NgayVaoLam'];
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
            labelText: 'Tên Nhân Viên',
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Giới Tính',
          ),
          keyboardType: TextInputType.text,
          controller: _genderController,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Quê Quán',
          ),
          keyboardType: TextInputType.text,
          controller: _homeTownController,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Số ĐT',
          ),
          keyboardType: TextInputType.number,
          controller: _phoneController,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Ngày Vào Làm',
            hintText: 'YYYY-MM-DD',
          ),
          keyboardType: TextInputType.text,
          controller: _joinedDateController,
        ),
        const SizedBox(height: 12),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _addCloth,
          child: Text(widget.id == null ? 'Thêm Nhân Viên' : 'Cập Nhật'),
        ),
      ],
    );
  }

  _addCloth() {
    final name = _nameController.text;
    final gender = _genderController.text;
    final hometown = _homeTownController.text;
    final phone = _phoneController.text;
    final joinedDate = _joinedDateController.text;

    if (name.isNotEmpty &&
        gender.isNotEmpty &&
        hometown.isNotEmpty &&
        phone.isNotEmpty &&
        joinedDate.isNotEmpty) {
      if (widget.id == null) {
        Dio().post('$baseUrl/api/nhanvien', data: {
          'TenNV': name,
          'GioiTinh': gender,
          'QueQuan': hometown,
          'SDT': phone,
          'NgayVaoLam': joinedDate,
        }).then((value) {
          if (value.statusCode == 200) {
            Navigator.of(context).pop(true);
          }
        });
      } else {
        Dio().put('$baseUrl/api/nhanvien/${widget.id}', data: {
          'TenNV': name,
          'GioiTinh': gender,
          'QueQuan': hometown,
          'SDT': phone,
          'NgayVaoLam': joinedDate,
        }).then((value) {
          if (value.statusCode == 200) {
            Navigator.of(context).pop(true);
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
        ),
      );
    }
  }
}
