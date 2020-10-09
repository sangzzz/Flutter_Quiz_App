import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizzlerPage(),
    );
  }
}

class QuizzlerPage extends StatefulWidget {
  QuizzlerPage({Key key}) : super(key: key);

  @override
  _QuizzlerPageState createState() => _QuizzlerPageState();
}

class _QuizzlerPageState extends State<QuizzlerPage> {
  List<Widget> scoreKeeper = <Icon>[];
  QuestionBank quiz = QuestionBank();
  int correctQuestions = 0;
  void alert(context) {
    int totalQuestions = quiz.totalQuestionsInQuiz();
    AlertType alertType;
    String desc;
    if (correctQuestions > totalQuestions / 2) {
      alertType = AlertType.success;
      desc = 'Congratulations! You have passed the quiz.';
    } else {
      alertType = AlertType.error;
      desc = 'You failed the quiz but don\'t worry. You can try again now.';
    }
    Alert(
      context: context,
      type: alertType,
      title: 'Score: $correctQuestions/$totalQuestions',
      desc: desc,
      style: AlertStyle(
        animationType: AnimationType.grow,
        animationDuration: Duration(
          milliseconds: 550,
        ),
        isOverlayTapDismiss: false,
        overlayColor: Colors.black,
      ),
    ).show();
  }

  void evaluateResult(bool answer) {
    if (quiz.getQuestion().answer == answer) {
      scoreKeeper.add(
        Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
      correctQuestions++;
    } else {
      scoreKeeper.add(
        Icon(
          Icons.close,
          color: Colors.red,
        ),
      );
    }
    if (!quiz.isQuizFinished()) {
      quiz.nextQuestion();
    } else {
      alert(context);
      quiz.resetQuestionNumber();
      scoreKeeper = [];
      correctQuestions = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    quiz.getQuestion().question,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 10.0,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        evaluateResult(true);
                      });
                    },
                    color: Colors.green,
                    child: Text(
                      'True',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 10.0,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        evaluateResult(false);
                      });
                    },
                    color: Colors.red,
                    child: Text(
                      'False',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: scoreKeeper,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
