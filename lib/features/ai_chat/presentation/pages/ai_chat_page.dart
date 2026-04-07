import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/core/utils/responsive.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../providers/ai_chat_providers.dart';

class AiChatPage extends ConsumerWidget {
  const AiChatPage({super.key});

  static final ChatUser _me = ChatUser(id: 'user');
  static final ChatUser _ai = ChatUser(id: 'assistant', firstName: 'AI');

  ChatMessage _toChatMessage(AiChatMessage message) {
    return ChatMessage(
      text: message.content,
      user: message.role == AiChatRole.user ? _me : _ai,
      createdAt: message.createdAt,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiChatControllerProvider);
    final controller = ref.read(aiChatControllerProvider.notifier);

    final messages = state.messages.map(_toChatMessage).toList();

    final theme = Theme.of(context);
    final baseStyle = GoogleFonts.cairo(textStyle: theme.textTheme.bodyMedium);
    final chatTextStyle = baseStyle.copyWith(
      fontSize: context.sp(16),
      height: 1.25,
    );

    final messageOptions = MessageOptions(
      showOtherUsersAvatar: true,
      showCurrentUserAvatar: false,
      avatarBuilder: (user, onPress, onLongPress) {
        if (user.id == _ai.id) {
          return Padding(
            padding: EdgeInsets.only(right: context.wp(2)),
            child: CircleAvatar(
              radius: context.sp(18),
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage(
                'assets/images/google-gemini-icon.png',
              ),
              // Fallback if asset missing or just use an Icon
              child: const SizedBox.shrink(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      messageTextBuilder: (message, previousMessage, nextMessage) {
        final isAssistant = message.user.id == _ai.id;

        if (!isAssistant) {
          return Text(
            message.text,
            style: chatTextStyle.copyWith(color: Colors.white),
          );
        }

        return MarkdownBody(
          data: message.text,
          selectable: true,
          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
            p: chatTextStyle.copyWith(color: theme.colorScheme.onSurface),
            h1: GoogleFonts.cairo(
              fontSize: context.sp(22),
              fontWeight: FontWeight.bold,
            ),
            h2: GoogleFonts.cairo(
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
            ),
            h3: GoogleFonts.cairo(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
            ),
            code: GoogleFonts.robotoMono(fontSize: context.sp(14)),
          ),
        );
      },
      containerColor: const Color(0xFFEFF6FF), // Light blue for AI
      currentUserContainerColor: const Color(0xFF53945D), // Green for user
      currentUserTextColor: Colors.white,
    );

    final inputOptions = InputOptions(
      inputTextStyle: GoogleFonts.cairo(fontSize: context.sp(16)),
      inputDecoration: InputDecoration(
        hintText: 'أكتب رسالتك هنا...',
        hintStyle: GoogleFonts.cairo(
          fontSize: context.sp(14),
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.wp(4),
          vertical: context.hp(1.5),
        ),
      ),
      sendButtonBuilder: (send) {
        return IconButton(
          icon: Icon(
            Icons.send,
            color: const Color(0xFF53945D),
            size: context.sp(24),
          ),
          onPressed: send,
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Image.asset(
          'assets/images/logobg.png',
          height: context.hp(12),
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          DashChat(
            currentUser: _me,
            messages: messages,
            messageOptions: messageOptions,
            inputOptions: inputOptions,
            onSend: (m) => controller.sendUserMessage(m.text),
          ),
          if (messages.isEmpty)
            Center(
              child: Text(
                'يمكنك السؤال عن الذي تريده',
                style: GoogleFonts.cairo(
                  fontSize: context.sp(18),
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
