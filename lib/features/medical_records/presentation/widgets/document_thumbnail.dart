import 'package:flutter/material.dart';
import '../../domain/entities/health_document.dart';

class DocumentThumbnail extends StatelessWidget {
  final HealthDocument document;
  final VoidCallback? onTap;

  const DocumentThumbnail({
    super.key,
    required this.document,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: document.thumbnailUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      document.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder(document);
                      },
                    ),
                  )
                : _buildPlaceholder(document),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              document.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(HealthDocument document) {
    IconData icon;
    Color color;

    if (document.isImage) {
      icon = Icons.image;
      color = Colors.blue;
    } else if (document.isPdf) {
      icon = Icons.picture_as_pdf;
      color = Colors.red;
    } else {
      icon = Icons.insert_drive_file;
      color = Colors.grey;
    }

    return Icon(
      icon,
      size: 40,
      color: color.withValues(alpha: 0.7),
    );
  }
}
