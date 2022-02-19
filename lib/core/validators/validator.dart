class CustomValidator {
  final String errorText;
  final bool Function(String) showTextError;

  CustomValidator({
    required this.errorText,
    required this.showTextError,
  });
}
