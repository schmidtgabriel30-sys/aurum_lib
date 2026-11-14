import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import 'empty_state.dart';
import 'error_state.dart';
import 'loading_state.dart';

/// Corpo padrão das telas de lista, com os três estados obrigatórios:
/// carregando, erro e lista vazia.
///
/// Reaproveitado pelas listas de agendamentos e de veículos: cada tela só
/// informa o `Future` e como desenhar um item.
class ListScreenBody<T> extends StatelessWidget {
  const ListScreenBody({
    super.key,
    required this.future,
    required this.itemBuilder,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.onRetry,
    required this.onRefresh,
  });

  final Future<List<T>> future;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;
  final IconData emptyIcon;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<T>>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const LoadingState();
      }
      if (snapshot.hasError) {
        return ErrorState(message: '${snapshot.error}', onRetry: onRetry);
      }

      final List<T> items = snapshot.data!;
      if (items.isEmpty) {
        return EmptyState(message: emptyMessage, icon: emptyIcon);
      }

      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.lg,
            AppSpacing.screenPadding,
            AppSpacing.xxxl * 3,
          ),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => itemBuilder(context, items[index]),
        ),
      );
    },
  );
}
