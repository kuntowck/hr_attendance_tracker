import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/loading_dialog.dart';

class CustomSubmitButtonDialog extends StatelessWidget {
  final String submitText;
  final String titleDialog;
  final String contentDialog;
  final String confirmButtonDialogText;

  final bool Function()? validateForm;
  final Future<void> Function()? onSubmitAsync;
  final VoidCallback? onSubmitSync;
  final bool showLoading;

  final String successMessage;
  final String errorMessage;
  final VoidCallback? onSuccessRedirect;

  const CustomSubmitButtonDialog({
    super.key,
    required this.submitText,
    required this.titleDialog,
    required this.contentDialog,
    required this.confirmButtonDialogText,
    this.validateForm,
    this.onSubmitAsync,
    this.onSubmitSync,
    this.showLoading = true,
    this.successMessage = "Success",
    this.errorMessage = "Error occurred",
    this.onSuccessRedirect,
  }) : assert(
         (onSubmitAsync != null || onSubmitSync != null),
         'Either onSubmitAsync or onSubmitSync must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (validateForm!()) {
          showDialog(
            context: context,
            builder: (contenxt) => AlertDialog(
              title: Text(titleDialog),
              content: Text(contentDialog),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);

                    Navigator.pop(context, true);

                    if (showLoading && onSubmitAsync != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const LoadingDialog();
                        },
                      );
                    }
                    try {
                      if (onSubmitAsync != null) {
                        await onSubmitAsync!();
                      } else if (onSubmitSync != null) {
                        onSubmitSync!();
                      }

                      if (showLoading && onSubmitAsync != null) {
                        navigator.pop();
                      }

                      messenger.showSnackBar(
                        SnackBar(content: Text(successMessage)),
                      );

                      if (onSuccessRedirect != null) {
                        onSuccessRedirect!();
                      }
                    } catch (e) {
                      if (showLoading && onSubmitAsync != null) {
                        navigator.pop();
                      }

                      messenger.showSnackBar(
                        SnackBar(content: Text('$errorMessage: $e')),
                      );
                    }
                  },
                  child: Text(confirmButtonDialogText),
                ),
              ],
            ),
          );
        }
      },
      child: Text(submitText),
    );
  }
}
