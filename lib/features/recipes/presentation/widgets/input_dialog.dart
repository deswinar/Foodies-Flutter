import 'package:flutter/material.dart';

class InputDialog extends StatelessWidget {
  final String label;

  const InputDialog({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text('Add $label'),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Enter $label'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final input = controller.text.trim();
            Navigator.of(context).pop(input.isEmpty ? null : input);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
