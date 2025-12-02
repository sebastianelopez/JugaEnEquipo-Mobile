import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/utils/validator.dart';

class PasswordRequirements extends StatelessWidget {
  final String password;
  final bool isVisible;

  const PasswordRequirements({
    super.key,
    required this.password,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    final strength = Validators.checkPasswordStrength(password);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.passwordRequirementsTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          _RequirementItem(
            isValid: strength.minLength,
            text: AppLocalizations.of(context)!.validationPasswordMinLength,
          ),
          SizedBox(height: 4.h),
          _RequirementItem(
            isValid: strength.hasUpperCase,
            text: AppLocalizations.of(context)!.validationPasswordHasUpperCase,
          ),
          SizedBox(height: 4.h),
          _RequirementItem(
            isValid: strength.hasLowerCase,
            text: AppLocalizations.of(context)!.validationPasswordHasLowerCase,
          ),
          SizedBox(height: 4.h),
          _RequirementItem(
            isValid: strength.hasNumber,
            text: AppLocalizations.of(context)!.validationPasswordHasNumber,
          ),
          SizedBox(height: 4.h),
          _RequirementItem(
            isValid: strength.hasSpecialChar,
            text: AppLocalizations.of(context)!.validationPasswordHasSpecialChar,
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final bool isValid;
  final String text;

  const _RequirementItem({
    required this.isValid,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          size: 16.sp,
          color: isValid
              ? Colors.green
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              color: isValid
                  ? Colors.green
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              decoration: isValid ? TextDecoration.none : null,
            ),
          ),
        ),
      ],
    );
  }
}

