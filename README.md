# 🛍️ Loja Virtual Unicesumar

Aplicação Flutter desenvolvida no curso de extensão da Unicesumar, simulando um e-commerce completo com funcionalidades modernas e interface intuitiva.

## 🔗 API Utilizada
**Fake Store API**

## 📱 Screenshots do Projeto

### 🏠 **TELAS PRINCIPAIS DO APP**
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_001.jpg" width="110px" height="210px">
  <img src="/assets/screen_002.jpg" width="110px" height="210px">
  <img src="/assets/screen_003.jpg" width="110px" height="210px">
</div>

### 📦 **MEUS PEDIDOS, MEUS FAVORITOS E PERFIL**
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_004.jpg" width="110px" height="210px">
  <img src="/assets/screen_005.jpg" width="110px" height="210px">
  <img src="/assets/screen_006.jpg" width="110px" height="210px">
</div>

### 💬 **CHATBOT DE ATENDIMENTO**
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_008.jpg" width="110px" height="210px">
  <img src="/assets/screen_009.jpg" width="110px" height="210px">
</div>

---

## 🚀 Funcionalidades Principais

### 🏠 **Home**
- Banner carrossel com promoções
- Categorias de produtos
- Produtos em destaque
- 🔥 **Sistema de recomendações personalizadas**
- 🔍 **Busca inteligente com sugestões**

### 🛒 **Carrinho**
- Adição e remoção de produtos
- Controle de quantidade
- Cálculo automático de valores
- Animação de adição ao carrinho

### ❤️ **Favoritos**
- Lista de produtos favoritos
- Persistência local

### 📦 **Pedidos**
- Histórico de pedidos
- Acompanhamento de status de entrega

### 👤 **Perfil do Usuário**
- Cadastro e login
- Edição de perfil
- Gerenciamento de dados pessoais

### 💬 **Chatbot de Atendimento**
- Assistente virtual integrado para suporte
- Respostas rápidas e automáticas sobre entrega, pedidos, pagamentos e mais
- Simulação de atendimento humanizado

### 🎨 **Tema**
- Modo claro e escuro
- Personalização de cores
- Persistência das preferências

## ✨ Novas Funcionalidades Implementadas

### 🤖 **Sistema de Recomendações Inteligente**
- Baseado no histórico de compras e produtos similares

### 🔍 **Busca Inteligente**
- Sugestões automáticas e filtro em tempo real

### 💬 **Chatbot de Suporte — ✅ IMPLEMENTADO**
- Atende perguntas frequentes e auxilia o usuário na navegação pelo app

### 🎨 **Melhorias Visuais**
- Cards com gradientes
- Feedback visual aprimorado
- Navegação fluida

## 🛠️ Tecnologias Utilizadas
- **Flutter** — Framework principal
- **GetX** — Gerenciamento de estado e navegação
- **GetStorage** — Persistência local
- **HTTP** — Consumo de APIs
- **SQFlite** — Banco de dados local
- **CachedNetworkImage** — Cache de imagens
- **Shimmer** — Efeitos de carregamento
- **Intl** — Internacionalização

## 📁 Estrutura do Projeto
```
lib/
├── bindings/          # Injeção de dependências
├── controllers/       # Gerenciamento de estado (GetX)
├── models/            # Modelos de dados
├── repository/        # Camada de acesso a dados
├── services/          # Regras de negócio e APIs
├── views/             # Telas da aplicação
├── widgets/           # Componentes reutilizáveis
└── main.dart          # Ponto de entrada do app
```

## 🏗️ Arquitetura
- **Clean Architecture**
- Separação clara de responsabilidades
- Injeção de dependências
- Padrão Repository
- Estado gerenciado de forma reativa com GetX

## 🚀 Como Executar o Projeto

**Clone o repositório:**
```bash
git clone [URL-do-repositório]
cd loja_virtual_unicesumar
```

**Instale as dependências:**
```bash
flutter pub get
```

**Execute o projeto:**
```bash
flutter run
```

## 🧠 Funcionalidades Futuras (Planejadas)

### 🔔 **Sistema de Notificações**
- Push notifications
- Alertas de promoções e status dos pedidos

### 🎫 **Sistema de Cupons**
- Descontos exclusivos e programa de fidelidade

### 📍 **Localização e Entrega**
- Rastreamento em tempo real
- Mapa de entrega e pontos de retirada

### ⭐ **Sistema de Avaliações**
- Comentários, avaliações e fotos dos clientes

### 🔄 **Comparador de Produtos**
- Comparação lado a lado com especificações técnicas

## 🤝 Como Contribuir
1. Faça um fork do projeto
2. Crie uma branch:
   ```bash
   git checkout -b feature/SuaFeature
   ```
3. Commit suas alterações:
   ```bash
   git commit -m 'Adiciona sua nova feature'
   ```
4. Envie para o repositório remoto:
   ```bash
   git push origin feature/SuaFeature
   ```
5. Abra um Pull Request

## 📜 Licença
Este projeto está sob a licença MIT. Consulte o arquivo LICENSE para mais informações.

## 👨‍💻 Desenvolvedores
- **Gabriel Ozório**
- **Felipe Luz**
- **Jhonathan de Lima**
- **Vinicius Cerqueira**

**Professor/Orientador:** Rivaldo Roberto da Silva  
Engenharia de Software — Unicesumar  
Analista de Sistemas Sênior | Flutter | Java | APIs REST

---

⭐ **Se este projeto te ajudou, deixe uma estrela no repositório!**
