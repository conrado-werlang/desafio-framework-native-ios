# COMMENTS.md

## Histórico e Decisões do Projeto

Este arquivo documenta o raciocínio, as decisões e os ajustes feitos durante o desenvolvimento do desafio, além de ideias que não foram implementadas por falta de tempo.

---

### 1. Escolha de SwiftUI
Optei por SwiftUI como framework de UI, pela rapidez de desenvolvimento e melhor integração com recursos recentes do iOS (a partir da versão 15). Avaliei UIKit, mas descartei para manter o código mais moderno e conciso, apenas precisei fazer um Representable para mostrar a WebView.

### 2. Arquitetura
Escolhi MVVM baseada em protocolos para abstração de serviços e cache. Essa abordagem facilita os testes unitários e mantém o código desacoplado. Considerei usar VIP, mas seria excesso de complexidade para este projeto.

### 3. Organização em Módulos Lógicos
Não utilizei múltiplos frameworks, mas mantive uma separação clara em pastas para facilitar a manutenção e a leitura do código:
- App -> Contém o ponto de entrada DesafioFrameworkNativeApp e a MainTabView.
- Comments -> Arquivo de anotações e decisões do projeto.
- Components -> Componentes reutilizáveis da UI.
- Models -> Estruturas de dados e modelos.
- Network -> Código relacionado a requisições HTTP e comunicação com API.
- Utils -> Utilitários diversos.
- Cache -> Implementação de cache para dados e imagens.
- Features -> Funcionalidades principais do app, separadas por contexto.
- Resources -> Recursos estáticos como assets e JSONs.

### 4. Suporte a dois Feeds
Implementei .g1 e .agro como enum FeedSource, com geração correta das URLs. Ajustei a paginação para seguir a documentação da API: feed/page/g1/{id}/{page}.

### 5. Tratamento de Imagens
Implementei um loader de imagens com cache em memória para evitar downloads repetidos. Não usei bibliotecas externas para manter o desafio 100% nativo.

### 6. Itens sem Imagem
A API às vezes retorna notícias sem imagem. Nesse caso, optei por não renderizar o ImageView para manter o layout limpo e evitar placeholders desnecessários, segui o app do G1 como exemplo.

### 7. Scroll Infinito
A paginação foi implementada chamando loadNextPageIfNeeded ao se aproximar do final da lista. Se uma notícia já está na lista, o app remove a duplicata.

### 8. Pull to Refresh
Implementei o recurso usando refreshable do SwiftUI. O método reload limpa os itens atuais e carrega novamente a primeira página.

### 9. Filtro por Tipo
A API retorna tipos diferentes de conteúdo. Filtrei para aceitar apenas "basico" e "materia", conforme especificado na regra de negócio.

### 10. WebView Interna
Ao tocar em uma notícia ou item de menu, o app abre uma WebView interna carregando a URL. Evita abrir o Safari e mantém a experiência no app. Decidi também não criar uma nova tela para abrir a notícia, mas sim abrir a webView em uma sheet do SwiftUI, deixando assim mais conforme com o padrão da Apple.

### 11. Aba de Menu
Carrega itens do arquivo `menu.json` embarcado. Ao tocar, abre a respectiva URL em WebView, assim como as notícias no feed.

### 12. Cache Persistente
Foi implementado cache simples via protocolo FeedCaching, mas persistência local (Core Data / Disk) ficou para implementação futura. Atualmente o cache é em memória.

### 13. Testes Unitários
Criei testes para:
- Carregamento da primeira página.
- Paginação e remoção de duplicados.
- Interrupção de paginação quando nextPage é nulo.
Não implementei testes de UI devido à limitação de tempo.

### 14. Controle de Estado
O ViewModel mantém estados .loading, .loaded e .error para controle de UI. Assim facilitando mostrar diferentes visuais dependendo do estado.

### 15. Ajustes de UI
Ajustei cores, espaçamentos e fontes para dar mais destaque aos elementos importantes (ex.: `chapeu` e título). A tab bar foi personalizada para ícones pretos quando selecionados e cinza quando não, bem como o app do G1.

### 16. Problemas com URLs
A API retornava problemas de encoding no endpoint do agro. Ajustei para que sempre usasse `product=g1` na paginação, mesmo que a primeira requisição seja por URL completa. Tive alguns problemas no início com o simulador e acabei fazendo os testes no meu dispositivo físico juntamente com o Proxyman para interceptar as requests.

### 17. Decisão de Não Usar Bibliotecas Externas
Para evitar dependências e manter o projeto limpo, todo o carregamento de imagens, cache e networking foi feito com APIs nativas (URLSession e AsyncImage customizados).

### 18. Melhorias Futuras
- Implementar shimmer loading ao carregar notícias.
- Criar modo offline completo com cache persistente.
- Adicionar testes de UI com XCTest e XCUITest.
- Internacionalização (Localizable Strings).
- Animações mais sofisticadas na transição entre telas.

### 19. Organização de Commits
Mantive commits simples e com um propósito para cada feature ou ajuste, facilitando o histórico:
- feat: para novas funcionalidades.
- fix: para correções.
- test: para adição/alteração de testes.
- refactor: para ajustes código.
- docs: para ajustes em documentos.

### 20. Considerações Finais
O projeto atende todas as regras obrigatórias do desafio e parte dos diferenciais (testes unitários e cache simples). Foi priorizado código limpo, desacoplado e fácil de entender, com base em boas práticas do ecossistema do Swift.
