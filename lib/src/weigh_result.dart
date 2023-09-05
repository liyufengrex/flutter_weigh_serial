import 'dart:convert';

/// 称重结果
class WeighResult {
  /// 重量  单位是kg
  final double weight;

  /// 结果是否稳定  稳定：true  不稳定： false
  final bool isStable;

  const WeighResult({
    required this.weight,
    required this.isStable,
  });

  WeighResult copyWith({
    double? weight,
    bool? isStable,
  }) {
    return WeighResult(
      weight: weight ?? this.weight,
      isStable: isStable ?? this.isStable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'isStable': isStable,
    };
  }

  factory WeighResult.fromMap(Map<String, dynamic> map) {
    return WeighResult(
      weight: map['weight']?.toDouble() ?? 0.0,
      isStable: map['isStable'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeighResult.fromJson(String source) =>
      WeighResult.fromMap(json.decode(source));

  @override
  String toString() => 'WeighResultModel(weight: $weight, isStable: $isStable)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeighResult &&
        other.weight == weight &&
        other.isStable == isStable;
  }

  @override
  int get hashCode => weight.hashCode ^ isStable.hashCode;
}
