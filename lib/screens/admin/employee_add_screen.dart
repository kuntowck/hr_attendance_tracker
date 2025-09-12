import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/admin_provider.dart';
// import 'package:hr_attendance_tracker/widgets/custom_submit_button_dialog.dart';
import 'package:provider/provider.dart';

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   final provider = context.read<AdminProvider>();
  //   await provider.addEmployee(
  //     _emailController.text.trim(),
  //     _passwordController.text.trim(),
  //     _nameController.text.trim(),
  //   );
  //   if (mounted) {
  //     if (provider.errorMessage == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Employee created successfully")),
  //       );
  //       Navigator.pop(context);
  //     } else {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final InputDecoration fieldDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );

    final provider = context.watch<AdminProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Employee")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: fieldDecoration.copyWith(labelText: "Name"),
                      validator: (value) => value == null || value.isEmpty
                          ? "Name is required"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: fieldDecoration.copyWith(labelText: "Email"),
                      validator: (value) => value == null || value.isEmpty
                          ? "Email is required"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: fieldDecoration.copyWith(
                        labelText: "Password",
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? "Password must be 6+ chars"
                          : null,
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final provider = context.read<AdminProvider>();
                        await provider.addEmployee(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(),
                        );

                        if (mounted) {
                          if (provider.errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Employee created successfully"),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.errorMessage!)),
                            );
                          }
                        }
                      },
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Create Employee"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
