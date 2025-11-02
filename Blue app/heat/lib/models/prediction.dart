class Prediction {
  final String town;
  final double probability;
  final bool alert;

  Prediction({
    required this.town,
    required this.probability,
    required this.alert,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      town: json['town'],
      probability: (json['probability'] as num).toDouble(),
      alert: json['alert'] == 1 || json['alert'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'town': town,
      'probability': probability,
      'alert': alert,
    };
  }
}

class PredictionRun {
  final DateTime runTs;
  final DateTime startDate;
  final DateTime endDate;
  final double threshold;
  final List<Prediction> predictions;

  PredictionRun({
    required this.runTs,
    required this.startDate,
    required this.endDate,
    required this.threshold,
    required this.predictions,
  });

  factory PredictionRun.fromJson(Map<String, dynamic> json) {
    return PredictionRun(
      runTs: DateTime.parse(json['run_ts']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      threshold: (json['threshold'] as num).toDouble(),
      predictions: (json['predictions'] as List)
          .map((p) => Prediction.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'run_ts': runTs.toIso8601String(),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'threshold': threshold,
      'predictions': predictions.map((p) => p.toJson()).toList(),
    };
  }
}

class TownDetailArgs {
  final PredictionRun run;
  final Prediction prediction;

  TownDetailArgs({
    required this.run,
    required this.prediction,
  });
}