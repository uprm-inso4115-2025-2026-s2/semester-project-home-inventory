import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../../../../core/presentation/widgets/top.dart';
import '../cubit/alerts_cubit.dart';
import '../widgets/alert_card.dart';

class AlertsHome extends StatelessWidget {
  const AlertsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlertsCubit(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Column(
          children: [
            Top(
              color: Colors.black,
              leftButton: () => Navigator.pop(context),
              title: "Alerts",
              textStyle: Theme.of(context).textTheme.displayLarge,
              iconColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 10),

            // FILTROS
            BlocBuilder<AlertsCubit, AlertsState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFilterChip(
                        context,
                        "All",
                        AlertCategory.all,
                        state.activeFilter,
                      ),
                      _buildFilterChip(
                        context,
                        "Expiration",
                        AlertCategory.expiration,
                        state.activeFilter,
                      ),
                      _buildFilterChip(
                        context,
                        "Low Stock",
                        AlertCategory.lowStock,
                        state.activeFilter,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // LISTA DE ALERTAS
            Expanded(
              child: BlocBuilder<AlertsCubit, AlertsState>(
                builder: (context, state) {
                  final alerts = state.filteredAlerts;

                  // Empty State (Si no hay alertas)
                  if (alerts.isEmpty) {
                    return Center(
                      child: Text(
                        "You're all caught up!",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  // Lista normal
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return AlertCard(
                        alert: alert,
                        onDismissed: () {
                          context.read<AlertsCubit>().removeAlert(alert.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pequeño para construir cada "pill" del filtro
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    AlertCategory category,
    AlertCategory activeFilter,
  ) {
    final isSelected = category == activeFilter;
    return ChoiceChip(
      label: SizedBox(width: 80, child: Center(child: Text(label))),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          context.read<AlertsCubit>().setFilter(category);
        }
      },
      selectedColor: AppTheme.primaryColor,
      backgroundColor: AppTheme.surfaceColor,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isSelected ? AppTheme.surfaceColor : AppTheme.primaryText,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      showCheckmark: false,
    );
  }
}
