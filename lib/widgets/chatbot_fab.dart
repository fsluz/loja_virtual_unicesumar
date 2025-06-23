import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/chatbot/chatbot_page.dart';

class ChatbotFAB extends StatelessWidget {
  const ChatbotFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.to(() => ChatbotPage());
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipOval(
        child: Image.asset(
          'assets/chatbot_icon.png',
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      tooltip: 'Assistente Virtual',
    );
  }
} 