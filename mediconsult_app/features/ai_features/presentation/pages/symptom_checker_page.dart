import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/symptom_analysis.dart';
import '../../domain/enums/urgency_level.dart';
import '../bloc/symptom_checker/symptom_checker_bloc.dart';
import '../widgets/chat/chat_bubble.dart';
import '../widgets/chat/ai_typing_indicator.dart';
import '../widgets/chat/chat_input_field.dart';

/// Page for symptom checker feature
class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final _scrollController = ScrollController();
  final List<Widget> _chatWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: BlocConsumer<SymptomCheckerBloc, SymptomCheckerState>(
        listener: (context, state) {
          if (state is SymptomCheckerSuccess) {
            _showAnalysisResult(state.analysis);
          } else if (state is ChatMessageReceived) {
            _showChatMessage(state.message);
          } else if (state is SymptomCheckerError) {
            _showError(state.message);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Describe your symptoms and I\'ll help analyze them:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ..._chatWidgets,
                    if (state is SymptomCheckerLoading) const AiTypingIndicator(),
                  ],
                ),
              ),
              ChatInputField(
                onSend: _sendMessage,
                isEnabled: state is! SymptomCheckerLoading,
              ),
            ],
          );
        },
      ),
    );
  }

  void _sendMessage(String message) {
    context.read<SymptomCheckerBloc>().add(ChatMessageSent(message: message));
  }

  void _showAnalysisResult(SymptomAnalysis analysis) {
    setState(() {
      _chatWidgets.add(
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Result',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text('Summary: ${analysis.summary}'),
                const SizedBox(height: 8),
                Text('Urgency: ${_urgencyToString(analysis.urgencyLevel)}'),
                const SizedBox(height: 8),
                Text('Recommendations: ${analysis.recommendations}'),
              ],
            ),
          ),
        ),
      );
    });
    
    _scrollToBottom();
  }

  void _showChatMessage(dynamic message) {
    setState(() {
      _chatWidgets.add(ChatBubble(message: message));
    });
    
    _scrollToBottom();
  }

  void _showError(String message) {
    setState(() {
      _chatWidgets.add(
        Card(
          margin: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ),
      );
    });
    
    _scrollToBottom();
  }

  String _urgencyToString(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.low:
        return 'Low - Routine care';
      case UrgencyLevel.medium:
        return 'Medium - Soon care needed';
      case UrgencyLevel.high:
        return 'High - Immediate care needed';
      case UrgencyLevel.emergency:
        return 'Emergency - Life-threatening';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}