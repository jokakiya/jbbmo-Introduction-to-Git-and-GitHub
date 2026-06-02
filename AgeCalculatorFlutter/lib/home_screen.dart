import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'age_result.dart';

enum AgeUnit { years, months, days }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _dob = DateTime.now().subtract(const Duration(days: 365 * 25));
  AgeUnit _unit = AgeUnit.years;
  AgeResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    setState(() => _result = AgeResult.calculate(_dob));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime.now(),
      helpText: 'Select date of birth',
    );
    if (picked != null && picked != _dob) {
      setState(() => _dob = picked);
      _calculate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Column(
                children: [
                  Icon(Icons.calendar_month_rounded,
                      size: 56, color: scheme.primary),
                  const SizedBox(height: 8),
                  Text('Age Calculator',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 28),

              // DOB picker card
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(
                        icon: Icons.person_rounded, text: 'Date of Birth'),
                    const SizedBox(height: 12),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: scheme.primary, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_calendar_rounded,
                                color: scheme.primary),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat('MMMM d, yyyy').format(_dob),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Unit picker card
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(
                        icon: Icons.straighten_rounded, text: 'Show Age In'),
                    const SizedBox(height: 12),
                    SegmentedButton<AgeUnit>(
                      segments: const [
                        ButtonSegment(
                            value: AgeUnit.years, label: Text('Years')),
                        ButtonSegment(
                            value: AgeUnit.months, label: Text('Months')),
                        ButtonSegment(
                            value: AgeUnit.days, label: Text('Days')),
                      ],
                      selected: {_unit},
                      onSelectionChanged: (s) =>
                          setState(() => _unit = s.first),
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Primary result card
              if (_result != null) ...[
                _ResultCard(result: _result!, unit: _unit),
                const SizedBox(height: 16),
                _BreakdownCard(result: _result!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final AgeResult result;
  final AgeUnit unit;

  const _ResultCard({required this.result, required this.unit});

  int get _value => switch (unit) {
        AgeUnit.years => result.years,
        AgeUnit.months => result.totalMonths,
        AgeUnit.days => result.totalDays,
      };

  String get _label {
    final v = _value;
    return switch (unit) {
      AgeUnit.years => v == 1 ? 'Year' : 'Years',
      AgeUnit.months => v == 1 ? 'Month' : 'Months',
      AgeUnit.days => v == 1 ? 'Day' : 'Days',
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _Card(
      child: Column(
        children: [
          Text('You are',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$_value',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: scheme.primary,
                height: 1,
              ),
            ),
          ),
          Text(_label,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('old',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final AgeResult result;

  const _BreakdownCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(icon: Icons.bar_chart_rounded, text: 'Breakdown'),
          const SizedBox(height: 12),
          Row(
            children: [
              _BreakdownChip(
                  value: result.years,
                  label: result.years == 1 ? 'Year' : 'Years',
                  color: Colors.blue),
              const SizedBox(width: 10),
              _BreakdownChip(
                  value: result.months,
                  label: result.months == 1 ? 'Month' : 'Months',
                  color: Colors.green),
              const SizedBox(width: 10),
              _BreakdownChip(
                  value: result.days,
                  label: result.days == 1 ? 'Day' : 'Days',
                  color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownChip extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _BreakdownChip(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SectionLabel({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
