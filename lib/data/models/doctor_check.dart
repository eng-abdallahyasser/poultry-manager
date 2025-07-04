class DoctorCheck {
  final DateTime date;
  final String doctorName;
  final ExternalCheck external;
  final SubcutaneousCheck subcutaneous;
  final LiverCheck liver;
  final LungCheck lungs;
  final String? notes;

  DoctorCheck({
    required this.date,
    required this.doctorName,
    required this.external,
    required this.subcutaneous,
    required this.liver,
    required this.lungs,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'doctorName': doctorName,
      'external': external.toMap(),
      'subcutaneous': subcutaneous.toMap(),
      'liver': liver.toMap(),
      'lungs': lungs.toMap(),
      'notes': notes,
    };
  }

  factory DoctorCheck.fromMap(Map<String, dynamic> map) {
    return DoctorCheck(
      date: DateTime.parse(map['date']),
      doctorName: map['doctorName'],
      external: ExternalCheck.fromMap(map['external']),
      subcutaneous: SubcutaneousCheck.fromMap(map['subcutaneous']),
      liver: LiverCheck.fromMap(map['liver']),
      lungs: LungCheck.fromMap(map['lungs']),
      notes: map['notes'],
    );
  }
}

class ExternalCheck {
  final int generalCondition; // 1-10
  final int activityLevel; // 1-10
  final int appetite; // 1-10
  final FeatherCondition featherCondition;
  final int featherScore; // 1-10

  ExternalCheck({
    required this.generalCondition,
    required this.activityLevel,
    required this.appetite,
    required this.featherCondition,
    required this.featherScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'generalCondition': generalCondition,
      'activityLevel': activityLevel,
      'appetite': appetite,
      'featherCondition': featherCondition.name,
      'featherScore': featherScore,
    };
  }

  factory ExternalCheck.fromMap(Map<String, dynamic> map) {
    return ExternalCheck(
      generalCondition: map['generalCondition'],
      activityLevel: map['activityLevel'],
      appetite: map['appetite'],
      featherCondition: FeatherCondition.values.firstWhere(
        (e) => e.name == map['featherCondition'],
        orElse: () => FeatherCondition.normal,
      ),
      featherScore: map['featherScore'],
    );
  }
}

enum FeatherCondition {
  fluffy('منفوش'),
  normal('ناعم'),
  damaged('تالف');

  final String arabicName;
  const FeatherCondition(this.arabicName);
}

class SubcutaneousCheck {
  final bool hasBleeding;
  final int bleedingSeverity; // 1-10 if hasBleeding
  final String? bleedingLocation;

  SubcutaneousCheck({
    required this.hasBleeding,
    this.bleedingSeverity = 0,
    this.bleedingLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasBleeding': hasBleeding,
      'bleedingSeverity': bleedingSeverity,
      'bleedingLocation': bleedingLocation,
    };
  }

  factory SubcutaneousCheck.fromMap(Map<String, dynamic> map) {
    return SubcutaneousCheck(
      hasBleeding: map['hasBleeding'],
      bleedingSeverity: map['bleedingSeverity'] ?? 0,
      bleedingLocation: map['bleedingLocation'],
    );
  }
}

class LiverCheck {
  final LiverSize size;
  final LiverColor color;
  final LiverTexture texture;
  final int abnormalityScore; // 1-10

  LiverCheck({
    required this.size,
    required this.color,
    required this.texture,
    required this.abnormalityScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'size': size.name,
      'color': color.name,
      'texture': texture.name,
      'abnormalityScore': abnormalityScore,
    };
  }

  factory LiverCheck.fromMap(Map<String, dynamic> map) {
    return LiverCheck(
      size: LiverSize.values.firstWhere(
        (e) => e.name == map['size'],
        orElse: () => LiverSize.normal,
      ),
      color: LiverColor.values.firstWhere(
        (e) => e.name == map['color'],
        orElse: () => LiverColor.normal,
      ),
      texture: LiverTexture.values.firstWhere(
        (e) => e.name == map['texture'],
        orElse: () => LiverTexture.firm,
      ),
      abnormalityScore: map['abnormalityScore'],
    );
  }
}

enum LiverSize {
  enlarged('متضخم'),
  normal('طبيعي'),
  shrunk('منكمش');

  final String arabicName;
  const LiverSize(this.arabicName);
}

enum LiverColor {
  bloody('مدمم'),
  cheesy('متجبن'),
  pale('باهت'),
  normal('طبيعي');

  final String arabicName;
  const LiverColor(this.arabicName);
}

enum LiverTexture {
  brittle('هش'),
  firm('متماسك'),
  soft('طري');

  final String arabicName;
  const LiverTexture(this.arabicName);
}

class LungCheck {
  final bool hasAbnormalSound;
  final int breathingDifficulty; // 1-10
  final int congestionScore; // 1-10

  LungCheck({
    required this.hasAbnormalSound,
    required this.breathingDifficulty,
    required this.congestionScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasAbnormalSound': hasAbnormalSound,
      'breathingDifficulty': breathingDifficulty,
      'congestionScore': congestionScore,
    };
  }

  factory LungCheck.fromMap(Map<String, dynamic> map) {
    return LungCheck(
      hasAbnormalSound: map['hasAbnormalSound'],
      breathingDifficulty: map['breathingDifficulty'],
      congestionScore: map['congestionScore'],
    );
  }
}