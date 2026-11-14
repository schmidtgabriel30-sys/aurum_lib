import 'package:flutter/material.dart';

/// Conteúdo institucional da página inicial (textos e ícones).
///
/// Fica separado de `app_strings.dart` porque são blocos longos de marketing,
/// e não textos de interface como botões e mensagens.
abstract final class HomeContent {
  // Barra de promoção
  static const String promo = 'Promoções diárias • até 40% de desconto';

  // Hero
  static const String heroEyebrow = 'Cuidado automotivo • Aurum';
  static const String heroTitleStart = 'Seu carro merece\n';
  static const String heroTitleHighlight = 'cuidado em\ncada detalhe.';
  static const String heroText =
      'Cuide do seu carro antes que ele cuide do seu bolso. Conheça nossa revisão preventiva completa.';
  static const String heroButton = 'Agendar revisão agora';
  static const String heroNote =
      'Solicite online. Nossa equipe confirmará com você.';
  static const String heroStrip = 'PREVENÇÃO EM PRIMEIRO LUGAR';
  static const String heroImage = 'assets/images/hero.jpg';
  static const String logoImage = 'assets/images/logo.png';

  // Oferta
  static const String offerEyebrow = 'A oferta em destaque';
  static const String offerTitle = 'Revisão preventiva\ncompleta';
  static const String offerTag = 'PACOTE PROMOCIONAL';
  static const String offerOldPrice = r'De R$ 350,00';
  static const String offerCurrency = r'R$ ';
  static const String offerPrice = '249,90';
  static const String offerCash = 'à vista';
  static const String offerInstallments = ' ou em até 3x sem juros';
  static const String offerText =
      'Óleo e filtro, check-up de 40 itens e diagnóstico eletrônico em um só pacote.';

  // O que está incluído
  static const String includesEyebrow = 'O que está incluído';
  static const String includesTitle = 'Três cuidados.\nUma revisão completa.';
  static const String includesText =
      'Entenda cada serviço do pacote preventivo.';
  static const List<(IconData, String, String, String)> includes = [
    (
      Icons.opacity,
      'Troca de óleo e filtro de óleo',
      'Cuidado com a lubrificação para o bom funcionamento do motor.',
      'PROTEÇÃO DO MOTOR',
    ),
    (
      Icons.fact_check_outlined,
      'Check-up completo de 40 itens',
      'Verificação de freios, suspensão, fluidos e correias para identificar pontos de atenção.',
      'VISÃO COMPLETA DO VEÍCULO',
    ),
    (
      Icons.memory,
      'Diagnóstico eletrônico computadorizado',
      'Leitura dos sistemas eletrônicos para apoiar a avaliação do seu carro.',
      'TECNOLOGIA NO DIAGNÓSTICO',
    ),
  ];

  // Por que prevenir
  static const String whyEyebrow = 'Por que prevenir';
  static const String whyTitle = 'O melhor cuidado começa\nantes.';
  static const List<(IconData, String, String)> why = [
    (
      Icons.shield_outlined,
      'Mais atenção à segurança',
      'Acompanhe as condições de componentes importantes para dirigir.',
    ),
    (
      Icons.search,
      'Menos surpresas no caminho',
      'Identifique sinais de desgaste antes que se tornem problemas maiores.',
    ),
    (
      Icons.event_note_outlined,
      'Manutenção com planejamento',
      'Entenda as necessidades do carro e organize os próximos cuidados.',
    ),
  ];

  // Passos
  static const String stepsEyebrow = 'Do seu jeito, sem complicação';
  static const String stepsTitle = 'Seu próximo cuidado em\ntrês passos.';
  static const List<(String, String, String)> steps = [
    (
      '01',
      'Conte sobre o seu carro',
      'Preencha seus dados de contato e as informações do veículo.',
    ),
    (
      '02',
      'Indique sua preferência',
      'Escolha o dia e o período em que gostaria de fazer a revisão.',
    ),
    (
      '03',
      'Aguarde a confirmação',
      'Nossa equipe entra em contato para combinar os detalhes e confirmar a disponibilidade.',
    ),
  ];

  // Essência
  static const String essenceEyebrow = 'Essência Aurum';
  static const String essenceTitle = 'Cuidado com o carro.\nRespeito por você.';
  static const String essenceText =
      'Na Aurum Automotive, acreditamos que cuidar do seu carro também é cuidar da sua rotina. Nossa proposta une manutenção preventiva, diagnóstico e informação clara para orientar suas escolhas.';
  static const String essenceLink = 'Vamos cuidar do seu carro?';

  // FAQ
  static const String faqEyebrow = 'Antes de agendar';
  static const String faqTitle = 'Suas dúvidas,\ncom clareza.';
  static const List<(String, String)> faq = [
    (
      'O que está incluído na revisão?',
      'Troca de óleo e filtro, check-up completo de 40 itens (freios, suspensão, fluidos e correias) e diagnóstico eletrônico computadorizado.',
    ),
    ('Posso parcelar a revisão?', 'Sim, em até 3x sem juros.'),
    (
      'O pacote é adequado ao meu veículo?',
      'Nossa equipe confirma a compatibilidade ao entrar em contato.',
    ),
    (
      'E se o carro precisar de outro serviço?',
      'Você recebe a orientação e decide se deseja realizar.',
    ),
    (
      'Enviar o formulário garante meu horário?',
      'Não. O envio é uma solicitação; o dia e o horário dependem da confirmação da equipe.',
    ),
  ];

  // Chamada final
  static const String ctaEyebrow = 'Seu próximo passo';
  static const String ctaTitle = 'Dê ao seu carro\na atenção que ele merece.';
  static const String ctaText =
      'Solicite sua revisão preventiva. Deixe suas dúvidas e nossa equipe entrará em contato para confirmar os detalhes.';
  static const String ctaButton = 'Solicitar agendamento';
  static const String ctaSecondary = 'Ver meus agendamentos';

  // Rodapé
  static const String footerTagline =
      'Cuidado em cada detalhe.\nNo carro e no seu caminho.';
  static const List<String> footerLinks = [
    'Início',
    'Sobre a Aurum',
    'Oferta da revisão',
    'Dúvidas frequentes',
    'Serviços incluídos',
    'Agendamento',
  ];
  static const String footerCopyright =
      '© Aurum Automotive. Todos os direitos reservados.';
}
