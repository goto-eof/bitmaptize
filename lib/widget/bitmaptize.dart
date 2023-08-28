import 'package:bitmaptize/widget/about_dialog.dart' as AboutDialog;
import 'package:bitmaptize/widget/converter_common.dart' as ConverterCommon;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Bitmaptize extends StatefulWidget {
  const Bitmaptize({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BitmaptizeState();
  }
}

class _BitmaptizeState extends State<Bitmaptize> {
  late PackageInfo packageInfo;

  Future<void> _initInstances() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  void initState() {
    super.initState();
    _initInstances();
  }

  Widget _aboutDialogBuilder(BuildContext context) {
    return AboutDialog.AboutDialog(
      applicationName: "Bitmaptize",
      applicationSnapName: "bitmaptize",
      applicationIcon: Image.asset("assets/images/icon.png"),
      applicationVersion: packageInfo.version,
      applicationLegalese: "MIT",
      applicationDeveloper: "Andrei Dodu",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: Icon(Icons.file_copy),
                    text: "Wrap Data inside a BMP file"),
                Tab(
                  icon: Icon(Icons.image),
                  text: "Extract data from a BMP file",
                ),
              ],
            ),
            title: Row(
              children: [
                Image.asset("assets/images/icon.png"),
                const SizedBox(
                  width: 5,
                ),
                const Text('Bitmaptize'),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return _aboutDialogBuilder(ctx);
                      },
                    );
                  },
                  icon: const Icon(Icons.info),
                ),
              ],
            ),
          ),
          body: TabBarView(
            clipBehavior: Clip.none,
            children: [
              ConverterCommon.ConvertCommon(
                title: "Wrap Data file inside a BMP file",
                description:
                    "Wraps a data file into a BMP file (maximum size allowed is 100Mb). Choose the file that you want to wrap into a Bitmap file and press on 'Process' button. Once the processing operation is finished, a new file will appear in the same directory of your target file which will have the same name and the '.bmp' extension.",
                key: const ValueKey("data_to_bmp"),
                action: ConverterCommon.Action.convertToBmp,
                parentContext: context,
              ),
              ConverterCommon.ConvertCommon(
                  title: "Extract Data file from a BMP file",
                  description:
                      "Extracts from BMP file the original file and saves it. The maximum target file size is 100Mb. Chose the file that you wrapped in a BMP file and press on 'Process' button. A new file will be created in the directory of the target file that will contain the same name as the target file and the extension of the original file.",
                  parentContext: context,
                  key: const ValueKey("bmp_to_data"),
                  action: ConverterCommon.Action.convertToData),
            ],
          ),
        ),
      ),
    );
  }
}
