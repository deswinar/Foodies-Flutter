import 'package:flutter/material.dart';

class InteractiveList extends StatelessWidget {
  final String label;
  final List<String> items;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const InteractiveList({
    super.key,
    required this.label,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => onRemove(index),
            ),
          );
        }),
      ],
    );
  }
}
