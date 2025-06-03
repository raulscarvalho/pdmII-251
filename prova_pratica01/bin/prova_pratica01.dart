import 'package:prova_pratica01/prova_pratica01.dart' as prova_pratica01;
import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Curso {
  int id;
  String descricao;

  List<Professor> professores = [];
  List<Aluno> alunos = [];
  List<Disciplina> disciplinas = [];

  Curso({required this.id, required this.descricao});

  void adicionarProfessor(Professor professor) {
    professores.add(professor);
  }

  void adicionarAluno(Aluno aluno) {
    alunos.add(aluno);
  }

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'professores': professores.map((p) => p.toJson()).toList(),
    'alunos': alunos.map((a) => a.toJson()).toList(),
    'disciplinas': disciplinas.map((d) => d.toJson()).toList(),
  };
}

class Professor {
  int id;
  String codigo;
  String nome;

  List<Disciplina> disciplinas = [];

  Professor({required this.id, required this.codigo, required this.nome});

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'codigo': codigo,
    'nome': nome,
    'disciplinas': disciplinas.map((d) => d.toJson()).toList(),
  };
}

class Aluno {
  int id;
  String nome;
  String matricula;

  Aluno({required this.id, required this.nome, required this.matricula});

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'matricula': matricula,
  };
}

class Disciplina {
  int id;
  String descricao;
  int qtdAulas;

  Disciplina({
    required this.id,
    required this.descricao,
    required this.qtdAulas,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'qtdAulas': qtdAulas,
  };
}

void main() async {
  // Inicialização dos objetos (igual antes)
  var matematica = Disciplina(id: 1, descricao: 'Matemática', qtdAulas: 40);
  var portugues = Disciplina(id: 2, descricao: 'Português', qtdAulas: 30);
  var historia = Disciplina(id: 3, descricao: 'História', qtdAulas: 25);

  var profJoao = Professor(id: 1, codigo: 'P001', nome: 'João Silva');
  var profMaria = Professor(id: 2, codigo: 'P002', nome: 'Maria Souza');

  profJoao.adicionarDisciplina(matematica);
  profMaria.adicionarDisciplina(portugues);
  profMaria.adicionarDisciplina(historia);

  var alunoAna = Aluno(id: 1, nome: 'Ana Lima', matricula: 'M1001');
  var alunoCarlos = Aluno(id: 2, nome: 'Carlos Pereira', matricula: 'M1002');

  var curso = Curso(id: 1, descricao: 'Curso de Ensino Médio');

  curso.adicionarProfessor(profJoao);
  curso.adicionarProfessor(profMaria);

  curso.adicionarAluno(alunoAna);
  curso.adicionarAluno(alunoCarlos);

  curso.adicionarDisciplina(matematica);
  curso.adicionarDisciplina(portugues);
  curso.adicionarDisciplina(historia);

  // Converter para JSON string
  String jsonString = jsonEncode(curso.toJson());

  // Salvar em arquivo
  final file = File('curso.json');
  await file.writeAsString(jsonString);

  print(jsonString);

  // Configura as credenciais SMTP do Gmail
  final smtpServer = gmail(
    'raul.carvalho16@aluno.ifce.edu.br',
    'ztuj umrg emku qgxv',
  );

  // Cria uma mensagem de e-mail
  final message =
      Message()
        ..from = Address(
          'raul.carvalho16@aluno.ifce.edu.br',
          'Raúl Simioni de Carvalho',
        )
        ..recipients.add('taveira@ifce.edu.br')
        ..subject = 'Prova prática EMAIL JSON '
        ..text = jsonString;

  try {
    // Envia o e-mail usando o servidor SMTP do Gmail
    final sendReport = await send(message, smtpServer);

    // Exibe o resultado do envio do e-mail
    print('E-mail enviado: ${sendReport}');
  } on MailerException catch (e) {
    // Exibe informações sobre erros de envio de e-mail
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}
