import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ApiExam.dart';
import 'Examitem.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List> _data = _getQuiz();
  var _ID = 0;
  var _message = "";
  var _check = false;
  var _invalid = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(_ID < 5)
                    FutureBuilder<List>(
                      future: _data,
                      builder: (context, snapshot){
                        if(snapshot.connectionState != ConnectionState.done){
                          return const CircularProgressIndicator();
                        }
                        if(snapshot.hasData) {
                          var data = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(data[_ID].image_url, height: 400.0,),
                              for(var i=0;i<data[_ID].choice_list.length;++i)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        if(i == data[_ID].answer){
                                          _message = "เก่งมากครับ";
                                          _check = true;
                                          Timer(Duration(seconds: 1), () {
                                            setState(() {
                                              _ID++;
                                              _message = "";
                                            });
                                          });

                                        }else{
                                          setState(() {
                                            _message = "ยังไม่ถูก ลองใหม่นะครับ";
                                            _check = false;
                                            _invalid++;
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                        height: 60.0,
                                        color: Colors.green,
                                        child: Center(child: Text(data[_ID].choice_list[i], style: TextStyle(fontSize: 25.0),))
                                    ),
                                  ),
                                )
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Center(child: Text("จบเกม" , style: TextStyle(fontSize: 40.0),)),
                        Center(child: Text("ทายผิด $_invalid ครั้ง" , style: TextStyle(fontSize: 20.0),)),

                      ],
                    ),
                  if(_check)
                    Text(_message, style: TextStyle(fontSize: 40.0, color: Colors.green),)
                  else
                    Text(_message, style: TextStyle(fontSize: 40.0, color: Colors.red),)
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<List> _getQuiz() async{
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/quizzes');
    var response = await http.get(url, headers: {'id': '620710689'},);

    var json = jsonDecode(response.body);
    var apiResult = ApiExam.fromJson(json);
    List data = apiResult.data;
    var examitem = data.map((element) => Examitem(
        image_url: element['image_url'],
        answer: element['answer'],
        choice_list: element['choice_list'],
        )).toList();

    return examitem;
  }
}