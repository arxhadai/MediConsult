import 'package:flutter/material.dart';

class EmptyRecordsWidget extends StatelessWidget {
  const EmptyRecordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No medical records found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload your first medical document to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to upload document page
              // This would typically be handled by the parent widget
            },
            icon: const Icon(Icons.upload),
            label: const Text('Upload Document'),
          ),
        ],
      ),
    );
  }
}
