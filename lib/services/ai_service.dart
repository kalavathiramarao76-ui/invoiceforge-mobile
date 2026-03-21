import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://sai.sharedllm.com/v1/chat/completions';
  static const String _model = 'gpt-oss:120b';

  static Future<String> generate(String systemPrompt, String userPrompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.7,
          'max_tokens': 4096,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response generated.';
      } else {
        return 'Error: Server returned status ${response.statusCode}. Please try again.';
      }
    } catch (e) {
      return 'Error: Could not connect to AI service. Please check your connection and try again.';
    }
  }

  static Future<String> generateInvoice(String details) async {
    return generate(
      'You are an expert invoice generator. Create professional, detailed invoices with proper formatting including line items, totals, tax calculations, payment terms, and due dates. Use clean formatting with sections clearly separated.',
      'Generate a professional invoice based on the following details:\n\n$details',
    );
  }

  static Future<String> generateProposal(String details) async {
    return generate(
      'You are an expert business proposal writer. Create compelling, professional proposals that win clients. Include executive summary, scope of work, timeline, pricing, and terms. Use persuasive but professional language.',
      'Write a professional business proposal based on the following details:\n\n$details',
    );
  }

  static Future<String> generateContract(String details) async {
    return generate(
      'You are an expert contract drafting assistant. Create professional, comprehensive contracts with proper legal formatting including parties, scope, terms, payment, confidentiality, termination clauses, and signatures section.',
      'Draft a professional contract based on the following details:\n\n$details',
    );
  }
}
