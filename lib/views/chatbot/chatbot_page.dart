import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chatbot_controller.dart';
import '../../models/chat_message_model.dart';
import '../../services/chatbot_service.dart';

class ChatbotPage extends StatelessWidget {
  ChatbotPage({super.key});

  final ChatbotController controller = Get.put(ChatbotController());
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adiciona um listener para rolar para o final sempre que uma mensagem nova chegar
    controller.messages.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: Colors.white),
            SizedBox(width: 8),
            Text('Atendimento Virtual'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.clearChat(),
            tooltip: 'Reiniciar Conversa',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                return _MessageBubble(message: message);
              },
            )),
          ),
          Obx(() => controller.isTyping.value ? _TypingIndicator() : const SizedBox.shrink()),
          Obx(() => _buildOptionButtons(controller.currentMenuKey.value)),
          _buildMessageInputField(context),
        ],
      ),
    );
  }

  Widget _buildOptionButtons(String menuKey) {
    final node = ChatbotService.getNode(menuKey);
    final bool isMenu = node['type'] == 'menu';

    if (!isMenu || controller.isHumanMode.value) {
      return const SizedBox.shrink();
    }

    final options = node['options'] as List<dynamic>;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: options.map((option) {
          return ElevatedButton(
            onPressed: () => controller.handleUserMessage(option['label']),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(fontSize: 13),
            ),
            child: Text(option['label']),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Digite uma opção ou mensagem...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      controller.handleUserMessage(message);
      messageController.clear();
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.support_agent, color: Colors.white, size: 20),
            ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? Theme.of(context).primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 18),
                ),
              ),
              child: Text(
                message.message,
                style: TextStyle(color: isUser ? Colors.white : Colors.black87),
              ),
            ),
          ),
          if (isUser)
            const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.support_agent, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text("Digitando...", style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
} 