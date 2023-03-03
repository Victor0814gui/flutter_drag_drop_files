import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cross_file/cross_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Wrap(
          direction: Axis.horizontal,
          runSpacing: 8,
          spacing: 8,
          children: const [
            ExampleDragTarget(),
          ],
        ),
        
        drawer: const Drawer(
          width: 240,
          child:  NavigationDrawer(
               children: <Widget>[
                 Text('Headline'), // This doesn't have index.
                 NavigationDrawerDestination(
                   // This is destination index 0.
                   icon: Icon(Icons.surfing),
                   label: Text('Surfing'),
                 ),
                 NavigationDrawerDestination(
                   // This is destination index 1.
                   icon: Icon(Icons.support),
                   label: Text('Support'),
                 ),
                 NavigationDrawerDestination(
                   // This is destination index 2.
                   icon: Icon(Icons.local_hospital),
                   label: Text('Hospital'),
                 ),
               ]
             ),
        ),
      ),
    );
  }
}

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  _ExampleDragTargetState createState() => _ExampleDragTargetState();
}

class _ExampleDragTargetState extends State<ExampleDragTarget> {
  final List<XFile> _list = [];

  bool _dragging = false;

  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        setState(() {
          _list.addAll(detail.files);
        });

        debugPrint('onDragDone:');
        for (final file in detail.files) {
          debugPrint('  ${file.path} ${file.name}'
              '  ${await file.lastModified()}'
              '  ${await file.length()}'
              '  ${file.mimeType}');
        }
      },
      onDragUpdated: (details) {
        setState(() {
          offset = details.localPosition;
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
          offset = detail.localPosition;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
          offset = null;
        });
      },
      child: Center(
        child: Container(
          height: 600,
          width: 600,
          decoration: BoxDecoration(
            border: Border.all(
              color: _dragging ? Colors.deepPurple.shade400 : Colors.black26,
              width: _dragging ? 3 : 1,
            ),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Stack(
            children: [
              if (_list.isEmpty)
                const Center(child: Text("Drop here"))
              else
              ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: FilledButton.tonal(
                      onPressed: (){},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_list[index].name),
                          Text(_list[index].path),
                        ],
                      ),
                    ),
                  );
                }
              ),
              if (offset != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurple.shade400,
                        width: 2,
                      ),
                      color: Colors.deepOrange.shade400
                    ),
                    child: Text(
                      '$offset',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                ),
            ],
          ),
        ),
      ),
    );
  }
}