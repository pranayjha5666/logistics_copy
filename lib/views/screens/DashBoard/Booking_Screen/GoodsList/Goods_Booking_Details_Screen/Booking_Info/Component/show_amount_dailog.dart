import 'package:flutter/material.dart';
import 'package:logistics/services/input_decoration.dart';
import 'package:logistics/views/base/common_button.dart';

class ShowAmountDailog extends StatefulWidget {
  final int remainingamount;
  const ShowAmountDailog({super.key, required this.remainingamount});

  @override
  State<ShowAmountDailog> createState() => _ShowAmountDailogState();
}

class _ShowAmountDailogState extends State<ShowAmountDailog> {
  final TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter Amount",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: Theme.of(context).textTheme.labelLarge,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: CustomDecoration.inputDecoration(
                    label: "Amount",
                    borderColor: Colors.grey.shade400,
                    borderRadius: 8,
                    labelStyle:
                        Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey[500]),
                  ),
                  validator: (value) {
                    final amount = int.tryParse(value ?? '');
                    if (amount == null || amount <= 0) {
                      return "Please enter a valid amount";
                    }
                    if (amount > widget.remainingamount) {
                      return "Amount cannot be more than ₹${widget.remainingamount}";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomButton(
                        type: ButtonType.secondary,
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop(amountController.text);
                          }
                        },
                        title: "Pay",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
