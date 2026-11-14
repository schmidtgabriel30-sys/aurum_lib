# Aurum Automotive — App

Aplicativo Flutter para **agendar serviços de oficina**: o cliente cadastra seus veículos e solicita, reagenda, cancela e acompanha agendamentos. Todos os dados vêm da API Laravel [mecanica-api](https://github.com/schmidtgabriel30-sys/mecanica-api).

| | |
|---|---|
| **Aluno** | _[seu nome completo aqui]_ |
| **Back-end** | **Opção A — API Laravel** (consumida com o pacote `http`, autenticação Sanctum) |
| **Entidades com CRUD** | Agendamento (`/agendamentos`) e Veículo (`/veiculos`) |

## Descrição

No app o cliente:

- conhece a oficina e o pacote de revisão na página inicial;
- cria uma conta ou entra com e-mail e senha;
- **cadastra, edita e exclui** os seus veículos;
- **solicita** um agendamento, escolhendo veículo e serviço (catálogo vindo da API), dia e período;
- **lista** e **vê os detalhes** dos agendamentos, com a situação (pendente, confirmado, concluído, cancelado), o valor e o mecânico;
- **reagenda** enquanto o agendamento está pendente, **cancela** ou **exclui**.

As regras de negócio são da API: período lotado, veículo já agendado no mesmo período, veículo com agendamento em aberto etc. Quando a API recusa uma operação, a mensagem dela aparece no app.

## Telas e rotas

A navegação usa `go_router` com rotas nomeadas definidas em `lib/core/routes/` e é feita sempre com `context.goNamed(...)`.

| Tela | Nome da rota | Caminho | Login? | Função |
|---|---|---|---|---|
| Início | `home` | `/` | não | Apresentação e atalhos para agendar |
| Login | `sign-in` | `/login` | não | Entrar |
| Cadastro | `sign-up` | `/cadastro` | não | Criar conta |
| Meus agendamentos | `appointments` | `/agendamentos` | sim | Listar (GET) |
| Novo agendamento | `appointment-new` | `/agendamentos/novo` | sim | Criar (POST) |
| Detalhes | `appointment-details` | `/agendamentos/:id` | sim | Ver (GET), cancelar (PUT) e excluir (DELETE) |
| Reagendar | `appointment-edit` | `/agendamentos/:id/editar` | sim | Editar data, período e observações (PUT) |
| Meus veículos | `vehicles` | `/veiculos` | sim | Listar (GET) |
| Cadastrar veículo | `vehicle-new` | `/veiculos/novo` | sim | Criar (POST) |
| Editar veículo | `vehicle-edit` | `/veiculos/:id/editar` | sim | Editar (PUT) e excluir (DELETE) |
| Minha conta | `account` | `/conta` | sim | Perfil (GET `/user`) e logout |

As rotas privadas são protegidas pelo `redirect` do `go_router`: quem não está logado é levado para `/login`.

## Arquitetura

O projeto segue a mesma estrutura do repositório de referência (Guia Financeiro):

```
lib/
├── main.dart          # inicializações: datas em pt_BR e sessão salva
├── app.dart           # widget raiz: tema + rotas + idioma
├── core/
│   ├── constants/     # app_strings.dart (textos da interface), home_content.dart
│   ├── routes/        # app_routes.dart (nomes/caminhos), app_router.dart (go_router)
│   ├── theme/         # app_colors, app_spacing (espaços/raios/tamanhos), app_text_styles, app_theme
│   └── utils/         # validators.dart, formatters.dart
├── models/            # app_user, vehicle, service_item, appointment (fromJson/toJson)
├── services/          # api_client, json_parser, auth, vehicle, service_item, appointment
├── screens/
│   ├── home/          # home_screen.dart + sections/ (blocos da página inicial)
│   ├── auth/          # login e cadastro
│   ├── appointments/  # lista, formulário (novo/reagendar) e detalhes
│   ├── vehicles/      # lista e formulário (novo/editar/excluir)
│   └── account/       # minha conta
└── widgets/           # componentes usados por mais de uma tela
```

### Regras de dependência

- **models/** não importa Flutter: só descreve dados e converte de/para JSON.
- **services/** não importa widgets: devolve models e lança `ApiException` com a mensagem pronta.
- **screens/** nunca chama `http`: sempre passa por um service.
- **core/** não importa `services/`: o router recebe o estado de login por parâmetro em `app.dart`. Como no projeto de referência, `app_router.dart` importa as telas para montar as rotas.

### Como os dados fluem

```
Tela ──chama──▶ AppointmentService / VehicleService ──usa──▶ ApiClient ──HTTP──▶ API Laravel
  ▲                          │                                   │
  └──────── models ◀─────────┘◀────────────── JSON ──────────────┘
```

- **`ApiClient`** concentra o endereço da API, os cabeçalhos, o token Bearer, o tempo limite e a tradução dos erros do Laravel (401, 403, 404, 409 e 422).
- **`JsonParser`** é reaproveitado por todos os services para transformar JSON inválido em erro amigável.
- **`AuthService`** é um `ChangeNotifier`: faz login, cadastro e logout e salva o token com `shared_preferences`.
- **`VehicleService`** e **`AppointmentService`** fazem o CRUD e avisam as telas (`ValueNotifier changes`) para recarregar depois de cada alteração.

### Componentes reutilizáveis

- **`ListScreenBody`** trata os três estados das listas (carregando, erro e lista vazia) e é usado pelas listas de agendamentos e de veículos.
- **`ListTileCard`** é o cartão dessas listas.
- **`StatusBadge`** é a etiqueta de situação, usada na lista e nos detalhes.
- **`ConfirmDialog`**, **`PrimaryButton`**, **`DangerButton`**, **`AppTextField`** e **`PasswordField`** são usados nos formulários.

### Validação

Os formulários usam `Form` + `TextFormField`, com validadores centralizados em `core/utils/validators.dart`, que espelham as regras da API:
- conta: e-mail, senha (mínimo de 8), confirmação, nome e sobrenome;
- veículo: placa no padrão antigo ou Mercosul, ano entre 1950 e o próximo ano;
- agendamento: data a partir de hoje, veículo, serviço e período obrigatórios.

## API consumida

| Ação | Método | Rota | Corpo enviado |
|---|---|---|---|
| Cadastro / login | POST | `/api/register`, `/api/login` | `name, email, password, password_confirmation` / `email, password` |
| Usuário logado / logout | GET / POST | `/api/user`, `/api/logout` | — |
| Catálogo de serviços | GET | `/api/servicos` | — |
| Veículos | GET, POST, PUT, DELETE | `/api/veiculos[/{id}]` | `marca, modelo, placa, ano` |
| Listar / detalhar agendamentos | GET | `/api/agendamentos[/{id}]` | — |
| Criar agendamento | POST | `/api/agendamentos` | `veiculo_id, servico_id, data_agendamento (aaaa-mm-dd), periodo (manha/tarde/noite), observacoes` |
| Reagendar | PUT | `/api/agendamentos/{id}` | `data_agendamento, periodo, observacoes` |
| Cancelar | PUT | `/api/agendamentos/{id}` | `status: "cancelado"` |
| Excluir agendamento | DELETE | `/api/agendamentos/{id}` | — |

## Como rodar

1. Suba a API ([mecanica-api](https://github.com/schmidtgabriel30-sys/mecanica-api)) seguindo o README dela. Use `php artisan migrate --seed`, que cria o cliente `cliente@aurum.com` com a senha `12345678`, e depois `php artisan serve`.

2. Instale as dependências do app:

   ```bash
   flutter pub get
   ```

3. Rode o app. Por padrão ele usa `http://localhost:8000/api` (Chrome ou Windows):

   ```bash
   flutter run -d chrome
   ```

   No **emulador Android**, `localhost` é o próprio emulador, então informe o endereço do computador:

   ```bash
   flutter run --dart-define=API_URL=http://10.0.2.2:8000/api
   ```

4. Verificações de qualidade:

   ```bash
   flutter analyze
   ```

   ```bash
   dart format .
   ```

   ```bash
   flutter test
   ```

## Prints das telas

| Início | Login | Agendamentos | Novo agendamento |
|---|---|---|---|
| ![](docs/prints/01_inicio.png) | ![](docs/prints/02_login.png) | ![](docs/prints/03_agendamentos.png) | ![](docs/prints/04_novo_agendamento.png) |

| Detalhes | Reagendar | Cancelado | Meus veículos |
|---|---|---|---|
| ![](docs/prints/05_detalhes.png) | ![](docs/prints/06_reagendar.png) | ![](docs/prints/07_cancelado.png) | ![](docs/prints/08_veiculos.png) |

| Cadastrar veículo | Regra da API (409) | Lista vazia | Erro de conexão |
|---|---|---|---|
| ![](docs/prints/09_veiculo_form.png) | ![](docs/prints/10_regra_da_api.png) | ![](docs/prints/11_lista_vazia.png) | ![](docs/prints/12_erro.png) |
