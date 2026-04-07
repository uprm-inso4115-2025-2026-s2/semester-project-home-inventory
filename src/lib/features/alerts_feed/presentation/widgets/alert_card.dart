import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:src/features/alerts_feed/presentation/widgets/custom_snackbar.dart';
import '../../../../config/theme.dart';
import '../cubit/alerts_cubit.dart';
import 'alerts_modal.dart';

class AlertCard extends StatelessWidget {
  final AlertItem alert;
  final VoidCallback onDismissed;

  const AlertCard({super.key, required this.alert, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () {
            final alertsCubit = context.read<AlertsCubit>();

            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return BlocProvider.value(
                  value: alertsCubit,
                  child: AlertModal(alert: alert),
                );
              },
            );
          },
          child: Slidable(
            key: Key(alert.id),
            // (Swipe Right -> Añadir a lista)
            startActionPane: ActionPane(
              motion: const BehindMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // TODO: Lógica para añadir a la lista de compras
                    print("Añadir a lista: ${alert.title}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                        message: "TODO: Add '${alert.title}' to Grocery List",
                      ),
                    );
                  },
                  backgroundColor: AppTheme.greenAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.add,
                  label: 'Add to List',
                ),
              ],
            ),

            // (Swipe Left -> Borrar)
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    onDismissed();
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(message: "Alert Dismissed Successfully!"),
                    );
                  },
                  backgroundColor: AppTheme.lightRedAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Dismiss',
                ),
              ],
            ),
            child: Container(
              color: AppTheme.accentColor,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder de la imagen
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100, // Color temp
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.orange,
                      ),
                    ),

                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 4),
                          Text(
                            alert.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Icon(
                          alert.category == AlertCategory.expiration
                              ? Icons.warning_amber_rounded
                              : Icons.inventory_2_outlined,
                          color: alert.category == AlertCategory.expiration
                              ? AppTheme.redAccent
                              : AppTheme.surfaceColor,
                        ),
                        SizedBox(height: 35),
                        Icon(Icons.more_horiz, color: Colors.black, size: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
