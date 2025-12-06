import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../transcription/transcription_bloc.dart';
import 'transcript_text.dart';

/// Widget to display transcription overlay
class TranscriptionOverlay extends StatelessWidget {
  const TranscriptionOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptionBloc, TranscriptionState>(
      builder: (context, state) {
        if (state is TranscriptionActive) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Transcribing...',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}