class ChatbotService {
  // Estrutura de árvore de opções completa
  static const Map<String, Map<String, dynamic>> _tree = {
    'root': {
      'message': 'Olá! Sou o assistente virtual da loja. Como posso ajudar?',
      'options': [
        {'label': '1 - Entrega', 'next': 'entrega'},
        {'label': '2 - Prazo', 'next': 'prazo'},
        {'label': '3 - SAC', 'next': 'sac'},
        {'label': '4 - Pagamento', 'next': 'pagamento'},
        {'label': '5 - Devolução', 'next': 'devolucao'},
      ],
      'type': 'menu',
    },
    // Nível 2 - Entrega
    'entrega': {
      'message': 'Sobre entrega, escolha uma opção:',
      'options': [
        {'label': '1.1 - Como acompanhar meu pedido', 'next': 'entrega_track'},
        {'label': '1.2 - Meu pedido está atrasado', 'next': 'entrega_late'},
        {'label': '1.3 - Endereço errado, o que fazer?', 'next': 'entrega_wrong_address'},
        {'label': '9 - Voltar ao menu principal', 'next': 'root'},
      ],
      'type': 'menu',
    },
    'entrega_track': {'message': "Você pode acompanhar seu pedido acessando 'Meus Pedidos' no nosso site ou através do link de rastreio enviado para o seu e-mail.", 'type': 'answer'},
    'entrega_late': {'message': "Lamentamos o ocorrido! Por favor, verifique o status do seu pedido. Se o prazo já foi ultrapassado, acione a opção 'SAC' no menu principal e escolha 'Reclamações > Atraso na entrega' para abrirmos um chamado.", 'type': 'answer'},
    'entrega_wrong_address': {'message': "Se o endereço estiver errado, por favor, vá para 'SAC > Solicitações gerais' e nos informe o quanto antes para tentarmos a correção com a transportadora.", 'type': 'answer'},

    // Nível 2 - Prazo
    'prazo': {
        'message': 'Sobre prazos, escolha:',
        'options': [
          {'label': '2.1 - Qual o prazo para meu CEP?', 'next': 'prazo_cep'},
          {'label': '2.2 - Entrega expressa', 'next': 'prazo_express'},
          {'label': '9 - Voltar ao menu principal', 'next': 'root'},
        ],
        'type': 'menu'
    },
    'prazo_cep': {'message': 'Para saber o prazo exato, por favor, insira o produto no carrinho de compras e informe o seu CEP no campo indicado. O sistema calculará o tempo e o custo da entrega.', 'type': 'answer'},
    'prazo_express': {'message': 'Sim, oferecemos entrega expressa para algumas regiões! A disponibilidade e o custo aparecerão como uma opção de frete ao finalizar sua compra.', 'type': 'answer'},

    // Nível 2 - SAC
    'sac': {
      'message': 'Escolha o motivo do seu atendimento:',
      'options': [
        {'label': '3.1 - Reclamações', 'next': 'sac_reclamacoes'},
        {'label': '3.2 - Solicitações gerais', 'next': 'sac_solicitacoes'},
        {'label': '3.3 - Financeiro', 'next': 'sac_financeiro'},
        {'label': '9 - Voltar ao menu principal', 'next': 'root'},
      ],
      'type': 'menu',
    },
    'sac_reclamacoes': {'message': 'Entendido. Para registrar sua reclamação, estou te direcionando para o nosso setor especializado. Seu número de protocolo é #{protocol}. Por favor, aguarde.', 'type': 'human_transfer', 'department': 'Reclamações'},
    'sac_solicitacoes': {'message': 'Para solicitações gerais, estou te direcionando para um de nossos atendentes. Seu número de protocolo é #{protocol}. Por favor, aguarde.', 'type': 'human_transfer', 'department': 'Atendimento Geral'},
    'sac_financeiro': {'message': 'Para assuntos financeiros, estou te direcionando para o setor responsável. Seu número de protocolo é #{protocol}. Por favor, aguarde.', 'type': 'human_transfer', 'department': 'Financeiro'},

    // Nível 2 - Pagamento
    'pagamento': {
      'message': 'Sobre pagamentos, escolha:',
      'options': [
        {'label': '4.1 - Formas de pagamento', 'next': 'pagamento_forms'},
        {'label': '4.2 - Parcelamento', 'next': 'pagamento_installments'},
        {'label': '4.3 - Pagamento não aprovado', 'next': 'pagamento_failed'},
        {'label': '9 - Voltar ao menu principal', 'next': 'root'},
      ],
      'type': 'menu',
    },
    'pagamento_forms': {'message': 'Aceitamos Cartão de Crédito (Visa, Master, Elo, Amex), Pix e Boleto Bancário.', 'type': 'answer'},
    'pagamento_installments': {'message': r'''Sim, você pode parcelar suas compras em até 12x sem juros no cartão de crédito, com parcela mínima de R$ 30,00.''', 'type': 'answer'},
    'pagamento_failed': {'message': "Sinto muito por isso. Verifique se os dados do cartão foram digitados corretamente e se há limite disponível. Se o problema persistir, recomendamos contatar a operadora do seu cartão ou tentar outra forma de pagamento. Se precisar, acione 'SAC > Financeiro'.", 'type': 'answer'},

    // Nível 2 - Devolução
    'devolucao': {
      'message': 'Sobre devoluções, escolha:',
      'options': [
        {'label': '5.1 - Como solicitar devolução?', 'next': 'devolucao_howto'},
        {'label': '5.2 - Prazo para devolução', 'next': 'devolucao_prazo'},
        {'label': '5.3 - Prazo para reembolso', 'next': 'devolucao_reembolso'},
        {'label': '9 - Voltar ao menu principal', 'next': 'root'},
      ],
      'type': 'menu',
    },
    'devolucao_howto': {'message': "Para solicitar a devolução, acesse sua conta em nosso site, vá em 'Meus Pedidos', localize a compra e clique em 'Solicitar Devolução'. Siga as instruções que aparecerão na tela.", 'type': 'answer'},
    'devolucao_prazo': {'message': 'O prazo para solicitar a devolução de um produto é de até 7 (sete) dias corridos, contados a partir da data de recebimento.', 'type': 'answer'},
    'devolucao_reembolso': {'message': 'Após o recebimento e checagem do produto devolvido em nosso centro de distribuição, o reembolso é processado em até 10 dias úteis.', 'type': 'answer'},
  };

  static String getWelcomeMessage() {
    return 'Olá! Sou o assistente virtual da loja.';
  }

  static Map<String, dynamic> getNode(String key) {
    return _tree[key] ?? _tree['root']!;
  }

  static String getMenuMessage(String key) {
    final node = getNode(key);
    String message = node['message'];

    if (node['type'] == 'menu') {
      final options = node['options'] as List<dynamic>;
      final optionsText = options.map((e) => e['label']).join('\n');
      return '$message\n\n$optionsText';
    }
    
    // Para respostas, adiciona a opção de voltar
    if (node['type'] == 'answer') {
         message += '\n\nDigite 9 para voltar ao menu principal.';
    }

    return message;
  }
  
  static String? processKeyword(String input) {
    final text = input.toLowerCase();
    if (text.contains('sac') || text.contains('atendente') || text.contains('humano')) {
      return 'sac';
    }
    if (text.contains('reclamacao') || text.contains('problema') || text.contains('insatisfacao')) {
      return 'sac_reclamacoes';
    }
    if (text.contains('menu') || text.contains('voltar')) {
      return 'root';
    }
    return null;
  }

  static String processUserInput(String input, String currentMenuKey) {
    final node = getNode(currentMenuKey);
    if (node['type'] != 'menu') {
      // Se não for um menu, qualquer input numérico (como 9) volta pro root
      if (input.trim() == '9') return 'root';
      return currentMenuKey;
    }

    final options = node['options'] as List<dynamic>;
    for (var option in options) {
      final label = option['label'] as String;
      // Compara pelo início do texto (ex: "1", "1.1", "9")
      if (label.trim().startsWith(input.trim())) {
        return option['next'] as String;
      }
    }
    
    return 'root'; // Se a opção for inválida, volta pro início
  }
} 