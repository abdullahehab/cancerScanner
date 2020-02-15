class APiData {
  String message;
  Predictions prediction;

  APiData({this.message, this.prediction});


  factory APiData.fromJson(Map<String, dynamic> json) {
    return APiData(
      message: json['message'],
      prediction: Predictions.fromJson(json['predictions'])
    );
  }

}

class Predictions {
  String actinicKeratoses, BasalCellCarcinoma, BenignKeratosis, dermatofibroma, MelanocyticNevi, Melanoma, VascularLesions;

  Predictions({this.actinicKeratoses, this.BasalCellCarcinoma, this.BenignKeratosis, this.dermatofibroma, this.MelanocyticNevi, this.Melanoma, this.VascularLesions});

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
        actinicKeratoses: json['Actinic keratoses'],
      BasalCellCarcinoma: json['Basal cell carcinoma'],
      BenignKeratosis: json['Benign keratosis'],
      dermatofibroma: json['Dermatofibroma'],
      MelanocyticNevi: json['Melanocytic nevi'],
      Melanoma: json['Melanoma'],
      VascularLesions: json['Vascular lesions']
    );
  }

}