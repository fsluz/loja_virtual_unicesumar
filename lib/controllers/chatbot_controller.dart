import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../models/chat_message_model.dart';
import '../services/chatbot_service.dart';

class ChatbotController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool isHumanMode = false.obs;
  final RxString currentMenuKey = 'root'.obs;
  Timer? _inactivityTimer;

  @override
  void onInit() {
    super.onInit();
    _showWelcomeMessage();
  }

  @override
  void onClose() {
    _inactivityTimer?.cancel();
    super.onClose();
  }

  void _showWelcomeMessage() {
    final welcomeMessage = ChatbotService.getWelcomeMessage();
    _addBotMessage(welcomeMessage);
    _processBotResponse(currentMenuKey.value, isInitial: true);
  }

  void handleUserMessage(String text) {
    if (text.trim().isEmpty) return;
    _resetInactivityTimer();

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: text.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    if (isHumanMode.value) {
      // Se estiver em modo humano, só sai se o usuário digitar 'menu' ou 'voltar'
      final keywordNode = ChatbotService.processKeyword(text);
      if (keywordNode == 'root') {
        isHumanMode.value = false;
        currentMenuKey.value = 'root';
        _processBotResponse(currentMenuKey.value);
      } else {
        _addBotMessage('⚠️ Lembrete: A função de atendimento humano é uma simulação. Digite "menu" ou "voltar" para retornar ao atendimento automático.');
      }
      return;
    }
    
    // Verifica atalhos por palavra-chave
    final keywordNode = ChatbotService.processKeyword(text);
    if (keywordNode != null) {
      currentMenuKey.value = keywordNode;
      _processBotResponse(currentMenuKey.value);
      return;
    }
    
    // Processa a opção do menu atual
    final nextNodeKey = ChatbotService.processUserInput(text, currentMenuKey.value);
    currentMenuKey.value = nextNodeKey;
    _processBotResponse(currentMenuKey.value);
  }

  Future<void> _processBotResponse(String nodeKey, {bool isInitial = false}) async {
    isTyping.value = true;
    await Future.delayed(Duration(milliseconds: isInitial ? 1200 : 600));
    
    final node = ChatbotService.getNode(nodeKey);
    String message = ChatbotService.getMenuMessage(nodeKey);
    
    if (node['type'] == 'human_transfer') {
        final protocol = 10000 + Random().nextInt(90000);
        message = message.replaceFirst('{protocol}', protocol.toString());
        isHumanMode.value = true;
    }

    isTyping.value = false;
    _addBotMessage(message);
  }

  void _addBotMessage(String message) {
    final botMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );
    messages.add(botMessage);
  }

  void clearChat() {
    _inactivityTimer?.cancel();
    messages.clear();
    currentMenuKey.value = 'root';
    isHumanMode.value = false;
    _showWelcomeMessage();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 2), _handleInactivity);
  }

  void _handleInactivity() {
    _addBotMessage("Posso te ajudar em mais alguma coisa? Se quiser, digite 'SAC' para falar com um atendente.");
  }
} 