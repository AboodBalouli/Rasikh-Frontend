import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:flutter_application_1/features/wallet/presentation/widgets/deposit_bottom_sheet.dart';
import 'package:flutter_application_1/features/wallet/presentation/widgets/transaction_list_item.dart';
import 'package:flutter_application_1/features/wallet/presentation/widgets/transfer_bottom_sheet.dart';
import 'package:flutter_application_1/features/wallet/presentation/widgets/wallet_action_buttons.dart';
import 'package:flutter_application_1/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:flutter_application_1/features/wallet/presentation/widgets/withdraw_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Main wallet page displaying balance, actions, and transaction history.
class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(myTransactionsProvider);
    final balanceAsync = ref.watch(myWalletBalanceProvider);

    return Scaffold(
      backgroundColor: TColors.light,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: TColors.primary),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'المحفظة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: TColors.primary,
          ),
        ),
        backgroundColor: TColors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: TColors.primary),
            onPressed: () {
              ref.invalidate(myTransactionsProvider);
              ref.read(walletRefreshProvider.notifier).state++;
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: TColors.primary,
        onRefresh: () async {
          ref.invalidate(myTransactionsProvider);
          ref.read(walletRefreshProvider.notifier).state++;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Balance card
            SliverToBoxAdapter(
              child: balanceAsync.when(
                loading: () =>
                    const WalletBalanceCard(balance: 0, isLoading: true),
                error: (_, __) => const WalletBalanceCard(balance: 0),
                data: (balance) => WalletBalanceCard(balance: balance),
              ),
            ),

            // Action buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: WalletActionsRow(
                  onDeposit: () => _showDeposit(context),
                  onWithdraw: () => _showWithdraw(context),
                  onTransfer: () => _showTransfer(context),
                ),
              ),
            ),

            // Transactions header
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20, color: TColors.textSecondary),
                    SizedBox(width: 8),
                    Text(
                      'آخر المعاملات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Transaction list
            transactionsAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(color: TColors.primary),
                  ),
                ),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: TColors.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'فشل تحميل المعاملات',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            ref.invalidate(myTransactionsProvider);
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: TColors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'لا توجد معاملات حتى الآن',
                              style: TextStyle(
                                fontSize: 16,
                                color: TColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == transactions.length) {
                      return const SizedBox(height: 24);
                    }
                    return TransactionListItem(
                      transaction: transactions[index],
                    );
                  }, childCount: transactions.length + 1),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeposit(BuildContext context) {
    showDepositBottomSheet(context);
  }

  void _showWithdraw(BuildContext context) {
    showWithdrawBottomSheet(context);
  }

  void _showTransfer(BuildContext context) {
    showTransferBottomSheet(context);
  }
}
