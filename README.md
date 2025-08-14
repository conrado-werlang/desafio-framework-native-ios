# Desafio Framework Native – App de Notícias

Aplicativo iOS desenvolvido como desafio técnico, consumindo o feed de notícias do G1.
O app exibe uma lista paginada de notícias com detalhes como título, resumo, imagem e metadados.

-----------------------------------

## Funcionalidades

- Listagem de notícias com título, resumo, imagem e metadados.
- Paginação automática ao chegar próximo ao fim da lista.
- Cache das notícias, incluindo imagens para otimizar carregamento.
- Ajuste de layout inspirado no visual do G1.
- Suporte a acessibilidade com labels para VoiceOver em cada notícia.
- Tratamento de estados (loading, loaded, error) no ViewModel.

-----------------------------------

## Arquitetura

O projeto segue uma abordagem baseada em **MVVM**, com separação clara entre camadas:

- Models – Estruturas para representar os dados vindos da API.
- ViewModels – Contêm a lógica de negócio e controle de estados da view.
- Views – Criadas em SwiftUI, responsáveis pela renderização.
- Services – Responsáveis por requisições de rede e tratamento de dados.
- Cache – Implementação simples para armazenar imagens e dados do feed.

-----------------------------------

## Tecnologias e Ferramentas

- Swift 5.10
- SwiftUI para interface declarativa
- Async/Await para chamadas assíncronas
- URLSession para consumo da API
- XCTest para testes unitários
- Proxyman para inspeção de requisições durante o desenvolvimento

-----------------------------------

## Estrutura de Pastas

- DesafioFrameworkNative
    - App
    - Comments
    - Components
    - Core
        - Models
        - Network
        - Utils
    - Features
        - Menu
            - Services
            - ViewModel
            - Views
        - NewsFeed
            - Services
            - ViewModel
            - Views
    - Resources
        
- DesafioFrameworkNativeTests

-----------------------------------

## Como Rodar o app

1. Clone o repositório: git clone https://github.com/seu-repo/desafio-framework-native.git
2. Abra o projeto no Xcode 15+.
3. Selecione o simulador ou dispositivo.
4. Compile e execute (Command + R).

-----------------------------------

## Testes

- Cobertura de testes inclui:
  - Carregamento da primeira página
  - Paginação com remoção de notícias duplicadas
  - Parada do carregamento quando o nextPage é nulo
- Para rodar:
  Command + U

-----------------------------------

## Melhorias Futuras

- Adicionar efeito Shimmer enquanto as notícias carregam.
- Implementar offline mode com cache persistente ao invés de na memória como está atualmente.
- Expandir suporte a múltiplas tabs além da g1 e agro.
- Melhorar cobertura de testes unitários.
- Criação de testes de UI utilizando XCUITest para validar fluxos principais do aplicativo.
