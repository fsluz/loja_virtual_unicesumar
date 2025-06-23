import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/models.dart';

class ChatService extends GetxService {
  static const String baseUrl = 'https://api.exemplo.com/chat'; // Substitua pela sua API
  static const String wsUrl = 'wss://api.exemplo.com/chat/ws'; // WebSocket URL
  
  StreamController<List<ChatMessage>>? _messageStream;
  StreamController<ChatSession>? _sessionStream;
  StreamSubscription? _wsSubscription;
  
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final Rx<ChatSession?> currentSession = Rx<ChatSession?>(null);
  final RxBool isConnected = false.obs;
  final RxBool isLoading = false.obs;

  // FAQ Data
  final RxList<FAQItem> faqItems = <FAQItem>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadFAQData();
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    _messageStream?.close();
    _sessionStream?.close();
    super.onClose();
  }

  // Carregar dados do FAQ
  Future<void> _loadFAQData() async {
    try {
      // Em produção, isso viria da API
      faqItems.value = [
        FAQItem(
          id: '1',
          question: 'Como rastrear meu pedido?',
          answer: 'Você pode rastrear seu pedido na seção "Meus Pedidos" ou usando o código de rastreamento enviado por email.',
          category: 'orders',
          keywords: ['rastreamento', 'pedido', 'entrega', 'tracking'],
          priority: 1,
        ),
        FAQItem(
          id: '2',
          question: 'Como solicitar reembolso?',
          answer: 'Para solicitar reembolso, acesse "Meus Pedidos", selecione o pedido e clique em "Solicitar Reembolso".',
          category: 'billing',
          keywords: ['reembolso', 'devolução', 'dinheiro', 'cancelamento'],
          priority: 2,
        ),
        FAQItem(
          id: '3',
          question: 'Quais são as formas de pagamento?',
          answer: 'Aceitamos cartão de crédito, PIX, boleto bancário e pagamento na entrega.',
          category: 'payment',
          keywords: ['pagamento', 'cartão', 'pix', 'boleto', 'dinheiro'],
          priority: 1,
        ),
        FAQItem(
          id: '4',
          question: 'Qual o prazo de entrega?',
          answer: 'O prazo de entrega varia de 1 a 7 dias úteis, dependendo da sua localização.',
          category: 'delivery',
          keywords: ['entrega', 'prazo', 'tempo', 'frete'],
          priority: 1,
        ),
      ];
    } catch (e) {
      print('Erro ao carregar FAQ: $e');
    }
  }

  // Buscar FAQ por query
  List<FAQItem> searchFAQ(String query) {
    if (query.isEmpty) return [];
    
    return faqItems
        .where((faq) => faq.matchesQuery(query))
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  // Criar nova sessão de chat
  Future<ChatSession?> createChatSession({
    required String userId,
    required String userName,
    String? subject,
    String? category,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await http.post(
        Uri.parse('$baseUrl/sessions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'userName': userName,
          'subject': subject,
          'category': category,
        }),
      );

      if (response.statusCode == 201) {
        final session = ChatSession.fromJson(jsonDecode(response.body));
        currentSession.value = session;
        _connectWebSocket(session.id);
        return session;
      }
    } catch (e) {
      print('Erro ao criar sessão: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  // Conectar WebSocket
  void _connectWebSocket(String sessionId) {
    try {
      // Em produção, use uma biblioteca WebSocket real
      // Por enquanto, simularemos com Timer
      isConnected.value = true;
      
      Timer.periodic(const Duration(seconds: 2), (timer) {
        if (!isConnected.value) {
          timer.cancel();
          return;
        }
        
        // Simular mensagens do agente
        if (messages.isNotEmpty && messages.last.senderType == 'user') {
          _simulateAgentResponse();
        }
      });
    } catch (e) {
      print('Erro ao conectar WebSocket: $e');
      isConnected.value = false;
    }
  }

  // Simular resposta do agente (para demo)
  void _simulateAgentResponse() {
    final responses = [
      'Entendo sua dúvida. Vou verificar isso para você.',
      'Obrigado pelo contato! Em breve um agente irá atendê-lo.',
      'Estou analisando sua solicitação. Aguarde um momento.',
      'Posso ajudar você com isso. Deixe-me verificar as informações.',
    ];
    
    final randomResponse = responses[DateTime.now().millisecond % responses.length];
    
    final agentMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: currentSession.value!.id,
      senderId: 'agent_001',
      senderName: 'Atendente',
      senderType: 'agent',
      message: randomResponse,
      timestamp: DateTime.now(),
    );
    
    messages.add(agentMessage);
  }

  // Enviar mensagem
  Future<bool> sendMessage(String message, {String? imageUrl}) async {
    if (currentSession.value == null) return false;
    
    try {
      final chatMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sessionId: currentSession.value!.id,
        senderId: 'user_001', // Em produção, pegar do AuthController
        senderName: 'Você',
        senderType: 'user',
        message: message,
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      );

      // Adicionar mensagem localmente
      messages.add(chatMessage);

      // Enviar para servidor
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(chatMessage.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
      return false;
    }
  }

  // Carregar histórico de mensagens
  Future<void> loadMessageHistory(String sessionId) async {
    try {
      isLoading.value = true;
      
      final response = await http.get(
        Uri.parse('$baseUrl/sessions/$sessionId/messages'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        messages.value = data.map((json) => ChatMessage.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao carregar histórico: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Carregar sessões do usuário
  Future<List<ChatSession>> loadUserSessions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/sessions'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ChatSession.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao carregar sessões: $e');
    }
    return [];
  }

  // Fechar sessão
  Future<bool> closeSession(String sessionId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/sessions/$sessionId/close'),
      );

      if (response.statusCode == 200) {
        isConnected.value = false;
        currentSession.value = null;
        messages.clear();
        return true;
      }
    } catch (e) {
      print('Erro ao fechar sessão: $e');
    }
    return false;
  }

  // Marcar mensagens como lidas
  Future<void> markMessagesAsRead(String sessionId) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/sessions/$sessionId/read'),
      );
    } catch (e) {
      print('Erro ao marcar como lido: $e');
    }
  }

  // Stream de mensagens
  Stream<List<ChatMessage>> get messageStream {
    _messageStream ??= StreamController<List<ChatMessage>>.broadcast();
    return _messageStream!.stream;
  }

  // Stream de sessão
  Stream<ChatSession> get sessionStream {
    _sessionStream ??= StreamController<ChatSession>.broadcast();
    return _sessionStream!.stream;
  }
} 