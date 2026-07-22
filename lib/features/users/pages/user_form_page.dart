import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../models/user_model.dart';
import '../providers/users_provider.dart';

class UserFormPage extends ConsumerStatefulWidget {
  final UserModel? user;
  const UserFormPage({Key? key, this.user}) : super(key: key);

  @override
  ConsumerState<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends ConsumerState<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  
  String _role = 'Operator';
  String _status = 'Aktif';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _namaController.text = widget.user!.nama;
      _usernameController.text = widget.user!.username;
      _emailController.text = widget.user!.email;
      _teleponController.text = widget.user!.nomorTelepon;
      _role = widget.user!.role;
      _status = widget.user!.statusAktif;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.user != null;
      final newUser = UserModel(
        idUser: isEditing ? widget.user!.idUser : const Uuid().v4(),
        nama: _namaController.text,
        username: _usernameController.text,
        email: _emailController.text,
        nomorTelepon: _teleponController.text,
        role: _role,
        statusAktif: _status,
      );

      if (isEditing) {
        ref.read(usersProvider.notifier).updateUser(newUser);
      } else {
        ref.read(usersProvider.notifier).addUser(newUser);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pengguna berhasil disimpan')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Tambah Pengguna' : 'Edit Pengguna'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Nama Lengkap',
                controller: _namaController,
                validator: (val) => Validators.required(val, 'Nama Lengkap'),
              ),
              const SizedBox(height: AppSizes.p16),
              AppTextField(
                label: 'Username',
                controller: _usernameController,
                validator: (val) => Validators.required(val, 'Username'),
              ),
              const SizedBox(height: AppSizes.p16),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => Validators.required(val, 'Email'),
              ),
              const SizedBox(height: AppSizes.p16),
              AppTextField(
                label: 'Nomor Telepon',
                controller: _teleponController,
                keyboardType: TextInputType.phone,
                validator: (val) => Validators.required(val, 'Nomor Telepon'),
              ),
              const SizedBox(height: AppSizes.p16),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Role Pengguna'),
                items: ['Administrator', 'Operator'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) => setState(() => _role = val!),
              ),
              const SizedBox(height: AppSizes.p16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status Aktif'),
                items: ['Aktif', 'Tidak Aktif'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: AppSizes.p32),
              PrimaryButton(
                text: 'Simpan Data',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
