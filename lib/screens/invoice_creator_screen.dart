import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class InvoiceCreatorScreen extends StatefulWidget {
  const InvoiceCreatorScreen({super.key});

  @override
  State<InvoiceCreatorScreen> createState() => _InvoiceCreatorScreenState();
}

class _InvoiceCreatorScreenState extends State<InvoiceCreatorScreen> {
  final _clientController = TextEditingController();
  final _servicesController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _generate() async {
    if (_clientController.text.isEmpty || _servicesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in client name and services')),
      );
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Client: ${_clientController.text}
Services: ${_servicesController.text}
Amount/Rate: ${_amountController.text.isNotEmpty ? _amountController.text : 'Suggest appropriate pricing'}
Additional Notes: ${_notesController.text}
''';
    final response = await AIService.generateInvoice(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) {
      context.read<AppProvider>().addDocument('invoice', 'Invoice - ${_clientController.text}', response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0f0d),
      appBar: AppBar(
        title: Text('Invoice Creator', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF22c55e).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF22c55e).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: const Color(0xFF22c55e)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Describe your invoice details and AI will generate a professional document.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 24),
            _buildLabel('Client Name *'),
            const SizedBox(height: 8),
            TextField(
              controller: _clientController,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: const InputDecoration(hintText: 'e.g., Acme Corporation'),
            ),
            const SizedBox(height: 20),
            _buildLabel('Services / Items *'),
            const SizedBox(height: 8),
            TextField(
              controller: _servicesController,
              style: GoogleFonts.inter(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'e.g., Web development - 40 hours, UI design - 20 hours',
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Amount / Rate'),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: const InputDecoration(hintText: 'e.g., \$150/hour or \$5,000 total'),
            ),
            const SizedBox(height: 20),
            _buildLabel('Additional Notes'),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              style: GoogleFonts.inter(color: Colors.white),
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Payment terms, due date, etc.'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: _loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Icon(Icons.auto_awesome),
                label: Text(_loading ? 'Generating...' : 'Generate Invoice'),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Generated Invoice'),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Share.share(_result),
                        icon: const Icon(Icons.share_rounded, color: Color(0xFF22c55e), size: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invoice copied to clipboard')),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, color: Color(0xFF22c55e), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141f1a),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF22c55e).withOpacity(0.2)),
                ),
                child: SelectableText(
                  _result,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.9), height: 1.6),
                ),
              ).animate().fadeIn().slideY(begin: 0.05),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
    );
  }
}
