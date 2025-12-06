import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../ai_features/presentation/bloc/transcription/transcription_bloc.dart';

/// Widget that displays real-time transcription during video call
/// Integrates AI Features transcription with Video Call UI
class InCallTranscriptionWidget extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final bool isDoctor;

  const InCallTranscriptionWidget({
    super.key,
    this.isExpanded = false,
    required this.onToggleExpand,
    required this.isDoctor,
  });

  @override
  State<InCallTranscriptionWidget> createState() => _InCallTranscriptionWidgetState();
}

class _InCallTranscriptionWidgetState extends State<InCallTranscriptionWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<TranscriptionEntry> _transcriptionEntries = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranscriptionBloc, TranscriptionState>(
      listener: (context, state) {
        if (state is TranscriptionSegmentAvailable) {
          _transcriptionEntries.add(TranscriptionEntry(
            text: state.segment.text,
            speakerName: state.segment.speakerName,
            isDoctor: state.segment.speakerId == 2, // Assume 2 is doctor
            timestamp: state.segment.startTime,
          ));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      },
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.isExpanded ? 200 : 60,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(state),
              
              // Transcription content
              if (widget.isExpanded)
                Expanded(
                  child: _buildTranscriptionContent(state),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(TranscriptionState state) {
    final isActive = state is TranscriptionActive;
    
    return GestureDetector(
      onTap: widget.onToggleExpand,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Recording indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? Colors.red : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            
            // Title
            Text(
              isActive ? 'Transcribing...' : 'Transcription',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const Spacer(),
            
            // Latest text preview (when collapsed)
            if (!widget.isExpanded && _transcriptionEntries.isNotEmpty)
              Expanded(
                child: Text(
                  _transcriptionEntries.last.text,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            
            // Expand/collapse icon
            Icon(
              widget.isExpanded 
                  ? Icons.keyboard_arrow_down 
                  : Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptionContent(TranscriptionState state) {
    if (state is TranscriptionInitial) {
      return const Center(
        child: Text(
          'Transcription not started',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    if (_transcriptionEntries.isEmpty) {
      return const Center(
        child: Text(
          'Waiting for speech...',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _transcriptionEntries.length,
      itemBuilder: (context, index) {
        final entry = _transcriptionEntries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Speaker label
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: entry.isDoctor 
                      ? Colors.blue.withValues(alpha: 0.3)
                      : Colors.green.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.isDoctor ? 'Dr' : 'Pt',
                  style: TextStyle(
                    color: entry.isDoctor ? Colors.blue : Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Text
              Expanded(
                child: Text(
                  entry.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A single transcription entry
class TranscriptionEntry {
  final String text;
  final String speakerName;
  final bool isDoctor;
  final DateTime timestamp;

  TranscriptionEntry({
    required this.text,
    required this.speakerName,
    required this.isDoctor,
    required this.timestamp,
  });
}
