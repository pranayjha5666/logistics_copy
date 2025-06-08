import 'package:flutter/material.dart';

import '../../../../../services/input_decoration.dart';

class SelectStateDialogue extends StatefulWidget {
  final List<dynamic> allStates;
  final Function(Map<String, dynamic>) onStateSelected;

  const SelectStateDialogue({
    Key? key,
    required this.allStates,
    required this.onStateSelected,
  }) : super(key: key);

  @override
  State<SelectStateDialogue> createState() => _SelectStateDialogueState();
}

class _SelectStateDialogueState extends State<SelectStateDialogue> {
  late List<dynamic> filteredStates;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    filteredStates = List.from(widget.allStates);
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select State"),
          const SizedBox(height: 10),
          TextFormField(
            controller: searchController,
            // autofocus: true,
            decoration: CustomDecoration.inputDecoration(
              hint: 'Search state...',
              icon: Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                filteredStates = widget.allStates
                    .where((state) => state['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              });
            },
          ),
        ],
      ),
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: filteredStates.isEmpty
            ? const Center(child: Text("No states found"))
            : ListView.builder(
                itemCount: filteredStates.length,
                itemBuilder: (context, index) {
                  final state = filteredStates[index];
                  return ListTile(
                    title: Text(state['name']),
                    onTap: () async {
                     await Future.delayed(Duration(milliseconds: 100), () {
                        FocusScope.of(context).unfocus();
                        widget.onStateSelected(state);
                        Navigator.pop(context);
                     });

                    },
                  );
                },
              ),
      ),
    );
  }
}
