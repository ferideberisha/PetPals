import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/components/my_textfield.dart'; // Import MyTextField

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _obscureCurrentPassword = !_obscureCurrentPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmNewPasswordVisibility() {
    setState(() {
      _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
    });
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Your logic to change the password goes here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyTextField(
                controller: _currentPasswordController,
                hintText: 'Current Password',
                obscureText: _obscureCurrentPassword,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: _toggleCurrentPasswordVisibility,
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: _newPasswordController,
                hintText: 'New Password',
                obscureText: _obscureNewPassword,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: _toggleNewPasswordVisibility,
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: _confirmNewPasswordController,
                hintText: 'Confirm New Password',
                obscureText: _obscureConfirmNewPassword,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: _toggleConfirmNewPasswordVisibility,
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: _changePassword,
                text: 'Change Password',
                color: const Color(0xFF967BB6),
                textColor: Colors.white,
                borderColor: const Color(0xFF967BB6),
                borderWidth: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
