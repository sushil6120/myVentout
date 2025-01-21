import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ventout/Utils/utilsFunction.dart';

class QuestionProvider with ChangeNotifier {
  List<Map<String, dynamic>> questions = [
    {
      "question": "Before we get started, how are you feeling today?",
      "options": [
        "Happy",
        "Worried",
        "Stressed",
        "Relaxed",
        "Sad",
        "Angry",
        "Not sure"
      ],
      "answers": ""
    },
    {
      "question":
          "Think about the past couple weeks. Have you felt any of these?",
      "options": [
        "Stressed or burned out",
        "Problems with sleep",
        "Nervous, anxious, or on edge",
        "Lonely",
        "Little interest or pleasure in doing things",
        "Down, depressed or hopeless"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by little interest or pleasure in doing things?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by feeling down, depressed, or hopeless?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by feeling tired or having little energy?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by poor appetite or overeating?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by feeling bad about yourself — or that you are a failure or have let yourself or your family down?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by trouble concentrating on things, such as reading the newspaper or watching television?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "In the last 2 weeks, how often have you been bothered by thoughts that you would be better off dead or hurting yourself in some way?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
    {
      "question":
          "How difficult have these feelings made it for you to do your work, take care of things at home, or get along with others?",
      "options": [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly everyday"
      ],
      "answers": ""
    },
  ];

  int currentIndex = 0;

  QuestionProvider() {
    shuffleQuestions();
  }

  void shuffleQuestions() {
    questions.shuffle(Random());
    notifyListeners();
  }

  void saveAnswer(String option) {
    questions[currentIndex]['answers'] = option;
    notifyListeners();
    Timer(
      Duration(milliseconds: 400),
      () {
        nextQuestion();
      },
    );
  }

  String? getSelectedAnswer() {
    return questions[currentIndex]['answers'];
  }

  void nextQuestion() {
    if (questions[currentIndex]['answers'] != "") {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
        notifyListeners();
      }
    } else {
      Utils.toastMessage('Answer is required for the current question.');
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
    }
  }

  void clearAnswers() {
    for (var question in questions) {
      question['answers'] = "";
    }
    currentIndex = 0;
    notifyListeners();
  }

  bool allQuestionsAnswered() {
    return questions.every((q) => q['answers'] != "");
  }

  Map<String, dynamic> prepareApiData() {
    if (!allQuestionsAnswered()) {
      throw Exception("All questions must be answered.");
    }

    return {
      'questions': questions.map((q) {
        return {
          'question': q['question'],
          'answers': q['answers'],
        };
      }).toList(),
    };
  }
}
