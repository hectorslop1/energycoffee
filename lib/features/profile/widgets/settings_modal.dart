import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/biometric_provider.dart';
import '../../../core/l10n/app_localizations.dart';

class SettingsModal extends StatefulWidget {
  const SettingsModal({super.key});

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final biometricProvider = Provider.of<BiometricProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackgroundSecondary
            : AppColors.lightBackgroundSecondary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.getTextSecondary(context).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).settings,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.getTextSecondary(context),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                      context, AppLocalizations.of(context).appearance),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    context: context,
                    icon: isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    title: AppLocalizations.of(context).theme,
                    subtitle: isDark
                        ? AppLocalizations.of(context).darkMode
                        : AppLocalizations.of(context).lightMode,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.getTextSecondary(context),
                    ),
                    onTap: () => _showThemeSelector(context),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                      context, AppLocalizations.of(context).preferences),
                  const SizedBox(height: 12),
                  Consumer<LocaleProvider>(
                    builder: (context, localeProvider, child) {
                      final languageLabel =
                          localeProvider.locale.languageCode == 'en'
                              ? 'English'
                              : 'Español';
                      return _buildSettingTile(
                        context: context,
                        icon: Icons.language_rounded,
                        title: AppLocalizations.of(context).language,
                        subtitle: languageLabel,
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.getTextSecondary(context),
                        ),
                        onTap: () => _showLanguageSelector(context),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                      context, AppLocalizations.of(context).security),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    context: context,
                    icon: Icons.fingerprint_rounded,
                    title: AppLocalizations.of(context).biometricLoginSetting,
                    subtitle: biometricProvider.isBiometricAvailable
                        ? AppLocalizations.of(context).biometricLoginDescription
                        : AppLocalizations.of(context).notAvailable,
                    trailing: Switch(
                      value: biometricProvider.isBiometricEnabled,
                      onChanged: biometricProvider.isBiometricAvailable
                          ? (value) async {
                              if (value) {
                                // Show confirmation dialog when enabling
                                final confirmed =
                                    await _showBiometricConfirmation(context);
                                if (confirmed == true) {
                                  await biometricProvider
                                      .toggleBiometric(value);
                                }
                              } else {
                                // Disable without confirmation
                                await biometricProvider.toggleBiometric(value);
                              }
                            }
                          : null,
                      activeColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                      context, AppLocalizations.of(context).information),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    context: context,
                    icon: Icons.help_outline_rounded,
                    title: AppLocalizations.of(context).help,
                    subtitle: AppLocalizations.of(context).helpCenter,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.getTextSecondary(context),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${AppLocalizations.of(context).comingSoon}: ${AppLocalizations.of(context).help}'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: isDark
                              ? AppColors.darkBackgroundCard
                              : AppColors.lightBackgroundCard,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextSecondary(context),
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
      ).copyWith(height: 1.2),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackgroundCard
              : AppColors.lightBackgroundCard.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getTextSecondary(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackgroundSecondary
                : AppColors.lightBackgroundSecondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.theme,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 16),
              _buildThemeOption(context, l10n.lightMode,
                  Icons.light_mode_rounded, ThemeMode.light),
              _buildThemeOption(context, l10n.darkMode, Icons.dark_mode_rounded,
                  ThemeMode.dark),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
      BuildContext context, String label, IconData icon, ThemeMode mode) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = themeProvider.themeMode == mode;

    return ListTile(
      leading: Icon(icon,
          color: isSelected
              ? AppColors.primary
              : AppColors.getTextSecondary(context)),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: AppColors.getTextPrimary(context),
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : null,
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackgroundSecondary
                : AppColors.lightBackgroundSecondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                  context, 'English', '🇺🇸', const Locale('en')),
              _buildLanguageOption(
                  context, 'Español', '🇲🇽', const Locale('es')),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, String flag, Locale locale) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isSelected = localeProvider.locale == locale;

    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        language,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: AppColors.getTextPrimary(context),
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : null,
      onTap: () {
        localeProvider.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  Future<bool?> _showBiometricConfirmation(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Detect platform to show appropriate message
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final message = isIOS
        ? l10n.enableBiometricMessageIOS
        : l10n.enableBiometricMessageAndroid;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkBackgroundSecondary
            : AppColors.lightBackgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.enableBiometricTitle,
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.getTextSecondary(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.confirm,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
