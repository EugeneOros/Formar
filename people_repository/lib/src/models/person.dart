import 'package:meta/meta.dart';
import '../entities/entities.dart';
import 'level.dart';

@immutable
class Person {
  final bool available;
  final String id;
  final String nickname;
  final Level level;
  var lettersRusUk = [
    "а",
    "б",
    "в",
    "г",
    "ґ",
    "д",
    "е",
    "є",
    "ж",
    "з",
    "и",
    "і",
    "ї",
    "й",
    "к",
    "л",
    "м",
    "н",
    "о",
    "п",
    "р",
    "с",
    "т",
    "у",
    "ф",
    "х",
    "ц",
    "ч",
    "ш",
    "щ",
    "ь",
    "ю",
    "я"
  ];

  Person(this.nickname, this.level, {this.available = false, String id})
      : this.id = id;

  Person copyWith({bool available, String id, Level level, String nickname}) {
    return Person(
      nickname ?? this.nickname,
      level ?? this.level,
      available: available ?? this.available,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode =>
      available.hashCode ^ nickname.hashCode ^ id.hashCode ^ level.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          available == other.available &&
          nickname == other.nickname &&
          level == other.level &&
          id == other.id;

  @override
  String toString() {
    return 'Person { available: $available, nickname: $nickname, level: $level, id: $id }';
  }

  PeopleEntity toEntity() {
    return PeopleEntity(nickname, id, level, available);
  }

  static Person fromEntity(PeopleEntity entity) {
    return Person(
      entity.nickname,
      entity.level,
      available: entity.available ?? false,
      id: entity.id,
    );
  }

  int compareTo(String a, String b) {
    a = a.toLowerCase();
    b = b.toLowerCase();
    int min = a.length;
    if (b.length < a.length) min = b.length;
    for (int i = 0; i < min; ++i) {
      if (!lettersRusUk.contains(a[i]) || !lettersRusUk.contains(b[i])) {
        if (a.compareTo(b) == 0) continue;
        return a.compareTo(b);
      }
      if (lettersRusUk.indexOf(a[i]) > lettersRusUk.indexOf(b[i]))
        return 1;
      else if (lettersRusUk.indexOf(a[i]) < lettersRusUk.indexOf(b[i]))
        return -1;
    }
    if (a.length < b.length)
      return -1;
    else if (a.length > b.length) return 1;

    return 0;
  }
}
