import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

main() async {
  // Configura as credenciais SMTP do Gmail
  final smtpServer = gmail('raul.carvalho16@aluno.ifce.edu.br', 'senha');

  // Cria uma mensagem de e-mail
  final message =
      Message()
        ..from = Address(
          'raul.carvalho16@aluno.ifce.edu.br',
          'Raúl Simioni de Carvalho',
        )
        ..recipients.add('pestebubonika5001@gmail.com')
        ..subject = 'Teste SMTP dart'
        ..text = 'Essa mensagem é um teste da avaliação 05 de dart';

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
