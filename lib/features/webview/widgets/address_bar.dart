import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/url_validator.dart';

/// Address bar widget for the WebView screen
class AddressBar extends StatefulWidget {
  final String currentUrl;
  final Function(String) onUrlSubmitted;
  final VoidCallback onReload;
  final VoidCallback onShare;
  final bool isLoading;

  const AddressBar({
    super.key,
    required this.currentUrl,
    required this.onUrlSubmitted,
    required this.onReload,
    required this.onShare,
    this.isLoading = false,
  });

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  late TextEditingController _urlController;
  late FocusNode _focusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AddressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.currentUrl != _urlController.text) {
      _urlController.text = widget.currentUrl;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isEditing = true;
      });
      // Select all text when focused
      _urlController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _urlController.text.length,
      );
    } else {
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _handleSubmit() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      final normalizedUrl = UrlValidator.normalize(url);
      if (UrlValidator.isValid(normalizedUrl)) {
        widget.onUrlSubmitted(normalizedUrl);
      } else {
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid URL'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isSecure = widget.currentUrl.startsWith('https://');
    final displayUrl = _isEditing
        ? _urlController.text
        : UrlValidator.getDomain(widget.currentUrl);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isEditing ? AppColors.accent : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Security icon
          Icon(
            isSecure ? Icons.lock_outline : Icons.lock_open_outlined,
            size: 16,
            color: isSecure ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: 8),
          // URL text field
          Expanded(
            child: TextField(
              controller: _urlController,
              focusNode: _focusNode,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: _isEditing ? 'Enter URL' : displayUrl,
                hintStyle: TextStyle(
                  color: AppColors.subtle.withOpacity(0.7),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
          // Reload button
          if (widget.isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.highlight,
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              color: AppColors.onSurface,
              onPressed: widget.onReload,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          const SizedBox(width: 4),
          // Share button
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 18),
            color: AppColors.onSurface,
            onPressed: widget.onShare,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }
}