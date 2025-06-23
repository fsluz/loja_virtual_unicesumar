import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/models.dart';
import '../models/chat_message_model.dart';

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
  
  // Respostas padrão do chatbot
  static const Map<String, List<String>> _responses = {
    'saudacao': [
      'Olá! Como posso ajudá-lo hoje? 😊',
      'Oi! Estou aqui para ajudar com suas dúvidas sobre produtos e pedidos!',
      'Olá! Bem-vindo à nossa loja virtual. Como posso ser útil?',
    ],
    'produtos': [
      'Temos uma grande variedade de produtos! Você pode navegar pelas categorias na página inicial ou usar a busca para encontrar algo específico.',
      'Nossos produtos são organizados por categorias. Que tipo de produto você está procurando?',
      'Posso ajudar você a encontrar produtos específicos. O que você está procurando?',
    ],
    'pedidos': [
      'Para acompanhar seus pedidos, acesse a seção "Meus Pedidos" no seu perfil. Lá você verá o status de todas as suas compras.',
      'Seus pedidos ficam salvos na sua conta. Você pode ver o histórico completo na área do usuário.',
      'Para ver seus pedidos, vá em "Perfil" > "Meus Pedidos". Lá você encontra todos os detalhes.',
    ],
    'entrega': [
      'Nossas entregas são feitas em até 3 dias úteis para todo o Brasil!',
      'O prazo de entrega varia de 1 a 5 dias úteis, dependendo da sua localização.',
      'Fazemos entregas para todo o país. O prazo médio é de 3 dias úteis.',
    ],
    'pagamento': [
      'Aceitamos cartões de crédito, PIX, boleto bancário e transferência.',
      'Você pode pagar com cartão, PIX ou boleto. Todos os pagamentos são seguros!',
      'Temos várias formas de pagamento: cartão, PIX, boleto e transferência.',
    ],
    'devolucao': [
      'Você tem 7 dias para solicitar a devolução de produtos não utilizados.',
      'Nossa política de devolução permite trocas e devoluções em até 7 dias.',
      'Para devoluções, entre em contato conosco em até 7 dias após a compra.',
    ],
    'desconto': [
      'Temos promoções especiais! Fique de olho nas ofertas da semana.',
      'Você pode ganhar descontos especiais cadastrando-se em nossa newsletter.',
      'Siga nossas redes sociais para ficar por dentro das melhores ofertas!',
    ],
    'ajuda': [
      'Estou aqui para ajudar! Você pode perguntar sobre produtos, pedidos, pagamentos ou qualquer outra dúvida.',
      'Como posso ajudá-lo? Posso esclarecer dúvidas sobre produtos, compras, entregas e muito mais!',
      'Fique à vontade para perguntar! Estou aqui para facilitar sua experiência de compra.',
    ],
    'despedida': [
      'Obrigado por conversar comigo! Se precisar de mais alguma coisa, estarei aqui! 😊',
      'Foi um prazer ajudá-lo! Volte sempre que precisar de assistência.',
      'Até logo! Espero ter ajudado. Tenha um ótimo dia! 👋',
    ],
  };

  // Palavras-chave para identificar intenções
  static const Map<String, List<String>> _keywords = {
    'saudacao': ['oi', 'olá', 'ola', 'hello', 'hi', 'bom dia', 'boa tarde', 'boa noite'],
    'produtos': ['produto', 'produtos', 'item', 'itens', 'mercadoria', 'mercadorias', 'comprar', 'encontrar'],
    'pedidos': ['pedido', 'pedidos', 'compra', 'compras', 'histórico', 'historico', 'status', 'rastreamento'],
    'entrega': ['entrega', 'entregar', 'frete', 'envio', 'prazo', 'quando chega', 'tempo'],
    'pagamento': ['pagamento', 'pagar', 'cartão', 'cartao', 'pix', 'boleto', 'dinheiro', 'forma de pagamento'],
    'devolucao': ['devolução', 'devolucao', 'troca', 'trocar', 'devolver', 'reembolso'],
    'desconto': ['desconto', 'promoção', 'promocao', 'oferta', 'preço', 'preco', 'barato', 'economia'],
    'ajuda': ['ajuda', 'ajudar', 'dúvida', 'duvida', 'pergunta', 'como', 'o que', 'quando', 'onde'],
    'despedida': ['tchau', 'adeus', 'até logo', 'ate logo', 'obrigado', 'obrigada', 'valeu', 'bye'],
  };

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

  // Gerar resposta baseada na mensagem do usuário
  static String generateResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Identificar a intenção baseada nas palavras-chave
    String intent = _identifyIntent(message);
    
    // Se não conseguiu identificar, retorna resposta genérica
    if (!_responses.containsKey(intent)) {
      intent = 'ajuda';
    }
    
    // Selecionar resposta aleatória da categoria
    final responses = _responses[intent]!;
    final randomIndex = DateTime.now().millisecondsSinceEpoch % responses.length;
    
    return responses[randomIndex];
  }

  // Identificar a intenção da mensagem
  static String _identifyIntent(String message) {
    for (final entry in _keywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return 'ajuda';
  }

  // Simular delay de resposta (para parecer mais natural)
  static Future<void> simulateTyping() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Mensagem de boas-vindas inicial
  static String getWelcomeMessage() {
    return 'Olá! Sou o assistente virtual da loja. Como posso ajudá-lo hoje? 😊';
  }

  // Verificar se a mensagem é uma saudação inicial
  static bool isInitialGreeting(String message) {
    final greetings = ['oi', 'olá', 'ola', 'hello', 'hi', 'bom dia', 'boa tarde', 'boa noite'];
    return greetings.any((greeting) => message.toLowerCase().contains(greeting));
  }
} 