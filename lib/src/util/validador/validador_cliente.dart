class ValidadorCliente {
  String validateEmail(String text) {
    if (text.isEmpty) {
      return "preencha o valor com email";
    }
    if (!text.contains("@")) {
      return "email inválido";
    }
  }

  String validateSenha(String text) {
    if (text.isEmpty) {
      return "preencha o valor com senha";
    }
    if (text.length < 4) {
      return "a senha deve ter 4 caracteres";
    }
  }
}
