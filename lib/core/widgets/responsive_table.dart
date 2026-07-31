import 'package:flutter/material.dart';

/// A single column's label plus how to render one row's cell for it.
class ResponsiveColumn<T> {
  const ResponsiveColumn({
    required this.label,
    required this.cellBuilder,
    this.numeric = false,
  });

  final String label;
  final Widget Function(BuildContext context, T item) cellBuilder;
  final bool numeric;
}

/// Renders [items] as a [DataTable] on wide layouts and as a column of
/// [Card]s on narrow ones, so admin list screens (products, categories, ...)
/// share one responsive breakpoint instead of each reimplementing it.
class ResponsiveTable<T> extends StatelessWidget {
  const ResponsiveTable({
    super.key,
    required this.items,
    required this.columns,
    required this.actionsBuilder,
    this.breakpoint = 800,
  });

  final List<T> items;
  final List<ResponsiveColumn<T>> columns;
  final Widget Function(BuildContext context, T item) actionsBuilder;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth >= breakpoint
            ? _buildTable(context)
            : _buildCards(context);
      },
    );
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          ...columns.map(
            (c) => DataColumn(label: Text(c.label), numeric: c.numeric),
          ),
          const DataColumn(label: Text('Actions')),
        ],
        rows: items.map((item) {
          return DataRow(
            cells: [
              ...columns.map((c) => DataCell(c.cellBuilder(context, item))),
              DataCell(actionsBuilder(context, item)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final column in columns)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 96,
                          child: Text(
                            column.label,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        Expanded(child: column.cellBuilder(context, item)),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: actionsBuilder(context, item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
