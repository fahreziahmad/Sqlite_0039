import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';

class UserFormPage extends StatefulWidget {
  final UserEntity? user;
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _noTelponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _noTelponController.text = widget.user!.noTelpon;
      _alamatController.text = widget.user!.alamat;
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validateNoTelpon(String? value) {
    if (value == null || value.isEmpty) {
      return 'No Telpon tidak boleh kosong';
    }
    if (!value.startsWith('+62')) {
      return 'No Telpon harus dimulai dengan +62';
    }
    if (value.length > 15) {
      return 'No Telpon tidak boleh lebih dari 15 karakter';
    }
    final phoneRegex = RegExp(r'^\+62\d+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format No Telpon tidak valid';
    }
    return null;
  }

  String? _validateAlamat(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat tidak boleh kosong';
    }
    if (value.length < 5) {
      return 'Alamat minimal 5 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit User" : "Tambah User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _noTelponController,
                  decoration: const InputDecoration(
                    labelText: "No Telpon (contoh: +6281234567890)",
                    border: OutlineInputBorder(),
                    hintText: "+62",
                  ),
                  validator: _validateNoTelpon,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _alamatController,
                  decoration: const InputDecoration(
                    labelText: "Alamat",
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAlamat,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newUser = UserEntity(
                          id: isEdit ? widget.user!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text,
                          email: _emailController.text,
                          noTelpon: _noTelponController.text,
                          alamat: _alamatController.text,
                        );

                        if (isEdit) {
                          context.read<UserBloc>().add(UpdateUserEvent(newUser));
                        } else {
                          context.read<UserBloc>().add(AddUserEvent(newUser));
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text(isEdit ? "Simpan Perubahan" : "Simpan User Baru"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _noTelponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }
}