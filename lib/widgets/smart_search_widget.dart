import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmartSearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final List<String> suggestions;
  final String hintText;

  const SmartSearchWidget({
    super.key,
    required this.onSearch,
    this.suggestions = const [],
    this.hintText = 'Buscar produtos...',
  });

  @override
  State<SmartSearchWidget> createState() => _SmartSearchWidgetState();
}

class _SmartSearchWidgetState extends State<SmartSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = widget.suggestions;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = widget.suggestions;
      });
    } else {
      setState(() {
        _filteredSuggestions = widget.suggestions
            .where((suggestion) =>
                suggestion.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _onSuggestionSelected(String suggestion) {
    _controller.text = suggestion;
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
    widget.onSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (value) {
              _filterSuggestions(value);
              setState(() {
                _showSuggestions = value.isNotEmpty;
              });
            },
            onSubmitted: (value) {
              widget.onSearch(value);
              setState(() {
                _showSuggestions = false;
              });
            },
            onTap: () {
              setState(() {
                _showSuggestions = _controller.text.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _showSuggestions = false;
                          _filteredSuggestions = widget.suggestions;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (_showSuggestions && _filteredSuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _filteredSuggestions.length > 5
                  ? 5
                  : _filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  leading: const Icon(Icons.search, size: 20),
                  title: Text(
                    suggestion,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () => _onSuggestionSelected(suggestion),
                  dense: true,
                );
              },
            ),
          ),
      ],
    );
  }
} 