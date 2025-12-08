import 'package:flutter/material.dart';

class DocumentViewerPage extends StatelessWidget {
  final String documentUrl;
  final String documentTitle;

  const DocumentViewerPage({
    super.key,
    required this.documentUrl,
    required this.documentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(documentTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download functionality
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.picture_as_pdf,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              documentTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('PDF Document'),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement document opening functionality
                },
                icon: const Icon(Icons.visibility),
                label: const Text('View Document'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Document viewing functionality would be implemented here\n'
              'using a PDF viewer plugin or web view for online documents.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
