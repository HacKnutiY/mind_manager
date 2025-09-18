import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/constants.dart';
import 'package:mind_manager/entities/activity.dart';

import 'package:mind_manager/features/activities/models/new_note_model.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({
    super.key,
  });

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    isNewNote = arguments[0];
    activityKey = arguments[1];
    var activity =
        Hive.box<Activity>(Constants.activitiesBoxName).get(activityKey);
    noteIndex = isNewNote == false ? arguments[2] : null;


    noteNameController = TextEditingController(
        text: noteIndex != null
            ? activity?.notes![noteIndex!].name.toString()
            : "");
    noteTextController = TextEditingController(
        text: noteIndex != null
            ? activity?.notes![noteIndex!].text.toString()
            : "");

    _model = NewNoteModel(
        activityKey: activityKey ?? 1, isNewNote: isNewNote, noteIndex: noteIndex);
  }

  late NewNoteModel _model;

  late TextEditingController noteNameController;
  late TextEditingController noteTextController;

  int? activityKey;
  int? noteIndex;
  late bool isNewNote;
  @override
  Widget build(BuildContext context) {
    return NewNoteProvider(
      model: _model,
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            isNewNote
                ? _CancelNoteBtnWidget()
                : _DeleteNoteBtnWidget(noteIndex: noteIndex),
             Expanded(
              child: SizedBox(),
            ),
            TextButton(
              onPressed: () {
                _model.saveNote(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Сохранить заметку",
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
        body: _NewNoteScreenBody(
          noteNameController: noteNameController,
          noteTextController: noteTextController,
        ),
      ),
    ); //Provider
  }
}

class _DeleteNoteBtnWidget extends StatelessWidget {
  int? noteIndex;
  _DeleteNoteBtnWidget({super.key, required this.noteIndex});

  @override
  Widget build(BuildContext context) {
    final model = NewNoteProvider.read(context)?.model;
    return TextButton(
      onPressed: () {
        model?.deleteNote();
        Navigator.pop(context);
      },
      child: const Text(
        "Удалить заметку",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class _CancelNoteBtnWidget extends StatelessWidget {
  const _CancelNoteBtnWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "Отменить",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class _NewNoteScreenBody extends StatelessWidget {
  final TextEditingController noteNameController;
  final TextEditingController noteTextController;
  const _NewNoteScreenBody({
    super.key,
    required this.noteNameController,
    required this.noteTextController,
  });

  @override
  Widget build(BuildContext context) {
    NewNoteModel? _model = NewNoteProvider.read(context)?.model;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: noteNameController,
              autofocus: true,
              onChanged: (value) => _model?.name = value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Название заметки",
                  hintStyle: TextStyle(fontWeight: FontWeight.normal)),
            ),
            Expanded(
              child: TextField(
                controller: noteTextController,
                maxLines: null,
                minLines: null,
                onChanged: (value) => _model?.text = value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Введите заметку...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
