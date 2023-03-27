import 'dart:math';

import 'package:flutter/foundation.dart';

class LocalResponse {
  String id = "";
  String text = "";
  int blueThumb = 0;
  int redThumb = 0;
  int usage = 0;
  double repetitionScore = 1.0;
  double globalScore = 1.0;

  LocalResponse(
      {required this.id,
      required this.text,
      required this.blueThumb,
      required this.redThumb}) {
    updateGlobalScore();
  }

  @override
  String toString() {
    return "id: $id\t"
        "text: $text\t"
        "blueThumb: $blueThumb\t"
        "redThumb: $redThumb\t"
        "usage: $usage\t"
        "repetitionScore: $repetitionScore\t"
        "globalScore: $globalScore\t";
  }

  String getText() {
    return text;
  }

  void increaseBlueThumb() {
    blueThumb++;
  }

  void increaseRedThumb() {
    redThumb++;
  }

  void increaseUsage() {
    usage++;
  }

  void addUsage(int elementNumber) {
    usage++;
    repetitionScore /= elementNumber;
    updateGlobalScore();
  }

  void addNonUsage(int elementNumber) {
    repetitionScore *= (1 + 1 / elementNumber);
    updateGlobalScore();
  }

  void updateGlobalScore() {
    if (redThumb == 0) {
      globalScore = blueThumb * repetitionScore;
    } else if (blueThumb == 0) {
      globalScore = 1 / redThumb * repetitionScore;
    } else if (blueThumb == redThumb) {
      globalScore = 1 * repetitionScore;
    } else {
      globalScore = blueThumb / redThumb * repetitionScore;
    }
  }
}

class LocalResponseList {
  static List<LocalResponse> listResponse = [];

  LocalResponseList();

  @override
  String toString() {
    String result = "";
    for (var response in listResponse) {
      result += "$response\n";
    }
    return result;
  }

  void addResponse(LocalResponse response) {
    listResponse.add(response);
  }

  void addResponseList(List<LocalResponse> responseList) {
    listResponse.addAll(responseList);
  }

  void addResponseListFromMap(List<Map<String, dynamic>> responseList) {
    for (var response in responseList) {
      listResponse.add(LocalResponse(
          id: response['id'],
          text: response['text'],
          blueThumb: response['blue_thumb'],
          redThumb: response['red_thumb']));
    }
  }

  LocalResponse getRandomResponseWithWeights() {
    if (listResponse.isEmpty) {
      throw Exception("La liste est vide, aucune réponse à renvoyer.");
    }

    double totalWeight =
        listResponse.fold(0, (sum, item) => sum + item.globalScore);
    double randomWeight = Random().nextDouble() * totalWeight;
    double cumulativeWeight = 0;

    for (var response in listResponse) {
      cumulativeWeight += response.globalScore;
      if (randomWeight <= cumulativeWeight) {
        response.addUsage(listResponse.length);
        for (var otherResponse in listResponse) {
          if (otherResponse != response) {
            otherResponse.addNonUsage(listResponse.length);
          }
        }
        if (kDebugMode) {
          print(response);
        }
        return response;
      }
    }

    // This should never be reached, but return the last response in the list just in case
    return listResponse.last;
  }
}
