import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/note.dart';
import 'package:mind_manager/features/activities/models/activity_model.dart';
import 'package:mind_manager/features/activities/models/note_model.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late int activityKey;
  late bool isNewNote;
  late Note? note;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ActivityScreenConfiguration arguments = ModalRoute.of(context)!
        .settings
        .arguments as ActivityScreenConfiguration;
    isNewNote = arguments.isNewNote;
    activityKey = arguments.activityKey;
    note = arguments.note;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewNoteModel(
        activityKey: activityKey,
        isNewNote: isNewNote,
        note: note,
      ),
      child: const _NoteScreenStateBody(),
    );
  }
}

class _NoteScreenStateBody extends StatelessWidget {
  const _NoteScreenStateBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          context.read<NewNoteModel>().isNewNote
              ? const _CancelNoteBtnWidget()
              : _DeleteNoteBtnWidget(),
          const Expanded(
            child: SizedBox(),
          ),
          TextButton(
            onPressed: () {
              context.read<NewNoteModel>().saveNote(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Сохранить заметку",
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: const _NewNoteScreenBody(),
    );
  }
}

class _DeleteNoteBtnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = context.read<NewNoteModel>();
    return TextButton(
      onPressed: () {
        model.deleteNote();
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
  const _CancelNoteBtnWidget();

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
  const _NewNoteScreenBody();

  @override
  Widget build(BuildContext context) {
    NewNoteModel model = context.read<NewNoteModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: TextEditingController(text: model.name.toString()),
              autofocus: true,
              onChanged: (value) => model.name = value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Название заметки",
                  hintStyle: TextStyle(fontWeight: FontWeight.normal)),
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: model.text.toString()),
                maxLines: null,
                minLines: null,
                onChanged: (value) => model.text = value,
                decoration: const InputDecoration(
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
