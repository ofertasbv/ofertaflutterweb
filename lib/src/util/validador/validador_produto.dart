class ValidadorProduto {
  String validateImages(List images) {
    if (images.isEmpty) return "Adicione imagens do produto";
    return null;
  }

  String validateNome(String text) {
    if (text.isEmpty) return "Preencha o nome do produto";
    return null;
  }

  String validateCodigoBarra(String text) {
    if (text.isEmpty) return "Preencha o código de barra do produto";
    return null;
  }

  String validateSKU(String text) {
    if (text.isEmpty) return "Preencha o SKU do produto";
    return null;
  }

  String validateDescricao(String text) {
    if (text.isEmpty) return "Preencha a descrição do produto";
    return null;
  }

  String validateQuantidade(String text) {
    int quantidade = int.tryParse(text);
    if (quantidade > 0 && quantidade < 1000)
      return "Preencha a quantidade do produto";
    return null;
  }

  String validatePreco(String text) {
    double price = double.tryParse(text);
    if (price != null) {
      if (!text.contains(".") || text.split(".")[1].length != 2)
        return "Utilize 2 casas decimais";
    } else {
      return "Preço inválido";
    }
    return null;
  }
}
