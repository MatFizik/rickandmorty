import 'package:flutter/material.dart';
import 'package:rickandmorty/common/models/filters_model.dart';
import 'package:rickandmorty/common/widgets/custom_checkbox.dart';

class CharactersFiltersBottomSheet extends StatefulWidget {
  final FiltersModel filters;

  const CharactersFiltersBottomSheet({
    super.key,
    required this.filters,
  });

  @override
  State<CharactersFiltersBottomSheet> createState() =>
      _CharactersFiltersBottomSheetState();
}

class _CharactersFiltersBottomSheetState
    extends State<CharactersFiltersBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.surface;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                const Text('STATUS'),
                const SizedBox(height: 16),
                _buildCheckbox('Alive', 'status'),
                _buildCheckbox('Dead', 'status'),
                _buildCheckbox('unknown', 'status'),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                const Text('GENDER'),
                const SizedBox(height: 16),
                _buildCheckbox('Male', 'gender'),
                _buildCheckbox('Female', 'gender'),
                _buildCheckbox('Genderless', 'gender'),
                _buildCheckbox('unknown', 'gender'),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(String title, String filterType) {
    bool isSelected = (filterType == 'status'
            ? widget.filters.status
            : widget.filters.gender) ==
        title;

    return CustomCheckBox(
      title: title,
      value: isSelected,
      onChange: () => setState(() {
        if (filterType == 'status') {
          widget.filters.status = isSelected ? '' : title;
        } else {
          widget.filters.gender = isSelected ? '' : title;
        }
      }),
    );
  }
}
