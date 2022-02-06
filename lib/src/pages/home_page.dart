import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:api_to_sqlite/src/providers/language_api_provider.dart';
import 'package:api_to_sqlite/src/models/language_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.blue[500],
          backgroundColor: const Color(0xff5086c1),
          title: const Text('Programming Languages'),
          centerTitle: true),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildLanguageListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff000000),
        //Floating action button on Scaffold
        onPressed: () {
          //code to execute on button press
          _showAddTodoSheet(context);
        },
        child: const Icon(Icons.add), //icon inside button
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button position to center
      bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: const Color(0xff5086c1),
          shape: const CircularNotchedRectangle(), //shape of notch
          notchMargin:
              5, //notche margin between floating button and bottom appbar
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              //children inside bottom appbar
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox.fromSize(
                  size: const Size(45, 45),
                  child: InkWell(
                    onTap: () async {
                      await _loadFromApi();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.settings_input_antenna,
                            color: Colors.white), // <-- Icon
                        Text("GET",
                            style: TextStyle(color: Colors.white)), // <-- Text
                      ],
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: const Size(45, 45),
                  child: InkWell(
                    onTap: () async {
                      await _deleteData();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.delete, color: Colors.white), // <-- Icon
                        Text("Delete",
                            style: TextStyle(color: Colors.white)), // <-- Text
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  showAlertDialog(BuildContext context, String text) {
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(text),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showEditTodoSheet(
      BuildContext context, AsyncSnapshot snapshot, int index) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 430,
                decoration: BoxDecoration(
                    // color: Color(0xFFEFEFEF),
                    // color: Colors.blue[100],
                    color: snapshot.data[index].isDone == 1
                        ? Colors.green[100]
                        : Colors.blue[100],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: _showEditlanguageForm(context, snapshot, index),
                ),
              ),
            ),
          );
        });
  }

  ListView _showEditlanguageForm(
      BuildContext context, AsyncSnapshot snapshot, int index) {
    final _language =
        TextEditingController(text: "${snapshot.data[index].language}");
    final _yearReleased =
        TextEditingController(text: "${snapshot.data[index].yearReleased}");
    final _designer =
        TextEditingController(text: "${snapshot.data[index].createdBy}");
    final _imageLink =
        TextEditingController(text: "${snapshot.data[index].image}");
    return ListView(
      children: <Widget>[
        Text(
          'Update programming language',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue[900]),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Column(
              children: [
                TextFormField(
                  controller: _language,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Programming language',
                      hintText: 'e.g. Python',
                      labelStyle: TextStyle(
                          // color: Color(0xff5086c1),
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                  controller: _yearReleased,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Year released',
                      hintText: 'e.g. 1990',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                  controller: _designer,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Designed by',
                      hintText: 'e.g. Quim Massagué',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                  controller: _imageLink,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Image',
                      hintText: 'https://python-photo.png',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 15),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 30,
                    child: IconButton(
                      icon: const Icon(
                        Icons.save,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_language.text.isNotEmpty &&
                            _yearReleased.text.isNotEmpty &&
                            _designer.text.isNotEmpty) {
                          List list =
                              await DBProvider.db.getLanguage(_language.text);
                          if (list.isEmpty) {
                            final language = Language();
                            language.id = snapshot.data[index].id;
                            language.language = _language.text;
                            language.yearReleased = _yearReleased.text;
                            language.createdBy = _designer.text;
                            language.image = _imageLink.text;
                            await DBProvider.db.updateLanguage(language);
                            setState(() {});
                            Navigator.of(context).pop();
                            _showDoneSnackBar('${language.language.toString()} updated', 0xff008000);
                          } else {
                            showAlertDialog(
                                context, "${_language.text} already exists.");
                          }
                        } else {
                          showAlertDialog(
                              context,
                              showAlertDialog(context,
                                  "One or more fields have an incorrect format."));
                        }
                      },
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ],
    );
  }

  ListView _showlanguageForm(BuildContext context) {
    final _language = TextEditingController();
    final _yearReleased = TextEditingController();
    final _designer = TextEditingController();
    final _imageLink = TextEditingController();
    return ListView(
      children: <Widget>[
        Text(
          'Add a new programming language',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue[900]),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Column(
              children: [
                TextFormField(
                  controller: _language,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Programming language',
                      hintText: 'e.g. Python',
                      labelStyle: TextStyle(
                          // color: Color(0xff5086c1),
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                  controller: _yearReleased,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Year released',
                      hintText: 'e.g. 1990',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                  controller: _designer,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Designed by',
                      hintText: 'e.g. Quim Massagué',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                  controller: _imageLink,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Image',
                      hintText: 'https://python-photo.png',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 15),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 30,
                    child: IconButton(
                      icon: const Icon(
                        Icons.save,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_language.text.isNotEmpty &&
                            _yearReleased.text.isNotEmpty &&
                            _designer.text.isNotEmpty) {
                          List list =
                              await DBProvider.db.getLanguage(_language.text);
                          if (list.isEmpty) {
                            final language = Language();
                            language.language = _language.text;
                            language.yearReleased = _yearReleased.text;
                            language.createdBy = _designer.text;
                            language.image = _imageLink.text;
                            await DBProvider.db.createLanguage(language);
                            setState(() {});
                            Navigator.of(context).pop();
                            _showDoneSnackBar('${language.language.toString()} created', 0xff008000);
                          } else {
                            showAlertDialog(
                                context, "${_language.text} already exists.");
                          }
                        } else {
                          showAlertDialog(context,
                              "One or more fields have an incorrect format.");
                        }
                      },
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ],
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 430,
                decoration: BoxDecoration(
                    // color: Color(0xFFEFEFEF),
                    color: Colors.blue[100],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: _showlanguageForm(context),
                ),
              ),
            ),
          );
        });
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllLanguages();

    var apiProvider = LanguageApiProvider();
    await apiProvider.getAllLanguages();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllLanguages();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  _setDoneUndoneLanguage(AsyncSnapshot snapshot, int index) async {
    final language = Language();
    language.id = snapshot.data[index].id;
    language.language = snapshot.data[index].language;
    language.yearReleased = snapshot.data[index].yearReleased;
    language.createdBy = snapshot.data[index].createdBy;
    language.image = snapshot.data[index].image;
    if (snapshot.data[index].isDone == 0) {
      language.isDone = 1;
      _showDoneSnackBar('${language.language.toString()} done', 0xff008000);
    } else {
      language.isDone = 0;
      _showDoneSnackBar('${language.language.toString()} undone', 0xff654321);
    }
    await DBProvider.db.updateLanguage(language);
    setState(() {});
  }

  _showDoneSnackBar(String language, int myColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(language),
        backgroundColor: Color(myColor),
        duration: const Duration(milliseconds: 1000)));
  }

  _deleteLanguage(String id, String language) async {
    await DBProvider.db.deleteLanguage(id);
    setState(() {});

    String message = '$language deleted';

    _showDoneSnackBar(message, 0xffff0000);
  }

  _buildLanguageListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllLanguages(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                tileColor: snapshot.data[index].isDone == 1
                    ? Colors.green[100]
                    : Colors.blue[100],
                contentPadding: const EdgeInsets.all(15),
                leading: SizedBox(
                  width: 60,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage:
                          NetworkImage(snapshot.data[index].image)),
                ),
                title: Padding(
                  // change left :
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "${snapshot.data[index].language}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Designer: ${snapshot.data[index].createdBy}'),
                      Text('Year: ${snapshot.data[index].yearReleased}'),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black),
                  onPressed: () => _deleteLanguage(
                      snapshot.data[index].id.toString(),
                      snapshot.data[index].language),
                ),
                onTap: () => _showEditTodoSheet(context, snapshot, index),
                onLongPress: () async {
                  _setDoneUndoneLanguage(snapshot, index);
                },
              );
            },
          );
        }
      },
    );
  }
}
