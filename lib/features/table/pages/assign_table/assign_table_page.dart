import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/animated_qr_scanner.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../providers/table_provider.dart';

class AssignTablePage extends StatefulWidget {
  const AssignTablePage({super.key});

  @override
  State<AssignTablePage> createState() => _AssignTablePageState();
}

class _AssignTablePageState extends State<AssignTablePage> {
  final MobileScannerController _scannerController = MobileScannerController();
  final TextEditingController _tableNumberController = TextEditingController();
  bool _isManualEntry = false;
  bool _hasScanned = false;

  @override
  void dispose() {
    _scannerController.dispose();
    _tableNumberController.dispose();
    super.dispose();
  }

  void _onQRDetected(BarcodeCapture capture) async {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _hasScanned = true);

    final tableProvider = context.read<TableProvider>();
    final success = await tableProvider.assignTableByQR(code);

    if (!mounted) return;

    if (success) {
      await _scannerController.stop();
      if (mounted) {
        Navigator.pop(context, tableProvider.currentTable?.tableNumber);
      }
    } else {
      setState(() => _hasScanned = false);
      _showErrorDialog(
          tableProvider.error ?? AppLocalizations.of(context).errorScanningQR);
    }
  }

  void _assignManualTable() async {
    final tableNumber = int.tryParse(_tableNumberController.text);
    if (tableNumber == null || tableNumber <= 0) {
      _showErrorDialog(AppLocalizations.of(context).invalidTableNumber);
      return;
    }

    final tableProvider = context.read<TableProvider>();
    final success = await tableProvider.assignTableByNumber(tableNumber);

    if (success && mounted) {
      Navigator.pop(context, tableNumber);
    } else if (mounted) {
      _showErrorDialog(tableProvider.error ??
          AppLocalizations.of(context).errorAssigningTable);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundPrimary(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context).assignTable,
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isManualEntry ? Icons.qr_code_scanner : Icons.keyboard,
              color: AppColors.getTextPrimary(context),
            ),
            onPressed: () {
              setState(() => _isManualEntry = !_isManualEntry);
              if (!_isManualEntry) {
                _tableNumberController.clear();
                _hasScanned = false;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isManualEntry ? _buildManualEntry(isDark) : _buildQRScanner(),
        ),
      ),
    );
  }

  Widget _buildQRScanner() {
    return Column(
      key: const ValueKey('qr_scanner'),
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            AppLocalizations.of(context).scanQRCode,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getTextSecondary(context),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _scannerController,
                    onDetect: _onQRDetected,
                  ),
                  CustomPaint(
                    painter: QRScannerOverlayPainter(
                      scanAreaSize: MediaQuery.of(context).size.width,
                      overlayColor: Colors.black54,
                      cornerColor: AppColors.primary,
                    ),
                    child: Container(),
                  ),
                  Center(
                    child: AnimatedScanLine(
                      scanAreaSize: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 48,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).pointCameraAtQR,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntry(bool isDark) {
    return Padding(
      key: const ValueKey('manual_entry'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context).enterTableNumber,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getTextSecondary(context),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.darkCardGradient
                  : AppColors.lightCardGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.table_restaurant,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _tableNumberController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                  ),
                  decoration: InputDecoration(
                    hintText: '00',
                    hintStyle: TextStyle(
                      color: AppColors.getTextSecondary(context)
                          .withValues(alpha: 0.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.getTextSecondary(context)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.getTextSecondary(context)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _assignManualTable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context).confirmTable,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).tableNumberHint,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
