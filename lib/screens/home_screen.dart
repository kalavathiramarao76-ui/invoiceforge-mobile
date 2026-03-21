import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'invoice_creator_screen.dart';
import 'proposal_writer_screen.dart';
import 'contract_screen.dart';
import 'templates_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final tools = [
      {
        'icon': Icons.receipt_long_rounded,
        'title': 'Invoice Creator',
        'desc': 'Generate professional invoices with AI',
        'color': const Color(0xFF22c55e),
        'screen': const InvoiceCreatorScreen(),
      },
      {
        'icon': Icons.description_rounded,
        'title': 'Proposal Writer',
        'desc': 'Craft winning business proposals',
        'color': const Color(0xFF16a34a),
        'screen': const ProposalWriterScreen(),
      },
      {
        'icon': Icons.gavel_rounded,
        'title': 'Contract Drafter',
        'desc': 'Draft comprehensive contracts',
        'color': const Color(0xFF15803d),
        'screen': const ContractScreen(),
      },
      {
        'icon': Icons.dashboard_customize_rounded,
        'title': 'Templates',
        'desc': 'Browse & use document templates',
        'color': const Color(0xFF0d9488),
        'screen': const TemplatesScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0a0f0d),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'InvoiceForge',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        provider.userName.isNotEmpty
                            ? 'Welcome back, ${provider.userName}'
                            : 'AI Document Generator',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen())),
                    icon: const Icon(Icons.settings_rounded, color: Colors.white54),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF22c55e).withOpacity(0.15),
                      const Color(0xFF22c55e).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF22c55e).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: const Color(0xFF22c55e), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'AI-Powered',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF22c55e),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create invoices, proposals & contracts in seconds',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Describe what you need and let AI generate professional documents instantly.',
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.white54, height: 1.5),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              const SizedBox(height: 24),
              Text(
                'TOOLS',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white38,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(tools.length, (index) {
                final tool = tools[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => tool['screen'] as Widget)),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141f1a),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (tool['color'] as Color).withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: (tool['color'] as Color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(tool['icon'] as IconData,
                                color: tool['color'] as Color, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tool['title'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tool['desc'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: Colors.white24, size: 24),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (300 + index * 100).ms).slideX(begin: 0.1);
              }),
              const SizedBox(height: 24),
              if (provider.savedDocuments.isNotEmpty) ...[
                Text(
                  'RECENT DOCUMENTS',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white38,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                ...provider.savedDocuments.take(5).map((doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141f1a),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          doc['type'] == 'invoice'
                              ? Icons.receipt_long
                              : doc['type'] == 'proposal'
                                  ? Icons.description
                                  : Icons.gavel,
                          color: const Color(0xFF22c55e),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc['title'] ?? 'Untitled',
                                  style: GoogleFonts.inter(
                                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                              Text(doc['type']?.toUpperCase() ?? '',
                                  style: GoogleFonts.inter(
                                      color: Colors.white38, fontSize: 11, letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
