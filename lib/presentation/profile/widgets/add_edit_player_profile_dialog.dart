import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/player_use_cases/create_or_update_player_use_case.dart';
import 'package:jugaenequipo/datasources/games_use_cases/search_games_use_case.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/game_image_helper.dart';
import 'package:uuid/uuid.dart';

class AddEditPlayerProfileDialog extends StatefulWidget {
  final PlayerModel? player; // null for new player, non-null for editing
  final VoidCallback? onSaved;

  const AddEditPlayerProfileDialog({
    super.key,
    this.player,
    this.onSaved,
  });

  @override
  State<AddEditPlayerProfileDialog> createState() =>
      _AddEditPlayerProfileDialogState();
}

class _AddEditPlayerProfileDialogState
    extends State<AddEditPlayerProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingGames = false;
  List<GameModel> _games = [];
  GameModel? _selectedGame;

  // Account data fields
  final _steamIdController = TextEditingController();
  final _riotUsernameController = TextEditingController();
  final _riotTagController = TextEditingController();
  final _riotRegionController = TextEditingController();

  // Account type: 'steam' or 'riot'
  String _accountType = 'steam';

  @override
  void initState() {
    super.initState();
    _loadGames();
    if (widget.player != null) {
      // Editing existing player
      _selectedGame = GameModel(
        id: widget.player!.gameId,
        name: widget.player!.gameName,
      );
      _steamIdController.text = widget.player!.accountData.steamId ?? '';
      _riotUsernameController.text = widget.player!.accountData.username ?? '';
      _riotTagController.text = widget.player!.accountData.tag ?? '';
      _riotRegionController.text = widget.player!.accountData.region ?? '';

      // Determine account type
      if (widget.player!.accountData.steamId != null &&
          widget.player!.accountData.steamId!.isNotEmpty) {
        _accountType = 'steam';
      } else if (widget.player!.accountData.username != null &&
          widget.player!.accountData.username!.isNotEmpty) {
        _accountType = 'riot';
      }
    }
  }

  @override
  void dispose() {
    _steamIdController.dispose();
    _riotUsernameController.dispose();
    _riotTagController.dispose();
    _riotRegionController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoadingGames = true;
    });

    try {
      final games = await searchGames();
      if (games != null) {
        setState(() {
          _games = games;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading games: $e');
      }
    } finally {
      setState(() {
        _isLoadingGames = false;
      });
    }
  }

  Future<void> _savePlayer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGame == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un juego'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create AccountData
      AccountData accountData;
      if (_accountType == 'steam') {
        accountData = AccountData(
          steamId: _steamIdController.text.trim().isNotEmpty
              ? _steamIdController.text.trim()
              : null,
        );
      } else {
        accountData = AccountData(
          username: _riotUsernameController.text.trim().isNotEmpty
              ? _riotUsernameController.text.trim()
              : null,
          tag: _riotTagController.text.trim().isNotEmpty
              ? _riotTagController.text.trim()
              : null,
          region: _riotRegionController.text.trim().isNotEmpty
              ? _riotRegionController.text.trim()
              : null,
        );
      }

      // Use existing player ID or generate new UUID
      final playerId = widget.player?.id ?? const Uuid().v4();

      final result = await createOrUpdatePlayer(
        playerId: playerId,
        gameId: _selectedGame!.id,
        accountData: accountData,
      );

      if (result == Result.success) {
        if (widget.onSaved != null) {
          widget.onSaved!();
        }
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.player == null
                  ? 'Perfil de juego agregado exitosamente'
                  : 'Perfil de juego actualizado exitosamente'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al guardar el perfil de juego'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error saving player: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar el perfil de juego'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 400.w,
        ),
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.player == null
                          ? 'Agregar Perfil de Juego'
                          : 'Editar Perfil de Juego',
                      style: TextStyle(
                        fontSize: 20.h,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Game selection
              Text(
                'Juego *',
                style: TextStyle(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              _isLoadingGames
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<GameModel>(
                      value: _selectedGame,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      hint: const Text('Selecciona un juego'),
                      items: _games.map((game) {
                        return DropdownMenuItem<GameModel>(
                          value: game,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: GameImageHelper.buildGameImage(
                                  gameName: game.name,
                                  width: 32.w,
                                  height: 32.h,
                                  defaultIcon: Icons.sports_esports,
                                  defaultIconSize: 20.h,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Flexible(
                                child: Text(
                                  game.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (game) {
                        setState(() {
                          _selectedGame = game;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona un juego';
                        }
                        return null;
                      },
                    ),
              SizedBox(height: 20.h),

              // Account type selection
              Text(
                'Tipo de Cuenta',
                style: TextStyle(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Steam'),
                      value: 'steam',
                      groupValue: _accountType,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('RIOT'),
                      value: 'riot',
                      groupValue: _accountType,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Account data fields
              if (_accountType == 'steam') ...[
                TextFormField(
                  controller: _steamIdController,
                  decoration: InputDecoration(
                    labelText: 'Steam ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: _riotUsernameController,
                  decoration: InputDecoration(
                    labelText: 'Username (RIOT)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _riotTagController,
                        decoration: InputDecoration(
                          labelText: 'Tag (RIOT)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextFormField(
                        controller: _riotRegionController,
                        decoration: InputDecoration(
                          labelText: 'Región',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 24.h),

              // Save button
              ElevatedButton(
                onPressed: _isLoading ? null : _savePlayer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.player == null ? 'Agregar' : 'Guardar',
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
