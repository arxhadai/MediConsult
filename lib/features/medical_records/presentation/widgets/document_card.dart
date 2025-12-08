import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/enums/document_type.dart';

class DocumentCard extends StatelessWidget {
  final HealthDocument document;
  final VoidCallback? onTap;
  final VoidCallback? onShare;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with document icon and title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      document.type.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          document.type.displayName,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: onShare,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Document details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy')
                            .format(document.documentDate),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Size',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        document.fileSizeFormatted,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Tags
              if (document.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: document.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      labelStyle: const TextStyle(fontSize: 12),
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
