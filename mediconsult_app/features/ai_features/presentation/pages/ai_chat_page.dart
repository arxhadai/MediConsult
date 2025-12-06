import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/symptom_checker/symptom_checker_bloc.dart';
import '../widgets/chat/chat_bubble.dart';
import '../widgets/chat/ai_typing_indicator.dart';
import '../widgets/chat/chat_input_field.dart';

/// Page for general AI chat
class AiChatPage extends StatefulWidget {
  const AiChatPage({Key? key}) : super(key: key);

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _scrollController = ScrollController();
  final List<Widget> _chatWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Assistant'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: BlocConsumer<SymptomCheckerBloc, SymptomCheckerState>(
        listener: (context, state) {
          if (state is ChatMessageReceived) {
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
                        'Hello! I\'m your medical assistant. How can I help you today?',
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
                isEnabled: !(state is SymptomCheckerLoading),
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