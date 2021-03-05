import 'dart:convert';

class AnswerModel {
  final String answer;
  final bool forced;
  final String image;
  AnswerModel({
    this.answer,
    this.forced,
    this.image,
  });

  AnswerModel copyWith({
    String answer,
    bool forced,
    String image,
  }) {
    return AnswerModel(
      answer: answer ?? this.answer,
      forced: forced ?? this.forced,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'forced': forced,
      'image': image,
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AnswerModel(
      answer: map['answer'],
      forced: map['forced'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromJson(String source) =>
      AnswerModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AnswerModel(answer: $answer, forced: $forced, image: $image)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AnswerModel &&
        o.answer == answer &&
        o.forced == forced &&
        o.image == image;
  }

  @override
  int get hashCode => answer.hashCode ^ forced.hashCode ^ image.hashCode;
}
