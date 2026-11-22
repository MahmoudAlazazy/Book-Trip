import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import 'profile_page_scaffold.dart';

class MyInformationScreen extends StatefulWidget {
  const MyInformationScreen({super.key});

  @override
  State<MyInformationScreen> createState() => _MyInformationScreenState();
}

class _MyInformationScreenState extends State<MyInformationScreen> {
  final _imagePicker = ImagePicker();
  XFile? _profileImage;
  final _nameController = TextEditingController(text: 'Mahmoud Al AzaZy');
  final _emailController = TextEditingController(text: 'ahmed@example.com');
  final _phoneController = TextEditingController(text: '+20 1023117751');
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProfilePageScaffold(
    title: 'My Information',
    backgroundImage: 'assets/images/خلفية سفر عصرية بخريطة وطائرة.webp',
    showSocialIcons: false,
    child: Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: const Color(0xFFB9F0F3),
              child: _profileImage == null
                  ? const CircleAvatar(
                      radius: 39,
                      backgroundColor: Color(0xFF10233F),
                      child: Text(
                        'AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 39,
                      backgroundImage: FileImage(File(_profileImage!.path)),
                    ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.teal,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _pickProfileImage,
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                tooltip: context.tr('Change profile photo'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _InformationField(
          label: context.tr('Full Name'),
          controller: _nameController,
        ),
        _InformationField(
          label: context.tr('Email Address'),
          controller: _emailController,
        ),
        _InformationField(
          label: context.tr('Phone Number'),
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.tr('Change Password'),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 10),
        _PasswordField(
          controller: _currentPasswordController,
          label: context.tr('Current Password'),
        ),
        _PasswordField(
          controller: _newPasswordController,
          label: context.tr('New Password'),
        ),
        _PasswordField(
          controller: _confirmPasswordController,
          label: context.tr('Confirm Password'),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('Information saved successfully')),
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.teal,
              shape: const StadiumBorder(),
            ),
            child: Text(
              context.tr('Save Changes'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> _pickProfileImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null && mounted) setState(() => _profileImage = image);
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the photo gallery. Please try again.'),
        ),
      );
    }
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
    ),
  );
}

class _InformationField extends StatelessWidget {
  const _InformationField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    ),
  );
}
