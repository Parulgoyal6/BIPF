class AddingAnActivity {
  final int? local_id;
  final String? name_of_activity;
  final String? date;
  final String? start_time;
  final String? end_time;
  final String? unplanned;
  final String? district;
  final String? block;
  final String? village;
  final String? total_participants;
  final String? men;
  final String? women;
  final String? boys;
  final String? girls;
  final String? other;
  final String? target_number_of_population;
  final String? guest_name;
  final String? guest_designation;
  final String? resource_person_name;
  final String? resource_person_designation;
  final String? image;
  final String? beneficiary;
  final String? observation;
  final String? topic_name;
  final String? chapter_name;


  const AddingAnActivity({
    this.local_id,
    this.name_of_activity,
    this.date,
    this.start_time,
    this.end_time,
    this.district,
    this.block,
    this.village,
    this.total_participants,
    this.unplanned,
    this.men,
    this.women,
    this.girls,
    this.boys,
    this.other,
    this.target_number_of_population,
    this.guest_name,
    this.guest_designation,
    this.resource_person_name,
    this.resource_person_designation,
    this.image,
    this.beneficiary,
    this.observation,
    this.topic_name,
    this.chapter_name
  });

  static const String tableName = "Activity_Form";

  static const String columnLocalId = "local_id";
  static const String columnNameOfActivity = "name_of_activity";
  static const String columnDate = "date";
  static const String columnStartTime = "start_time";
  static const String columnEndTime = "end_time";
  static const String columnDistrict ="district";
  static const String columnBlock = "block";
  static const String columnVillage = "village";
  static const String columnTotalParticipants = "total_participants";
  static const String columnUnplanned = "unplanned";
  static const String columnMen = "men";
  static const String columnWomen = "women";
  static const String columnGirls = "girls";
  static const String columnBoys = "boys";
  static const String columnOther = "other";
  static const String columnTargetNumberOfPopulation = "target_number_of_population";
  static const String columnGuestName = "guest_name";
  static const String columnGuestDesignation = "guest_designation";
  static const String columnResourcePersonName = "resource_person_name";
  static const String columnResourcePersonDesignation = "resource_person_designation";
  static const String columnImage = "image";
  static const String columnBeneficiary = "beneficiary";
  static const String columnObservation = "observation";
  static const String columnTopicName = "topic_name";
  static const String columnChapterName = "chapter_name";


  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnNameOfActivity TEXT, "
      "$columnDate TEXT, "
      "$columnStartTime TEXT, "
      "$columnEndTime TEXT, "
      "$columnDistrict TEXT, "
      "$columnBlock TEXT, "
      "$columnVillage TEXT, "
      "$columnTotalParticipants TEXT, "
      "$columnUnplanned TEXT, "
      "$columnMen TEXT, "
      "$columnWomen TEXT, "
      "$columnGirls TEXT, "
      "$columnBoys TEXT, "
      "$columnOther TEXT, "
      "$columnTargetNumberOfPopulation TEXT, "
      "$columnGuestName TEXT, "
      "$columnGuestDesignation TEXT, "
      "$columnResourcePersonName TEXT, "
      "$columnResourcePersonDesignation TEXT, "
      "$columnImage TEXT, "
      "$columnBeneficiary TEXT, "
      "$columnObservation TEXT, "
      "$columnTopicName TEXT, "
      "$columnChapterName TEXT)";

  // Convert a map (from database) to a School object
  factory AddingAnActivity.fromJson(Map<String, dynamic> json) {
    return AddingAnActivity(
      local_id: json['local_id'],
      name_of_activity: json['name_of_activity'],
      date: json['date'],
      start_time: json['start_time'],
      end_time: json['end_time'],
      district: json['district'],
      block: json['block'],
      village: json['village'],
      total_participants: json['total_participants'],
      men: json['men'],
      women: json['women'],
      girls: json['girls'],
      boys: json['boys'],
      other: json['other'],
      image: json['image'],
      target_number_of_population: json['target_number_of_population'],
      guest_name: json['guest_name'],
      guest_designation: json['guest_designation'],
      resource_person_name: json['resource_person_name'],
      resource_person_designation: json['resource_person_designation'],
      unplanned: json['unplanned'],
      beneficiary: json['beneficiary'],
      observation: json['observation'],
      topic_name: json['topic_name'],
      chapter_name: json['chapter_name'],
    );
  }

  factory AddingAnActivity.fromMap(Map<String, dynamic> json) => AddingAnActivity(
    local_id: json["local_id"] != null ? int.tryParse(json["local_id"].toString()) : null,
    name_of_activity: json['name_of_activity'] ?? "",
    date: json['date'] ?? "",
    start_time: json['start_time'] ?? "",
    end_time: json['end_time'] ?? "",
    district: json['district'] ?? "",
    block: json['block'] ?? "",
    village: json['village'] ?? "",
    total_participants: json['total_participants'] ?? "",
    men: json['men'] ?? "",
    women: json['women'] ?? "",
    girls: json['girls'] ?? "",
    boys: json['boys'] ?? "",
    other: json['other'] ?? "",
    image: json['image'] ?? "",
    target_number_of_population: json['target_number_of_population'] ?? "",
    unplanned: json['unplanned'] ?? "",
    guest_name: json['guest_name'] ?? "",
    guest_designation: json['guest_designation'] ?? "",
    resource_person_name: json['resource_person_name'] ?? "",
    resource_person_designation: json['resource_person_designation'] ?? "",
    beneficiary: json['beneficiary'] ?? "",
    observation: json['observation'] ?? "",
    topic_name: json['topic_name'] ?? "",
    chapter_name: json['chapter_name'] ?? "",
  );


  // Convert a School object to a map (for database insertion)
  Map<String, dynamic> toJson() {
    return {
      'local_id': local_id,
      'name_of_activity': name_of_activity,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'district': district,
      'block': block,
      'village': village,
      'total_participants': total_participants,
      'unplanned': unplanned,
      'men': men,
      'women': women,
      'girls': girls,
      'boys': boys,
      'other': other,
      'target_number_of_population': target_number_of_population,
      'guest_name': guest_name,
      'guest_designation': guest_designation,
      'resource_person_name': resource_person_name,
      'resource_person_designation': resource_person_designation,
      'image': image,
      'beneficiary': beneficiary,
      'observation': observation,
      'topic_name': topic_name,
      'chapter_name': chapter_name,
    };
  }

}
