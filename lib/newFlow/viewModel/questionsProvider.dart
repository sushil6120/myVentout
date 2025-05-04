import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:overcooked/Utils/utilsFunction.dart';

class QuestionProvider with ChangeNotifier {
  double progressBar = 0.1;
  int totalPoints = 0;

  void updateProgressBar(double value) {
    progressBar = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> questions = [
    {
      "question": "Depressed Mood (Sadness, Hopelessness)",
      "options": [
        "No sadness.",
        "Occasional sadness or feeling low.",
        "Frequent sadness; some difficulty cheering up.",
        "Persistent sadness; unable to shake off low mood.",
        "Extreme sadness; feeling hopeless or worthless."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Feelings of Guilt",
      "options": [
        "No feelings of guilt.",
        "Occasionally feel guilty about past actions.",
        "Frequently feel guilty and dwell on past mistakes.",
        "Strong feelings of guilt, feeling responsible for most things.",
        "Overwhelming guilt, believing self deserves punishment."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Suicidal Thoughts",
      "options": [
        "No thoughts of self-harm or suicide.",
        "Occasional thoughts but would not act on them.",
        "Frequent thoughts but no plan.",
        "Considered acting on thoughts but no definite plan.",
        "Definite plan or past attempt."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Insomnia (Sleep Issues)",
      "options": [
        "Normal sleep patterns.",
        "Slight difficulty falling asleep or waking up early.",
        "Frequent sleep disturbance.",
        "Severe difficulty staying asleep most nights.",
        "Barely sleeping or no sleep at all."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Work and Interests (Loss of Enjoyment, Motivation)",
      "options": [
        "Normal interest in work, hobbies, and relationships.",
        "Occasionally struggles with motivation.",
        "Loss of enjoyment in most activities.",
        "Struggles to do daily tasks.",
        "Completely unable to function due to lack of motivation."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Physical Symptoms (Fatigue, Body Aches, Loss of Appetite)",
      "options": [
        "No physical complaints.",
        "Occasional fatigue or mild discomfort.",
        "Frequent fatigue or body aches.",
        "Persistent fatigue or physical distress.",
        "Extreme exhaustion, unable to perform daily tasks."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Anxiety (Worry, Nervousness, Restlessness)",
      "options": [
        "No anxiety.",
        "Occasional worry.",
        "Frequent nervousness or restlessness.",
        "Severe anxiety, difficult to relax.",
        "Constant anxiety, panic attacks."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Psychomotor Changes (Slowed or Agitated Movements)",
      "options": [
        "No changes in movement or speech.",
        "Slight sluggishness or occasional restlessness.",
        "Noticeable slowing or agitation.",
        "Severe slowing or restlessness interfering with activities.",
        "Extreme difficulty in movement or severe agitation."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Weight and Appetite Changes",
      "options": [
        "No change in appetite or weight.",
        "Occasional appetite change.",
        "Noticeable weight loss/gain or persistent appetite change.",
        "Significant weight change affecting health.",
        "Extreme weight change, inability to eat properly."
      ],
      "answers": "",
      "points": 0
    },
    {
      "question": "Concentration and Decision Making",
      "options": [
        "No difficulty concentrating or making decisions.",
        "Slight difficulty focusing.",
        "Frequent struggles with concentration.",
        "Severe trouble focusing, difficulty making decisions.",
        "Completely unable to focus or make any decisions."
      ],
      "answers": "",
      "points": 0
    }
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
    int selectedIndex = questions[currentIndex]['options'].indexOf(option);
    questions[currentIndex]['answers'] = option;
    questions[currentIndex]['points'] = selectedIndex;
    updateTotalPoints();

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
        updateProgressBar(currentIndex / 10);
        notifyListeners();
      } else if (currentIndex == 9) {
        updateProgressBar(1.0);
      }
    } else {
      Utils.toastMessage('Answer is required for the current question.');
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      updateProgressBar(currentIndex / 10);
      notifyListeners();
    } else if (currentIndex == 1) {
      updateProgressBar(0.1);
    }
  }

  void clearAnswers() {
    for (var question in questions) {
      question['answers'] = "";
      question['points'] = 0;
    }
    currentIndex = 0;
    notifyListeners();
  }

  void updateIndex() {
    currentIndex = 0;
    progressBar = 0.1;
    notifyListeners();
  }

  void updateTotalPoints() {
    totalPoints = questions.fold(0, (sum, q) => sum + (q['points'] as int));
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
      'defaultQnA': questions.map((q) {
        int value = q['options'].indexOf(q['answers']);
        return {
          'question': q['question'],
          'answer': q['answers'],
          'value': value,
        };
      }).toList(),
    };
  }
}
