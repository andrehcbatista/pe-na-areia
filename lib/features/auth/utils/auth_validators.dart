String? requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Preencha este campo';
  }
  return null;
}

String? emailValidator(String? value) {
  final requiredError = requiredValidator(value);
  if (requiredError != null) {
    return requiredError;
  }

  final email = value!.trim();
  if (!email.contains('@') || !email.contains('.')) {
    return 'Informe um e-mail válido';
  }
  return null;
}

String? passwordValidator(String? value) {
  final requiredError = requiredValidator(value);
  if (requiredError != null) {
    return requiredError;
  }

  if (value!.trim().length < 6) {
    return 'Use pelo menos 6 caracteres';
  }
  return null;
}
