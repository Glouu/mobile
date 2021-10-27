import 'package:flutter/material.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/toggle_widget.dart';

class Bottle extends StatefulWidget {
  const Bottle({Key? key}) : super(key: key);

  @override
  _BottleState createState() => _BottleState();
}

class _BottleState extends State<Bottle> {
  final FocusNode toggleNode = FocusNode();

  late bool allowBottleMessages;
  bool isLoading = true;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    var isAllowBottleMessages =
        await secureStorage.readSecureData('isAllowBottleMessages');
    setState(() {
      if (isAllowBottleMessages != null) {
        if (isAllowBottleMessages == 'true') {
          allowBottleMessages = true;
        } else {
          allowBottleMessages = false;
        }
      } else {
        allowBottleMessages = true;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Bottle messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(15),
              children: [
                buildMenuItem(
                  text: 'allow bottle messages',
                  onToggleChanged: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                        'isAllowBottleMessages',
                        value.toString(),
                      );
                    });
                  },
                  value: allowBottleMessages,
                )
              ],
            ),
    );
  }

  Widget buildMenuItem({
    required String text,
    bool value = false,
    double toggleSize = 1,
    double textSize = 16,
    required ValueChanged onToggleChanged,
  }) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize,
        ),
      ),
      trailing: ToggleWidget(
        value: value,
        onChanged: onToggleChanged,
        sizeNumber: toggleSize,
        toggleNode: toggleNode,
      ),
    );
  }
}
