import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
    BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.warning),
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ActionButton(
                  actionText: "Không",
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  }),
            ),
            Expanded(
              child: ActionButton(
                  actionText: "Có",
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  }),
            ),
          ],
        ),
      ],
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.actionText,
    this.onPressed,
  });

  final String? actionText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        actionText ?? "Okay",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
            ),
      ),
    );
  }
}
