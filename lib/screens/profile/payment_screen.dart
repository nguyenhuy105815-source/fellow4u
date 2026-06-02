/// Payment Screen - manage payment methods
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<_PaymentCard> _cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.paymentMethods,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.credit_card_off_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noCards,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.addCardHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _showAddCard,
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(AppStrings.addCard),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cards.length + 1,
              itemBuilder: (_, i) {
                if (i == _cards.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: OutlinedButton.icon(
                      onPressed: _showAddCard,
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(AppStrings.addCard),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  );
                }
                final card = _cards[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.credit_card,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    title: Text(
                      '•••• ${card.last4}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(card.brand),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeCard(i),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: _AddCardSheet(
          onAdd: (last4, brand) {
            Navigator.pop(ctx);
            setState(() => _cards.add(_PaymentCard(last4: last4, brand: brand)));
          },
        ),
      ),
    );
  }

  void _removeCard(int index) {
    setState(() => _cards.removeAt(index));
  }
}

class _PaymentCard {
  final String last4;
  final String brand;

  _PaymentCard({required this.last4, required this.brand});
}

class _AddCardSheet extends StatefulWidget {
  final void Function(String last4, String brand) onAdd;

  const _AddCardSheet({required this.onAdd});

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _cardController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final card = _cardController.text.replaceAll(' ', '');
    if (card.length >= 4) {
      widget.onAdd(card.substring(card.length - 4), 'Visa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.addCard,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cardController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Số thẻ',
              hintText: '1234 5678 9012 3456',
            ),
            maxLength: 19,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Tên chủ thẻ',
              hintText: 'NGUYEN VAN A',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Thêm thẻ'),
          ),
        ],
      ),
    );
  }
}
