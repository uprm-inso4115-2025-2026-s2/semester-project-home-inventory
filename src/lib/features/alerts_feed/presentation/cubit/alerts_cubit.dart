import 'package:flutter_bloc/flutter_bloc.dart';

// 1. Tipos de Alerta
enum AlertCategory { all, lowStock, expiration }

// 2. Modelo de la Alerta (Datos Mock)
class AlertItem {
  final String id;
  final String title;
  final String message;
  final AlertCategory category;

  AlertItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
  });
}

// 3. El Estado del Cubit
class AlertsState {
  final AlertCategory activeFilter;
  final List<AlertItem> alerts;

  AlertsState({required this.activeFilter, required this.alerts});

  // Método para obtener solo las alertas que coinciden con el filtro
  List<AlertItem> get filteredAlerts {
    if (activeFilter == AlertCategory.all) return alerts;
    return alerts.where((alert) => alert.category == activeFilter).toList();
  }
}

// 4. El Cubit
class AlertsCubit extends Cubit<AlertsState> {
  AlertsCubit()
    : super(AlertsState(activeFilter: AlertCategory.all, alerts: _mockAlerts));

  // Cambiar el filtro seleccionado
  void setFilter(AlertCategory category) {
    emit(AlertsState(activeFilter: category, alerts: state.alerts));
  }

  // Eliminar una alerta (cuando el usuario le da Swipe)
  void removeAlert(String id) {
    final updatedAlerts = state.alerts
        .where((alert) => alert.id != id)
        .toList();
    emit(AlertsState(activeFilter: state.activeFilter, alerts: updatedAlerts));
  }

  //TODO: Implementar método para añadir articulo a lista de compras

  // Datos falsos para probar el UI (eliminar al implementar backend)
  static final List<AlertItem> _mockAlerts = [
    AlertItem(
      id: '1',
      title: 'Item name',
      message: 'This item is expiring in 2 days',
      category: AlertCategory.expiration,
    ),
    AlertItem(
      id: '2',
      title: 'Item name',
      message: 'There are only 2 units left',
      category: AlertCategory.lowStock,
    ),
    AlertItem(
      id: '3',
      title: 'Item name',
      message: 'This item is expiring tomorrow',
      category: AlertCategory.expiration,
    ),
  ];
}
