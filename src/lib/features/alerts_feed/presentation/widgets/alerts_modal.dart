import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../cubit/alerts_cubit.dart';
import 'button.dart';

// 1. Definimos los posibles estados del modal
enum ModalMode { normal, editCount, editDate, confirmation }

enum ConfirmationType { addedToList, countUpdated, dateUpdated, consumed }

class AlertModal extends StatefulWidget {
  final AlertItem alert;

  const AlertModal({super.key, required this.alert});

  @override
  State<AlertModal> createState() => _AlertModalState();
}

class _AlertModalState extends State<AlertModal> {
  ModalMode _currentMode = ModalMode.normal;
  ConfirmationType? _confirmationType;

  // Variables de estado para los modos de edición
  int _itemCount = 2; // Simulado
  String _selectedDate = "MM/DD/YYYY";
  String? _errorMessage;

  // Método para transicionar entre vistas
  void _setMode(ModalMode mode, {ConfirmationType? confirmation}) {
    setState(() {
      _currentMode = mode;
      _confirmationType = confirmation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildImageArea(),
            const SizedBox(height: 16),
            _buildDynamicContent(),
            const SizedBox(height: 16),
            // Botón de Dismiss (siempre visible)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Dismiss",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.redAccent,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECCIONES DEL MODAL ---

  Widget _buildHeader() {
    // Si estamos en confirmación, el título cambia
    if (_currentMode == ModalMode.confirmation) {
      String itemName = widget.alert.title.split('-').first.trim();
      if (itemName.isEmpty) itemName = widget.alert.title;

      return Text(
        itemName,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge,
        children: [
          TextSpan(
            text: widget.alert.title, // Ej: "Carrots"
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.alert.category == AlertCategory.lowStock
                ? " - Low Stock"
                : " - Expiration",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Placeholder de la imagen
        Container(
          height: 120,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.orange.shade100, // Color temp
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.image, size: 50, color: Colors.orange),
        ),

        // El checkmark verde que aparece solo en modo confirmación
        if (_currentMode == ModalMode.confirmation)
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.check, color: Colors.white, size: 30),
          ),
      ],
    );
  }

  Widget _buildDynamicContent() {
    switch (_currentMode) {
      case ModalMode.normal:
        return _buildNormalMode();
      case ModalMode.editCount:
        return _buildEditCountMode();
      case ModalMode.editDate:
        return _buildEditDateMode();
      case ModalMode.confirmation:
        return _buildConfirmationMode();
    }
  }

  // --- LOS 4 MODOS (VISTAS) ---

  Widget _buildNormalMode() {
    return Column(
      children: [
        Text(
          widget.alert.message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),
        ActionButton(
          text: "Add to Grocery List",
          backgroundColor: AppTheme.primaryColor,
          onPressed: () {
            _setMode(
              ModalMode.confirmation,
              confirmation: ConfirmationType.addedToList,
            );
            context.read<AlertsCubit>().removeAlert(widget.alert.id);
          },
        ),
        const SizedBox(height: 10),
        ActionButton(
          text: widget.alert.category == AlertCategory.lowStock
              ? "Update Count"
              : "Update Expiration Date",
          backgroundColor: AppTheme.accentColor,
          onPressed: () {
            if (widget.alert.category == AlertCategory.lowStock) {
              _setMode(ModalMode.editCount);
            } else {
              _setMode(ModalMode.editDate);
            }
          },
        ),
        const SizedBox(height: 10),
        ActionButton(
          text: "Mark as Consumed",
          backgroundColor: AppTheme.mutedText,
          onPressed: () {
            _setMode(
              ModalMode.confirmation,
              confirmation: ConfirmationType.consumed,
            );
            context.read<AlertsCubit>().removeAlert(widget.alert.id);
          },
        ),
      ],
    );
  }

  Widget _buildEditCountMode() {
    return Column(
      children: [
        Text("Update Count:", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => setState(() {
                if (_itemCount > 0) _itemCount--;
              }),
              icon: const Icon(
                Icons.remove_circle,
                color: AppTheme.accentColor,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "$_itemCount",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _itemCount++),
              icon: const Icon(
                Icons.add_circle,
                color: AppTheme.accentColor,
                size: 40,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),
        ActionButton(
          text: "Save",
          backgroundColor: AppTheme.primaryColor,
          onPressed: () {
            _setMode(
              ModalMode.confirmation,
              confirmation: ConfirmationType.countUpdated,
            );
            context.read<AlertsCubit>().removeAlert(widget.alert.id);
          },
        ),
      ],
    );
  }

  Widget _buildEditDateMode() {
    return Column(
      children: [
        Text(
          "Update Expiration Date:",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2050),
            );
            if (picked != null) {
              setState(() {
                _selectedDate = "${picked.month}/${picked.day}/${picked.year}";
                _errorMessage = null;
              });
            }
          },
          child: Text(
            _selectedDate,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: _errorMessage != null
                  ? AppTheme.redAccent
                  : AppTheme.primaryText,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),

        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.redAccent,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        ActionButton(
          text: "Save",
          backgroundColor: AppTheme.primaryColor,
          onPressed: () {
            if (_selectedDate == "MM/DD/YYYY") {
              setState(() {
                _errorMessage = "Please select a valid date before saving.";
              });
              return; // No se ha seleccionado fecha
            }
            _setMode(
              ModalMode.confirmation,
              confirmation: ConfirmationType.dateUpdated,
            );
            context.read<AlertsCubit>().removeAlert(widget.alert.id);
          },
        ),
      ],
    );
  }

  Widget _buildConfirmationMode() {
    String title = "";
    String subtitle = "";

    switch (_confirmationType) {
      case ConfirmationType.addedToList:
        title = "Added to Grocery List!";
        break;
      case ConfirmationType.countUpdated:
        title = "Item Count has been updated!";
        subtitle = "There are now $_itemCount units available.";
        break;
      case ConfirmationType.dateUpdated:
        title = "Exp. Date has been updated!";
        subtitle = "Item now expires on $_selectedDate.";
        break;
      case ConfirmationType.consumed:
        title = "Item has been consumed!";
        break;
      default:
        break;
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(),
        ),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
