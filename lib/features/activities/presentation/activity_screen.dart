import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../models/activity_model.dart';

class ActivitiyScreen extends StatefulWidget {
  final int activityKey;
  const ActivitiyScreen({required this.activityKey});
  @override
  State<ActivitiyScreen> createState() => _ActivitiyScreenState();
}

class _ActivitiyScreenState extends State<ActivitiyScreen> {
  @override
  void initState() {
    super.initState();
    activityKey = widget.activityKey;
    _model = ActivityModel(activityKey: activityKey);
  }


  late int activityKey;
  ActivityModel? _model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          activeIcon: Icons.add,
          icon: Icons.add,
          animatedIcon: AnimatedIcons.menu_close,
          children: <SpeedDialChild>[
            SpeedDialChild(
              onTap: () {
                _model?.toNewNoteScreen(context,
                    activityKey: activityKey, isNewNote: true);
              },
              child: Icon(Icons.notes_rounded),
              label: "Заметка",
            ),
            SpeedDialChild(
              onTap: () {},
              child: Icon(Icons.sports_score),
              label: "Долгосрочная цель",
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(_model!.activity?.name ?? "Said"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActivityProvider(
            notifier: _model!,
            child: _ActivityBodyWidget(),
          ),
        ));
  }
}

class _ActivityBodyWidget extends StatelessWidget {
  const _ActivityBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = ActivityProvider.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 170,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: const [
              LongTimeGoalTileWidget(),
              LongTimeGoalTileWidget(),
              LongTimeGoalTileWidget(),
              LongTimeGoalTileWidget(),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          child: Text("Updateeee"),
          onTap: model?.notLis,
        ),
        const Text(
          "Заметки",
          style: TextStyle(fontSize: 18),
        ),
        NotesList(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: const ButtonStyle(
              padding:
                  WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            onPressed: () {
              model?.deleteActivity();
              Navigator.pop(context);
            },
            child: const Text(
              "Удалить направление",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel? model = ActivityProvider.watch(context);

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: model?.activityNotes.length ?? 0,
        itemBuilder: (context, index) => NoteTileWidget(
          noteName: model!.activityNotes[index].name ?? "Неизвестная заметка",
          noteIndex: index,
        ),
      ),
    );
  }
}

class LongTimeGoalTileWidget extends StatelessWidget {
  const LongTimeGoalTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            width: 350,
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Написать проект N, используя технологии Y. Закинуть на GH",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Срок: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "до 24.11.2035"),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Статус: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "Не выполнена"),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Актуальность: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "Активная цель"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Удалить"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Завершить"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}

class NoteTileWidget extends StatelessWidget {
  final String noteName;
  int noteIndex;

  NoteTileWidget({super.key, required this.noteName, required this.noteIndex});

  @override
  Widget build(BuildContext context) {
    var model = ActivityProvider.read(context)?.notifier;
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => {
          model?.toNoteScreen(context, noteIndex: noteIndex, isNewNote: false)
        },
        child: Text(noteName),
      ),
    );
  }
}
