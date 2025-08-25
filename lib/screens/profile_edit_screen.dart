import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/widgets/custom_submit_button_dialog.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfileEditScreen extends StatelessWidget {
  final phoneFormatter = MaskTextInputFormatter(
    mask: '+62 ###-####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final InputDecoration fieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    // labelStyle: const TextStyle(fontSize: 16),
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

  ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      // appBar: AppBar(title: Text('Edit Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: profileProvider.formKey,
            child: Column(
              children: [
                // Header Profile
                _headerProfileImage(context, profileProvider),
                const SizedBox(height: 16),

                // Expanded area untuk form
                Expanded(
                  child: _contentInputField(
                    context,
                    profileProvider,
                    fieldDecoration,
                    phoneFormatter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _headerProfileImage(
  BuildContext context,
  ProfileProvider profileProvider,
) {
  return Stack(
    children: [
      Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
      ),
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipOval(
            child: profileProvider.profileImage != null
                ? Image.file(
                    profileProvider.profileImage!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/img/profile.jpg",
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
      Positioned(
        bottom: 1,
        right: 125,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade100,
          child: IconButton(
            onPressed: profileProvider.pickImage,
            icon: const Icon(Icons.photo_camera, color: Colors.blue),
            tooltip: 'Pick image',
          ),
        ),
      ),
    ],
  );
}

Widget _contentInputField(
  BuildContext context,
  ProfileProvider profileProvider,
  InputDecoration fieldDecoration,
  MaskTextInputFormatter phoneFormatter,
) {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Scrollable form
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: profileProvider.fullNameController,
                    decoration: fieldDecoration.copyWith(
                      labelText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Full name is required";
                      }
                      if (value.length < 3) {
                        return "Full name must be at least 3 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: profileProvider.positionController,
                    decoration: fieldDecoration.copyWith(labelText: 'Position'),
                    autofillHints: [AutofillHints.jobTitle],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Position is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: fieldDecoration.copyWith(
                      labelText: 'Department',
                    ),
                    value: profileProvider.departmentController.text.isEmpty
                        ? null
                        : profileProvider.departmentController.text,
                    items:
                        [
                              'Fullstack Development',
                              'Mobile Development',
                              'UI/UX Design',
                              'DevOps',
                              'QA / Testing',
                            ]
                            .map(
                              (department) => DropdownMenuItem(
                                value: department,
                                child: Text(department),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      profileProvider.departmentController.text = value ?? '';
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a department'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: profileProvider.emailController,
                    decoration: fieldDecoration.copyWith(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!regex.hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: profileProvider.phoneController,
                    decoration: fieldDecoration.copyWith(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [phoneFormatter],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: profileProvider.locationController,
                    decoration: fieldDecoration.copyWith(labelText: 'Location'),
                    autofillHints: [AutofillHints.addressCityAndState],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Location is required";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Discard changes'),
                      content: const Text(
                        'Are you sure want to discard changes?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            profileProvider.discardChanges();

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Cancel'),
              ),
              CustomSubmitButtonDialog(
                submitText: 'Update',
                titleDialog: 'Confirm Update Profile',
                contentDialog: 'Are you sure want to update?',
                confirmButtonDialogText: 'Update Profile',
                validateForm: profileProvider.validateForm,
                onSubmitAsync: () async =>
                    await profileProvider.updateProfile(),
                successMessage: 'Profile updated successfully.',
                errorMessage: 'Update failed',
                onSuccessRedirect: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
