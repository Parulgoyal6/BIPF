class BeneficiaryModel {
  final int? id; // for primary key
  final String beneficiary_name;
  final String? gp;
  final String? village;
  final String? shg;
  final String? age;
  final String? membership_status;
  final String? father_name;
  final String? mother_name;
  final String? education_grade;
  final String? caste;
  final String? date_of_birth;
  final String? id_proof;
  final String? number_of_beneficiaries;
  final String? unique_id;

  BeneficiaryModel({
    this.id,
    required this.beneficiary_name,
    this.gp,
    this.village,
    this.shg,
    this.age,
    this.membership_status,
    this.father_name,
    this.mother_name,
    this.education_grade,
    this.caste,
    this.date_of_birth,
    this.id_proof,
    this.number_of_beneficiaries,
    this.unique_id,
  });

  static const String tableName = 'Beneficiary';

  static const String columnId = 'id';
  static const String columnBeneficiaryName = 'beneficiaryName';
  static const String columnGp = 'gp';
  static const String columnVillage = 'village';
  static const String columnShg = 'shg';
  static const String columnAge = 'age';
  static const String columnMembershipStatus = 'membershipStatus';
  static const String columnFatherName = 'fatherName';
  static const String columnMotherName = 'motherName';
  static const String columnEducationGrade = 'educationGrade';
  static const String columnCaste = 'caste';
  static const String columnDateOfBirth = 'dateOfBirth';
  static const String columnIdProof = 'idProof';
  static const String columnNumberOfBeneficiaries = 'numberOfBeneficiaries';
  static const String columnUniqueId = 'uniqueId';

  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnBeneficiaryName TEXT NOT NULL,
      $columnGp TEXT,
      $columnVillage TEXT,
      $columnShg TEXT,
      $columnAge INTEGER,
      $columnMembershipStatus TEXT,
      $columnFatherName TEXT,
      $columnMotherName TEXT,
      $columnEducationGrade TEXT,
      $columnCaste TEXT,
      $columnDateOfBirth TEXT,
      $columnIdProof TEXT,
      $columnNumberOfBeneficiaries INTEGER,
      $columnUniqueId TEXT
    )
  ''';

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'],
      beneficiary_name: json['beneficiar_name'],
      gp: json['gp'],
      village: json['village'],
      shg: json['shg'],
      age: json['age'],
      membership_status: json['membership_status'],
      father_name: json['father_name'],
      mother_name: json['mother_name'],
      education_grade: json['education_grade'],
      caste: json['caste'],
      date_of_birth: json['date_of_birth'],
      id_proof: json['id_proof'],
      number_of_beneficiaries: json['number_of_beneficiaries'],
      unique_id: json['unique_id'],
    );
  }

  Map<String, dynamic> toJson() {
   return{
      'beneficiary_name': beneficiary_name,
      'gp': gp,
      'village': village,
      'shg': shg,
      'age': age,
      'membership_status': membership_status,
      'father_name': father_name,
      'mother_name': mother_name,
      'education_grade': education_grade,
      'caste': caste,
      'date_of_birth': date_of_birth,
      'id_proof': id_proof,
      'number_of_beneficiaries': number_of_beneficiaries,
      'unique_id': unique_id,
    };
  }
}
