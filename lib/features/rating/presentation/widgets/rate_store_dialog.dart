import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/rating/presentation/providers/rating_providers.dart';
import 'package:flutter_application_1/features/rating/presentation/widgets/rating_input_widget.dart';

/// A dialog for rating a store/seller.
///
/// Shows a star input, optional comment field, and submit button.
class RateStoreDialog extends ConsumerStatefulWidget {
  /// The seller profile ID to rate.
  final int sellerId;

  /// The store name for display.
  final String storeName;

  /// Initial rating if editing an existing rating.
  final int? initialRating;

  /// Initial comment if editing an existing rating.
  final String? initialComment;

  const RateStoreDialog({
    super.key,
    required this.sellerId,
    required this.storeName,
    this.initialRating,
    this.initialComment,
  });

  /// Shows the dialog and returns true if a rating was submitted.
  static Future<bool?> show(
    BuildContext context, {
    required int sellerId,
    required String storeName,
    int? initialRating,
    String? initialComment,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => RateStoreDialog(
        sellerId: sellerId,
        storeName: storeName,
        initialRating: initialRating,
        initialComment: initialComment,
      ),
    );
  }

  @override
  ConsumerState<RateStoreDialog> createState() => _RateStoreDialogState();
}

class _RateStoreDialogState extends ConsumerState<RateStoreDialog> {
  late int _selectedRating;
  late TextEditingController _commentController;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating ?? 0;
    _commentController = TextEditingController(
      text: widget.initialComment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_selectedRating == 0) {
      setState(() {
        _errorMessage = 'Please select a rating';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final usecase = ref.read(rateStoreUseCaseProvider);
      await usecase(
        sellerId: widget.sellerId,
        rating: _selectedRating,
        comment: _commentController.text.trim().isNotEmpty
            ? _commentController.text.trim()
            : null,
      );

      // Invalidate the ratings cache to refresh
      ref.invalidate(storeRatingsProvider(widget.sellerId));

      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('RatingException: ', '');
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Rate Store',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(false),
                  icon: const Icon(Icons.close_rounded),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.storeName,
              style: const TextStyle(
                fontSize: 14,
                color: TColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 24),

            // Star rating input
            Center(
              child: RatingInputWidget(
                initialRating: _selectedRating,
                size: 44,
                onRatingChanged: (rating) {
                  setState(() {
                    _selectedRating = rating;
                    _errorMessage = null;
                  });
                },
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Text(
                _getRatingLabel(_selectedRating),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _selectedRating > 0
                      ? TColors.textPrimary
                      : TColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Comment field
            TextField(
              controller: _commentController,
              maxLines: 3,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'Add a comment (optional)',
                hintStyle: const TextStyle(color: TColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TColors.borderSecondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TColors.borderSecondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: TColors.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: TColors.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 24),

            // Submit button
            FilledButton(
              onPressed: _isSubmitting ? null : _submitRating,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap to rate';
    }
  }
}
