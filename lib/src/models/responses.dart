import 'dart:math';

import 'package:flutter/foundation.dart';

class LocalResponse {
  String id = "";
  String text = "";
  int blueThumb = 0;
  int redThumb = 0;
  int usage = 0;
  double repetitionScore = 1.0;
  int lastUsedTimestamp = 0;

  bool isLiked = false;
  bool isDisliked = false;

  LocalResponse(
      {required this.id,
      required this.text,
      required this.blueThumb,
      required this.redThumb});

  @override
  String toString() {
    return "id: $id\t"
        "text: $text\t"
        "blueThumb: $blueThumb\t"
        "redThumb: $redThumb\t"
        "usage: $usage\t"
        "repetitionScore: $repetitionScore\t";
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

  void increaseRepetitionScore() {
    repetitionScore *= 50;
  }

  void decreaseRepetitionScore() {
    repetitionScore = max(1.0, repetitionScore - 1.0);
  }
}

class LocalResponseList {
  static List<LocalResponse> listResponse = [];
  static List<LocalResponse> recentlyUsedResponses = [];
  static int countResponsesUsed = 0;

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

    const int maxRecentlyUsedResponses =
        3; // Nombre maximum de réponses à mémoriser

    List<LocalResponse> availableResponses = List.from(listResponse);
    availableResponses
        .removeWhere((response) => recentlyUsedResponses.contains(response));

    if (availableResponses.isEmpty) {
      recentlyUsedResponses.clear();
      availableResponses = List.from(listResponse);
    }

    double totalWeight = availableResponses.fold(0, (sum, item) {
      double itemWeight = (3 * (item.blueThumb + 1) / (item.redThumb + 1)) /
          item.repetitionScore;
      return sum + itemWeight;
    });

    double randomWeight = Random().nextDouble() * totalWeight;
    double cumulativeWeight = 0;

    for (var response in availableResponses) {
      double itemWeight =
          (3 * (response.blueThumb + 1) / (response.redThumb + 1)) /
              response.repetitionScore;
      cumulativeWeight += itemWeight;

      if (randomWeight <= cumulativeWeight) {
        recentlyUsedResponses.add(response);
        if (recentlyUsedResponses.length > maxRecentlyUsedResponses) {
          recentlyUsedResponses.removeAt(0);
        }
        response.increaseRepetitionScore();
        countResponsesUsed++;
        if (countResponsesUsed >= 5) {
          for (var r in listResponse) {
            r.decreaseRepetitionScore();
          }
          countResponsesUsed = 0;
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
