import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

void main() {
  // Open or create the database file in current directory
  final dbPath = p.join(Directory.current.path, 'aluno.db');
  final db = sqlite3.open(dbPath);

  // Create the table TB_ALUNO if not exists
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(50) NOT NULL
    );
  ''');

  print('Banco de dados aberto em $dbPath');
  bool running = true;

  while (running) {
    print('\nEscolha uma opção:');
    print('1 - Inserir aluno');
    print('2 - Listar alunos');
    print('0 - Sair');
    stdout.write('Opção: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _inserirAluno(db);
        break;
      case '2':
        _listarAlunos(db);
        break;
      case '0':
        running = false;
        break;
      default:
        print('Opção inválida. Tente novamente.');
    }
  }

  db.dispose();
  print('Programa finalizado.');
}

void _inserirAluno(Database db) {
  stdout.write('Digite o nome do aluno (max 50 caracteres): ');
  String? nome = stdin.readLineSync();

  if (nome == null || nome.trim().isEmpty) {
    print('Nome inválido.');
    return;
  }

  if (nome.length > 50) {
    print('Nome ultrapassa 50 caracteres, truncando.');
    nome = nome.substring(0, 50);
  }

  final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?);');
  stmt.execute([nome]);
  stmt.dispose();

  print('Aluno "$nome" inserido com sucesso.');
}

void _listarAlunos(Database db) {
  final ResultSet result = db.select(
    'SELECT id, nome FROM TB_ALUNO ORDER BY id;',
  );

  if (result.isEmpty) {
    print('Nenhum aluno cadastrado.');
    return;
  }

  print('\nLista de Alunos:');
  for (final row in result) {
    print('ID: ${row['id']}, Nome: ${row['nome']}');
  }
}
