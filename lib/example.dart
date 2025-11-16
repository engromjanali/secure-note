import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dismissible Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DismissibleExample(),
    );
  }
}

class DismissibleExample extends StatefulWidget {
  const DismissibleExample({super.key});

  @override
  State<DismissibleExample> createState() => _DismissibleExampleState();
}

class _DismissibleExampleState extends State<DismissibleExample> {
  final List<String> _items = List.generate(10, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dismissible Widget Demo")),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Dismissible(
            key: ValueKey(item), // 🧠 Must be unique
            direction: DismissDirection.horizontal, // both sides allowed
            resizeDuration: const Duration(
              milliseconds: 300,
            ), // shrink animation speed
            movementDuration: const Duration(
              milliseconds: 200,
            ), // swipe animation speed

            confirmDismiss: (direction) async {
              // 🧭 Before dismiss — decide what to do
              if (direction == DismissDirection.startToEnd) {
                // Left to right
                final confirm = await _confirmDialog(context, "Mark as Done?");
                return confirm;
              } else if (direction == DismissDirection.endToStart) {
                // Right to left
                // Navigate instead of deleting
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(data: item)),
                );
                return false; // prevent dismissal
              }
              return false;
            },

            onDismissed: (direction) {
              // 🗑 Called after confirmed dismiss
              setState(() {
                _items.removeAt(index);
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$item dismissed")));
            },

            onResize: () {
              // ⚙️ Called when widget is shrinking
              debugPrint("Resizing $item");
            },

            onUpdate: (details) {
              // 📈 Called during swipe gesture
              debugPrint(
                "Swipe progress: ${details.progress} direction: ${details.direction}",
              );
            },

            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.done, color: Colors.white),
            ),

            secondaryBackground: Container(
              color: Colors.blue,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.open_in_new, color: Colors.white),
            ),

            dismissThresholds: const {
              DismissDirection.startToEnd: 0.4,
              DismissDirection.endToStart: 0.4,
            },

            crossAxisEndOffset: 0.5, // pushes dismissed item up/down at end

            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(item),
                subtitle: const Text("Swipe left to open, right to delete"),
                leading: const Icon(Icons.list),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _confirmDialog(BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class DetailPage extends StatelessWidget {
  final String data;
  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details Page")),
      body: Center(
        child: Text(
          "You swiped to open: $data",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
