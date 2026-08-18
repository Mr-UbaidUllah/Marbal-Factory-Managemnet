import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_status.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';

class QuotationsPage extends StatefulWidget {
  const QuotationsPage({super.key});

  @override
  State<QuotationsPage> createState() => _QuotationsPageState();
}

class _QuotationsPageState extends State<QuotationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuoteBloc>().add(const LoadQuotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<QuoteBloc>().add(const LoadQuotes(refresh: true)),
          ),
        ],
      ),
      body: BlocBuilder<QuoteBloc, QuoteState>(
        builder: (context, state) {
          if (state.status == QuoteStatusState.loading && state.quotes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == QuoteStatusState.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          if (state.quotes.isEmpty) {
            return const Center(child: Text('No quotations found.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search quotes...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<QuoteBloc>().add(SearchQuotes(value));
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.quotes.length,
                  itemBuilder: (context, index) {
                    final quote = state.quotes[index];
                    return _QuoteListItem(quote: quote);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuoteListItem extends StatelessWidget {
  final Quote quote;

  const _QuoteListItem({required this.quote});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => context.go('/dashboard/quotations/${quote.id}'),
      title: 'Quotation',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  quote.quoteNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _StatusChip(status: quote.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Customer: ${quote.requesterName}'),
            Text('Phone: ${quote.requesterPhone}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items: ${quote.items.length}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(quote.createdAt)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (quote.status == QuoteStatus.quoted || quote.status == QuoteStatus.accepted) ...[
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: SAR ${quote.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final QuoteStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case QuoteStatus.pending:
        color = Colors.orange;
        break;
      case QuoteStatus.underReview:
        color = Colors.blue;
        break;
      case QuoteStatus.quoted:
        color = Colors.purple;
        break;
      case QuoteStatus.accepted:
        color = Colors.green;
        break;
      case QuoteStatus.rejected:
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status.name,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
