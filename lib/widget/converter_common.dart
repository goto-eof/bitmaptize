import 'package:bitmaptize/service/bitmap_to_data_file_converter.dart';
import 'package:bitmaptize/service/data_file_to_bitmap_converter.dart';
import 'package:bitmaptize/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum Action { convertToBmp, convertToData }

class ConvertCommon extends StatefulWidget {
  ConvertCommon(
      {super.key,
      required this.title,
      required this.description,
      required this.parentContext,
      required this.action});
  final String title;
  final String description;
  final Action action;
  BuildContext parentContext;
  @override
  State<StatefulWidget> createState() {
    return _ConvertCommonState();
  }
}

class _ConvertCommonState extends State<ConvertCommon> {
  String? _file;
  bool _processing = false;
  String? message;

  void _chooseFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        _file = result.files[0].path!;
      });
    }
  }

  Future<void> _process() async {
    if (widget.action == Action.convertToBmp) {
      setState(() {
        _processing = true;
      });
      DataFileToBitmapConverter converter = DataFileToBitmapConverter();
      await converter.convert(_file!, "$_file.bmp");
      setState(() {
        _processing = false;
      });
      _showDone();
      return;
    }
    if (widget.action == Action.convertToData) {
      setState(() {
        _processing = true;
      });
      BitmapToDataFileConverter converter = BitmapToDataFileConverter();
      await converter.convert(
          _file!, FileUtil.removeLastFileNameExtension(_file!));
      setState(() {
        _processing = false;
      });
      _showDone();
    }
  }

  void _showDone() {
    ScaffoldMessenger.of(widget.parentContext)
        .showSnackBar(const SnackBar(content: Text("Done!")));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromARGB(75, 120, 120, 120),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            color: Theme.of(context).secondaryHeaderColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: 600,
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Container(
                width: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FilledButton(
                          onPressed: _processing ? null : _chooseFile,
                          child: const Text(
                            "Choose a target file",
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(73, 115, 113, 113),
                            ),
                          ),
                          child: Text(
                            _file ?? 'no file selected',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            _processing
                                ? const CircularProgressIndicator()
                                : FilledButton(
                                    onPressed: () async {
                                      await _process();
                                    },
                                    child: const Text("Process"),
                                  ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
