import 'package:app/model/book_model.dart';
import 'package:app/screens/edit_book_screen.dart';
import 'package:flutter/material.dart';

import '../config/book_provider.dart';
import 'add_book_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map> bookList = [];

  Future<String> getRecords() async {
    var db = BookProvider();
    await db.open();
    bookList = await db.getRecords();
    return "Data Loaded";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Books"),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddBookScreen()));
          },
          label: const Text("Add Book"),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: FutureBuilder(
            future: getRecords(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: bookList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: index == bookList.length
                                  ? const EdgeInsets.only(bottom: 40, top: 20)
                                  : const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: const Icon(Icons.library_books),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          bookList[index]['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(bookList[index]['description'])
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        var db = BookProvider();
                                        await db.open();
                                        await db.delete(bookList[index]['id']);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()),
                                            (route) => false);
                                      },
                                      child: const Text(
                                        "remove",
                                        style: TextStyle(color: Colors.red),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditBookScreen(
                                                    id: bookList[index]['id']),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
