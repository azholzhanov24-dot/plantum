import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/app_strings.dart';
import '../models/greenhouse_state.dart';
import '../services/supabase_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import 'auth/sign_in_screen.dart';

/// Full-featured User Settings screen matching plantum_settings_mockup.html.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _profileUsername;
  String? _profileEmail;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prof = await SupabaseService.getUserProfile();
      if (mounted) {
        setState(() {
          _profileUsername = prof?['username']?.toString();
          _profileEmail = prof?['email']?.toString();
        });

        if (_profileUsername != null) {
          try {
            final ghController = GreenhouseScope.of(context);
            ghController.setUsername(_profileUsername!);
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  /// Calculates user avatar initials from name (e.g. "Alizhan Zholzhanov" -> "AZ")
  String _computeInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'PL';
    final parts = name.trim().split(RegExp(r'[\s_]+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (name.trim().length >= 2) {
      return name.trim().substring(0, 2).toUpperCase();
    } else {
      return name.trim().toUpperCase();
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.authGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Dialog to edit user username
  Future<void> _showEditUsernameDialog(BuildContext context, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final ghController = GreenhouseScope.of(context);
    final strings = context.strings;
    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: context.surfaceColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            strings.editUsername,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textPrimaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.editUsernameDesc,
                style: TextStyle(
                  fontSize: 12.5,
                  color: context.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimaryColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.subtleSurfaceColor,
                  hintText: strings.enterNewUsername,
                  hintStyle: TextStyle(color: context.textSecondaryColor, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.brandGreenColor, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                strings.cancel,
                style: TextStyle(color: context.textSecondaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.brandGreenColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isSaving
                  ? null
                  : () async {
                      final newName = controller.text.trim();
                      if (newName.isEmpty) return;

                      setDialogState(() => isSaving = true);

                      await SupabaseService.updateProfileUsername(newName);

                      if (mounted) {
                        setState(() => _profileUsername = newName);
                        ghController.setUsername(newName);
                      }

                      if (ctx.mounted) {
                        Navigator.of(ctx).pop();
                      }
                      _showToast(strings.usernameUpdated);
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(strings.save),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet for selecting language without emojis (using 32x32 code badges: EN, RU, KZ)
  void _showLanguageBottomSheet(BuildContext context, ThemeController themeController) {
    final strings = context.strings;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        final currentLang = themeController.languageCode;

        Widget buildOption(String code, String badge, String name) {
          final isSelected = currentLang == code;

          return InkWell(
            onTap: () {
              themeController.setLanguage(code);
              Navigator.of(ctx).pop();
              _showToast(strings.languageChangedTo(name));
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isSelected ? context.greenSoftColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LanguageBadge(
                        code: badge,
                        isSelected: isSelected,
                        size: 32.0,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? context.brandGreenColor : context.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      color: context.brandGreenColor,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.textSecondaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.selectLanguage,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                buildOption('en', 'EN', 'English'),
                const SizedBox(height: 6),
                buildOption('ru', 'RU', 'Русский'),
                const SizedBox(height: 6),
                buildOption('kk', 'KZ', 'Қазақша'),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows Greenhouse location preview modal
  void _showGreenhouseMapSheet(BuildContext context, GreenhouseController ghController) {
    final location = LatLng(ghController.greenhouseLatitude, ghController.greenhouseLongitude);

    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.textSecondaryColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ghController.greenhouseName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.greenSoftColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${ghController.greenhouseArea.toStringAsFixed(0)} m²',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.brandGreenColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 16, color: context.brandGreenColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ghController.greenhouseAddress,
                      style: TextStyle(fontSize: 12.5, color: context.textSecondaryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Mini Map container
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.dividerLineColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: location,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.plantum.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: location,
                            width: 36,
                            height: 36,
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: context.brandGreenColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(Icons.eco_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Center(
                child: Text(
                  context.strings.coordinatesFormat(location.latitude, location.longitude),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirmation dialog for Log out
  void _showLogoutConfirmation(BuildContext context) {
    final strings = context.strings;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.logoutBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: context.logoutTextColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              strings.logOutConfirmTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.logOutConfirmDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: context.subtleSurfaceColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    strings.cancel,
                    style: TextStyle(
                      color: context.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.logoutTextColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    Navigator.of(ctx).pop(); // Close dialog

                    try {
                      await SupabaseService.signOut();
                    } catch (_) {}

                    try {
                      if (context.mounted) {
                        GreenhouseScope.of(context).clearUser();
                      }
                    } catch (_) {}

                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                        (route) => false,
                      );
                    }
                  },
                  child: Text(
                    strings.logOut,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeScope.of(context);
    final ghController = GreenhouseScope.of(context);

    final currentUsername = _profileUsername ?? ghController.username ?? 'Alizhan Zholzhanov';
    final currentEmail = _profileEmail ?? ghController.email ?? 'azholzhanov24@gmail.com';
    final initials = _computeInitials(currentUsername);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Back Button + Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: context.subtleSurfaceColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: context.textPrimaryColor,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    context.strings.settings,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimaryColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ==========================================
                    // 1. ACCOUNT & PROFILE CARD
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: context.dividerLineColor, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.035),
                            blurRadius: 14.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Circular Sage-Green Avatar with initials
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: context.greenSoftColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: context.brandGreenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Username and email
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentUsername,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimaryColor,
                                    letterSpacing: -0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentEmail,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: context.textSecondaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Edit Pencil Button
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: context.subtleSurfaceColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: context.textSecondaryColor,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                              tooltip: 'Edit username',
                              onPressed: () => _showEditUsernameDialog(context, currentUsername),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ==========================================
                    // 2. ACTIVE GREENHOUSE CARD
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: context.dividerLineColor, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.035),
                            blurRadius: 14.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header: Section title + Online pill badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.strings.activeGreenhouse,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: context.textSecondaryColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: context.greenSoftColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: context.brandGreenColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      context.strings.online,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: context.brandGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sprout icon container
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: context.greenSoftColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.eco_rounded,
                                  color: context.brandGreenColor,
                                  size: 19,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Greenhouse details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ghController.greenhouseName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: context.textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      context.strings.areaFormat(ghController.greenhouseArea),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.textSecondaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 14,
                                          color: context.brandGreenColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            ghController.greenhouseAddress,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: context.textSecondaryColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Map action button
                              TextButton(
                                onPressed: () => _showGreenhouseMapSheet(context, ghController),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  context.strings.map,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: context.brandGreenColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ==========================================
                    // 3. PREFERENCES CARD (Appearance & Language)
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: context.dividerLineColor, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.035),
                            blurRadius: 14.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.strings.preferences,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              color: context.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Appearance Header Row
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: context.subtleSurfaceColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  themeController.isDarkMode
                                      ? Icons.dark_mode_outlined
                                      : Icons.light_mode_outlined,
                                  color: context.textSecondaryColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                context.strings.appearance,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.textPrimaryColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Full-width Two-column Segmented Pill Switch (Light / Dark)
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color: context.subtleSurfaceColor,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Row(
                              children: [
                                // Light Segment
                                Expanded(
                                  child: InkWell(
                                    onTap: () => themeController.setThemeMode(ThemeMode.light),
                                    borderRadius: BorderRadius.circular(11.0),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(vertical: 9.0),
                                      decoration: BoxDecoration(
                                        color: !themeController.isDarkMode
                                            ? (context.isDark
                                                ? const Color(0xFF2C322E)
                                                : Colors.white)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(11.0),
                                        boxShadow: !themeController.isDarkMode
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.wb_sunny_rounded,
                                            size: 16,
                                            color: !themeController.isDarkMode
                                                ? const Color(0xFFF59E0B)
                                                : context.textSecondaryColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            context.strings.light,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: !themeController.isDarkMode
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: !themeController.isDarkMode
                                                  ? context.textPrimaryColor
                                                  : context.textSecondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 4),

                                // Dark Segment
                                Expanded(
                                  child: InkWell(
                                    onTap: () => themeController.setThemeMode(ThemeMode.dark),
                                    borderRadius: BorderRadius.circular(11.0),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(vertical: 9.0),
                                      decoration: BoxDecoration(
                                        color: themeController.isDarkMode
                                            ? (context.isDark
                                                ? const Color(0xFF2C322E)
                                                : Colors.white)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(11.0),
                                        boxShadow: themeController.isDarkMode
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.15),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.nightlight_round,
                                            size: 15,
                                            color: themeController.isDarkMode
                                                ? (context.isDark
                                                    ? const Color(0xFF81C784)
                                                    : context.brandGreenColor)
                                                : context.textSecondaryColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            context.strings.dark,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: themeController.isDarkMode
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: themeController.isDarkMode
                                                  ? context.textPrimaryColor
                                                  : context.textSecondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          Divider(height: 1, color: context.dividerLineColor),
                          const SizedBox(height: 12),

                          // Language Selector Row
                          InkWell(
                            onTap: () => _showLanguageBottomSheet(context, themeController),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: context.subtleSurfaceColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.translate_rounded,
                                          color: context.textSecondaryColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        context.strings.language,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: context.textPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      LanguageBadge(
                                        code: themeController.languageBadgeText,
                                        size: 26.0,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        themeController.languageName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: context.textSecondaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: context.textSecondaryColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // 4. LOG OUT BUTTON
                    // ==========================================
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.logout_rounded,
                          color: context.logoutTextColor,
                          size: 19,
                        ),
                        label: Text(
                          context.strings.logOut,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: context.logoutTextColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.logoutBgColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _showLogoutConfirmation(context),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        context.strings.versionFooter,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
