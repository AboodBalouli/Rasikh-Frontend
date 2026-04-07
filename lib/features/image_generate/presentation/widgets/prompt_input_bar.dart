import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

/// Input bar for typing prompts.
class PromptInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isLoading;

  const PromptInputBar({
    super.key,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<PromptInputBar> createState() => _PromptInputBarState();
}

class _PromptInputBarState extends State<PromptInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  // Colors matching the home page button
  static const Color primaryBlue = Color.fromARGB(255, 84, 111, 139);
  static const Color accentBlue = Color.fromARGB(255, 86, 166, 212);
  static const Color lightBlue = Color.fromARGB(255, 111, 154, 192);

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(4),
        vertical: context.hp(1),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: lightBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: lightBlue.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !widget.isLoading,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(fontSize: context.sp(15)),
                  decoration: InputDecoration(
                    hintText: 'صف ما تريد رسمه...',
                    hintStyle: GoogleFonts.cairo(
                      fontSize: context.sp(14),
                      color: primaryBlue.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.wp(4),
                      vertical: context.hp(1.5),
                    ),
                  ),
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            SizedBox(width: context.wp(2)),
            // Send button
            GestureDetector(
              onTap: widget.isLoading ? null : _handleSend,
              child: Container(
                padding: EdgeInsets.all(context.wp(3)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.isLoading
                        ? [Colors.grey[400]!, Colors.grey[500]!]
                        : [accentBlue, primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: widget.isLoading
                      ? null
                      : [
                          BoxShadow(
                            color: accentBlue.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: context.sp(20),
                        height: context.sp(20),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: context.sp(22),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
