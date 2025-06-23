# Flutter e API

Esse é um projeto do curso de extensão da UNICESUMAR.

Nesso projeto estamos usando a FAKESTOREAPI : https://fakestoreapi.com/products

## Getting Started

## TELAS PRINCIPAIS DO APP
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_001.jpg" width="110px" height="210px">
  <img src="/assets/screen_002.jpg" width="110px" height="210px">
  <img src="/assets/screen_003.jpg" width="110px" height="210px">
</div>


## MEUS PEDIDOS, MEUS FAVORITOS E PERFIL
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_004.jpg" width="110px" height="210px">
  <img src="/assets/screen_005.jpg" width="110px" height="210px">
  <img src="/assets/screen_006.jpg" width="110px" height="210px">
</div>

## CHATBOT DE ATENDIMENTO
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_008.jpg" width="110px" height="210px">
  <img src="/assets/screen_009.jpg" width="110px" height="210px">
</div>


<hr/>

# 🛍️ Loja Virtual Unicesumar

Uma aplicação Flutter completa de e-commerce com funcionalidades modernas e interface intuitiva.

## ✨ Funcionalidades Principais

### 🏠 **Home**
- Banner carrossel com promoções
- Categorias de produtos
- Produtos em destaque
- **NOVO**: Sistema de recomendações personalizadas
- **NOVO**: Busca inteligente com sugestões

### 🛒 **Carrinho**
- Adição/remoção de produtos
- Controle de quantidade
- Cálculo automático de valores
- Animação de adição ao carrinho

### ❤️ **Favoritos**
- Lista de produtos favoritos
- Adição/remoção de favoritos
- Persistência local

### 📦 **Pedidos**
- Histórico de pedidos
- Status de entrega
- Detalhes do pedido

### 👤 **Perfil do Usuário**
- Cadastro e login
- Edição de perfil
- Gerenciamento de dados pessoais

### 🎨 **Tema**
- Modo claro/escuro
- Personalização de cores
- Persistência das preferências

## 🚀 **Novas Funcionalidades Implementadas**

### 🤖 **Sistema de Recomendações Inteligente**
- Recomendações baseadas no histórico de compras
- Análise de tendências
- Produtos similares
- Score de relevância
- Interface dedicada para recomendações

### 🔍 **Busca Inteligente**
- Sugestões automáticas
- Filtro em tempo real
- Histórico de buscas
- Interface moderna e responsiva

### 📱 **Melhorias na Interface**
- Cards de recomendação com gradientes
- Indicadores visuais de relevância
- Navegação fluida entre seções
- Feedback visual aprimorado

## 🛠️ **Tecnologias Utilizadas**

- **Flutter** - Framework de desenvolvimento
- **GetX** - Gerenciamento de estado e navegação
- **GetStorage** - Persistência local
- **HTTP** - Comunicação com APIs
- **SQFlite** - Banco de dados local
- **Cached Network Image** - Cache de imagens
- **Shimmer** - Efeitos de loading
- **Intl** - Internacionalização

## 📁 **Estrutura do Projeto**

```
lib/
├── bindings/          # Injeção de dependências
├── controllers/       # Controladores GetX
├── models/           # Modelos de dados
├── repository/       # Camada de acesso a dados
├── services/         # Serviços de negócio
├── views/            # Telas da aplicação
├── widgets/          # Widgets reutilizáveis
└── main.dart         # Ponto de entrada
```

## 🎯 **Arquitetura**

O projeto segue os princípios da **Clean Architecture** com:

- **Separação de responsabilidades**
- **Injeção de dependências**
- **Padrão Repository**
- **Gerenciamento de estado reativo**

## 🚀 **Como Executar**

1. **Clone o repositório**
   ```bash
   git clone [url-do-repositorio]
   cd loja_virtual_unicesumar
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o projeto**
   ```bash
   flutter run
   ```

## 📱 **Funcionalidades Futuras Planejadas**

### 🔔 **Sistema de Notificações**
- Notificações push
- Alertas de promoções
- Status de pedidos em tempo real

### 💬 **Chat de Suporte**
- Chat em tempo real
- FAQ interativo
- Suporte por chatbot - **IMPLEMENTADO**

### 🎫 **Sistema de Cupons**
- Cupons de desconto
- Promoções por categoria
- Programa de fidelidade

### 📍 **Localização e Entrega**
- Rastreamento em tempo real
- Mapa de entrega
- Pontos de retirada

### ⭐ **Sistema de Avaliações**
- Avaliação por estrelas
- Comentários detalhados
- Fotos dos clientes

### 🔄 **Comparador de Produtos**
- Comparação lado a lado
- Tabela de especificações
- Recomendações baseadas na comparação

## 🤝 **Contribuição**

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 **Licença**

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 **Desenvolvido por**

**Equipe de Desenvolvimento:**
- Gabriel Ozório
- Felipe Luz
- Jhonathan de Lima
- Vinicius Cerqueira

**Professor/Orientador:**
Rivaldo Roberto da Silva
Engenharia de Software - Unicesumar
Analista de Sistemas Sênior | Flutter | Java | APIs REST

---

⭐ **Se este projeto te ajudou, considere dar uma estrela!**

