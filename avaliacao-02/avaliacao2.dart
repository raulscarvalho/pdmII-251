// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {'nome': _nome};
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  var dependente1 = Dependente("Carlos");
  var dependente2 = Dependente("Taveira");
  var dependente3 = Dependente("Gerúndio");
  var dependente4 = Dependente("Princípio");
  var dependente5 = Dependente("Judiciário");

  var funcionario1 = Funcionario("Infinitivo", [dependente1, dependente2]);
  var funcionario2 = Funcionario("Executivo", [dependente3, dependente4]);
  var funcionario3 = Funcionario("Joana Dark", [dependente5]);

  var listaFuncionarios = [funcionario1, funcionario2, funcionario3];

  var equipeProjeto = EquipeProjeto("projetoPlaya", listaFuncionarios);

  var jsonEquipe = jsonEncode(equipeProjeto.toJson());

  print(jsonEquipe);

  // 1. Criar varios objetos Dependentes
  // 2. Criar varios objetos Funcionario
  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios
  // 4. Criar uma lista de Funcionarios
  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  // 6. Printar no formato JSON o objeto Equipe Projeto.
}
