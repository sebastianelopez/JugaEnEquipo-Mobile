import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/messages/screens/messages_screen.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

double _toolbarHeight = 50.0.h;

class MainNavbar extends StatefulWidget implements PreferredSizeWidget {
  const MainNavbar({super.key});

  @override
  State<MainNavbar> createState() => _MainNavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight);
}

class _MainNavbarState extends State<MainNavbar> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final double _dropdownMaxHeight = 220.0;
  bool _isListeningToProvider = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to provider changes to update the overlay
    if (!_isListeningToProvider) {
      context.read<SearchProvider>().addListener(_onSearchProviderChanged);
      _isListeningToProvider = true;
    }
  }

  @override
  void dispose() {
    if (_isListeningToProvider) {
      context.read<SearchProvider>().removeListener(_onSearchProviderChanged);
      _isListeningToProvider = false;
    }
    _removeOverlay();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final provider = context.read<SearchProvider>();
    final bool shouldShow = _focusNode.hasFocus &&
        (provider.isLoading || provider.suggestions.isNotEmpty);
    if (shouldShow) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _onSearchProviderChanged() {
    final provider = context.read<SearchProvider>();
    final bool shouldShow = _focusNode.hasFocus &&
        (provider.isLoading || provider.suggestions.isNotEmpty);
    if (shouldShow) {
      if (_overlayEntry == null) {
        _showOverlay();
      } else {
        _overlayEntry?.markNeedsBuild();
      }
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final RenderBox? renderBox =
            _fieldKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null || !renderBox.attached) {
          return const SizedBox.shrink();
        }
        final Size targetSize = renderBox.size;
        final Offset targetOffset = renderBox.localToGlobal(Offset.zero);
        final double overlayWidth = targetSize.width;
        return Stack(
          children: [
            // Body-only tap layer to close suggestions when clicking outside
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).padding.top + _toolbarHeight,
              bottom: MediaQuery.of(context).padding.bottom +
                  kBottomNavigationBarHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  context.read<SearchProvider>().clearResults();
                  _removeOverlay();
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Suggestions dropdown
            Positioned(
              left: targetOffset.dx,
              top: targetOffset.dy + targetSize.height,
              width: overlayWidth,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 4,
                clipBehavior: Clip.hardEdge,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: _dropdownMaxHeight.h),
                  child: _SuggestionsList(
                    onItemTap: (user) {
                      FocusScope.of(context).unfocus();
                      context.read<SearchProvider>().clearResults();
                      _removeOverlay();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(userId: user.id),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;

    return AppBar(
      toolbarHeight: _toolbarHeight,
      centerTitle: true,
      title: CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          key: _fieldKey,
          margin: EdgeInsets.symmetric(vertical: 5.0.w),
          constraints: BoxConstraints(maxHeight: 36.0.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0.h),
            ),
          ),
          child: TextField(
            focusNode: _focusNode,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4.0.h),
                hintText: AppLocalizations.of(context)!.navSearchInputLabel,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Icon(Icons.search, size: 20.0.h),
                prefixIconConstraints: BoxConstraints(
                  minHeight: 28.0.h,
                  minWidth: 36.0.h,
                ),
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            onChanged: (value) {
              final searchProvider =
                  Provider.of<SearchProvider>(context, listen: false);
              if (value.trim().isEmpty) {
                searchProvider.clearResults();
                return;
              }
              searchProvider.onQueryChanged(value);
            },
          ),
        ),
      ),
      backgroundColor: AppTheme.primary,
      leadingWidth: 50.0.h,
      leading: GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: CircleAvatar(
            backgroundImage: (user?.profileImage != null &&
                    (user!.profileImage?.isNotEmpty ?? false) &&
                    (user.profileImage!.startsWith('http://') ||
                        user.profileImage!.startsWith('https://')))
                ? NetworkImage(user.profileImage!)
                : const AssetImage('assets/user_image.jpg') as ImageProvider,
            radius: 16.w,
            backgroundColor: AppTheme.white,
          ),
        ),
      ),
      shadowColor: AppTheme.black,
      actions: [
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.message),
          iconSize: 30.h,
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessagesScreen(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final ValueChanged<UserModel> onItemTap;

  const _SuggestionsList({required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (searchProvider.isLoading)
          const LinearProgressIndicator(minHeight: 2),
        Flexible(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: searchProvider.suggestions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final suggestion = searchProvider.suggestions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: (suggestion.profileImage != null &&
                          suggestion.profileImage!.isNotEmpty &&
                          (suggestion.profileImage!.startsWith('http://') ||
                              suggestion.profileImage!.startsWith('https://')))
                      ? NetworkImage(suggestion.profileImage!)
                      : const AssetImage('assets/user_image.jpg')
                          as ImageProvider,
                ),
                title: Text(
                  suggestion.userName,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () => onItemTap(suggestion),
              );
            },
          ),
        ),
      ],
    );
  }
}
