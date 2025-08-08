# 💰 Gestor Financeiro - Personal Money Manager

Uma aplicação mobile desenvolvida em Flutter para gerenciamento de gastos pessoais, criada como projeto final da matéria Dispositivos Móveis.

## 📱 Sobre o Projeto

O **Gestor Financeiro** é uma aplicação completa para controle de gastos pessoais que permite aos usuários registrar, visualizar, editar e analisar suas despesas de forma simples e intuitiva. A aplicação oferece recursos como persistência local de dados, visualização em gráficos e interface moderna usando Material Design 3.

## ✨ Funcionalidades

### 🏠 Tela Principal (Home)
- **Listagem de gastos**: Visualização de todas as despesas ordenadas por data (mais recentes primeiro)
- **Edição rápida**: Toque no item para editar título, valor e categoria
- **Exclusão confirmada**: Toque longo no item com confirmação de exclusão
- **Interface intuitiva**: Design limpo com informações organizadas

### ➕ Adicionar Gastos
- **Formulário validado**: Campos obrigatórios com validação automática
- **Categorização**: Organização por categorias personalizadas
- **Data automática**: Registro automático da data/hora da criação
- **Valores em Real (BRL)**: Formatação específica para moeda brasileira

### 📊 Gráficos e Análises
- **Gráfico de pizza interativo**: Visualização proporcional por categoria
- **Percentuais precisos**: Cálculo automático de porcentagens
- **Legendas coloridas**: Identificação visual clara das categorias
- **Atualização em tempo real**: Dados sempre atualizados

### 🗄️ Persistência de Dados
- **Banco local SQLite**: Armazenamento seguro e eficiente
- **CRUD completo**: Criação, leitura, atualização e exclusão
- **Singleton pattern**: Gerenciamento otimizado de conexão

## 🛠️ Tecnologias Utilizadas

### Framework e Linguagem
- **Flutter**: Framework multiplataforma do Google
- **Dart**: Linguagem de programação principal
- **Material Design 3**: Sistema de design moderno

### Dependências Principais
```yaml
dependencies:
  flutter: 
    sdk: flutter
  sqflite: ^2.3.2          # Banco de dados local SQLite
  fl_chart: ^0.68.0        # Gráficos interativos
  path_provider: ^2.1.2    # Acesso aos diretórios do sistema
  path: ^1.9.0             # Manipulação de caminhos de arquivos
```

### Arquitetura
- **MVC Pattern**: Separação clara entre Model, View e Controller
- **Repository Pattern**: Abstração do acesso aos dados
- **Singleton Pattern**: Instância única do serviço de banco

## 🏗️ Estrutura do Projeto

```
gestorfinanceiro/
├── lib/
│   ├── controllers/
│   │   └── expense_controller.dart      # Controlador de gastos
│   ├── models/
│   │   └── expense.dart                 # Modelo de dados
│   ├── services/
│   │   └── db_service.dart              # Serviço de banco de dados
│   ├── views/
│   │   ├── screens/
│   │   │   ├── home_screen.dart         # Tela principal
│   │   │   ├── add_expense_screen.dart  # Tela de adicionar gasto
│   │   │   └── grafics_expense_screen.dart # Tela de gráficos
│   │   └── widgets/
│   │       └── expense_tile.dart        # Componente de item de gasto
│   └── main.dart                        # Ponto de entrada da aplicação
├── android/                             # Configurações Android
├── ios/                                 # Configurações iOS
├── web/                                 # Configurações Web
├── windows/                             # Configurações Windows
├── macos/                              # Configurações macOS
├── linux/                              # Configurações Linux
└── pubspec.yaml                        # Dependências e configurações
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK instalado (>=3.4.0)
- Android Studio ou VS Code com extensões Flutter
- Emulador Android/iOS ou dispositivo físico

### Passos para execução

1. **Clone o repositório**
```bash
git clone https://github.com/SamIamarino/Projeto-Final-Disp-Moveis.git
cd Projeto-Final-Disp-Moveis/gestorfinanceiro
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute a aplicação**
```bash
flutter run
```

### Comandos úteis

```bash
# Verificar configuração do Flutter
flutter doctor

# Limpar cache e rebuildar
flutter clean
flutter pub get

# Executar em dispositivo específico
flutter devices
flutter run -d <device_id>

# Build para produção
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 📊 Funcionalidades Detalhadas

### Modelo de Dados
```dart
class Expense {
  int? id;                 // ID único (auto-increment)
  final String title;      // Nome/descrição do gasto
  final double amount;     // Valor em BRL
  final String category;   // Categoria do gasto
  final DateTime date;     // Data de criação
}
```

### Operações do Banco
- **CREATE**: Inserção de novos gastos
- **READ**: Busca de todos os gastos ordenados
- **UPDATE**: Atualização de gastos existentes
- **DELETE**: Remoção de gastos

### Interface do Usuário
- **Tema**: Material Design 3 com tema teal
- **Navegação**: Stack-based navigation
- **Responsividade**: Adaptável a diferentes tamanhos de tela
- **Feedback**: Confirmações e validações visuais

## 🎨 Design e UX

### Paleta de Cores
- **Primária**: Teal (verde-azulado)
- **Secundária**: Light Green
- **Gráficos**: Paleta diversificada com 10 cores

### Componentes
- **FloatingActionButton**: Ações principais (adicionar/gráficos)
- **ListTile**: Exibição de gastos com informações organizadas
- **AlertDialog**: Confirmações e formulários de edição
- **PieChart**: Visualização gráfica interativa

## 📱 Compatibilidade

### Plataformas Suportadas
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11.0+)
- ✅ **Web** (Progressive Web App)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🔧 Configuração de Desenvolvimento

### VS Code (Recomendado)
```json
{
  "dart.debugExternalPackageLibraries": true,
  "dart.debugSdkLibraries": true,
  "dart.flutterSdkPath": "/caminho/para/flutter",
  "dart.flutterHotReloadOnSave": "always"
}
```

### Android Studio
1. Instalar plugins Flutter e Dart
2. Configurar SDK paths
3. Criar AVD (Android Virtual Device)

## 📈 Melhorias Futuras

### Funcionalidades Planejadas
- [ ] **Autenticação de usuário**
- [ ] **Sincronização na nuvem**
- [ ] **Relatórios mensais/anuais**
- [ ] **Metas de gastos**
- [ ] **Notificações push**
- [ ] **Exportação de dados (PDF/Excel)**
- [ ] **Modo escuro**
- [ ] **Múltiplas moedas**
- [ ] **Backup automático**

### Otimizações Técnicas
- [ ] **Implementar testes unitários**
- [ ] **Adicionar testes de integração**
- [ ] **Otimizar performance de gráficos**
- [ ] **Implementar paginação na lista**
- [ ] **Adicionar cache inteligente**

## 🤝 Contribuição

### Como contribuir
1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Padrões de Código
- Seguir as convenções do Dart/Flutter
- Documentar funções complexas
- Manter consistência na nomenclatura
- Usar widgets construtores quando possível


<div align="center">

**Desenvolvido com ❤️ usando Flutter**

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)

</div>
