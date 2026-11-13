// Responsibility: Defines the data collected during the onboarding flow.
import 'package:flutter/foundation.dart';

enum WritingTime { morning, afternoon, evening, beforeBed, noSetTime }

enum WritingFrequency { everyDay, fewTimesAWeek, whenIFeelLikeIt }

@immutable
class OnboardingData {
  const OnboardingData({
    this.nickname = '',
    this.birthDay = '',
    this.birthMonth = '',
    this.birthYear = '',
    this.birthYearOnly = false,
    this.country = '',
    this.city = '',
    this.timeZone = '',
    this.goals = const <String>{},
    this.writingTime,
    this.frequency,
    this.remindGently = false,
    this.reminderTime,
    this.topics = const <String>{},
  });

  static const minAge = 13;

  final String nickname;
  final String birthDay;
  final String birthMonth;
  final String birthYear;
  final bool birthYearOnly;
  final String country;
  final String city;
  final String timeZone;
  final Set<String> goals;
  final WritingTime? writingTime;
  final WritingFrequency? frequency;
  final bool remindGently;
  final String? reminderTime; // e.g. "8:30 PM" (display/local)
  final Set<String> topics;

  bool get hasName => nickname.trim().isNotEmpty;
  bool get hasBirthday =>
      birthDay.trim().isNotEmpty &&
      birthMonth.trim().isNotEmpty &&
      birthYear.trim().isNotEmpty;

  DateTime? get birthdayDate {
    if (!hasBirthday) return null;
    final day = int.tryParse(birthDay.trim());
    final year = int.tryParse(birthYear.trim());
    final month = _monthNumber(birthMonth.trim());
    if (day == null || year == null || month == null) return null;
    final date = DateTime(year, month, day);
    // DateTime normalizes invalid dates (e.g. Feb 31 -> Mar 3); reject those.
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  bool get isUnderMinAge {
    final date = birthdayDate;
    if (date == null) return false;
    final now = DateTime.now();
    var age = now.year - date.year;
    final hadBirthdayThisYear =
        now.month > date.month ||
        (now.month == date.month && now.day >= date.day);
    if (!hadBirthdayThisYear) age -= 1;
    return age < minAge;
  }

  String get birthdaySummary {
    if (!hasBirthday) return 'Not set';
    return '${birthDay.trim()} ${birthMonth.trim()} ${birthYear.trim()}';
  }

  String get locationSummary {
    final parts = <String>[
      if (city.trim().isNotEmpty) city.trim(),
      if (country.trim().isNotEmpty) country.trim(),
    ];
    return parts.isEmpty ? 'Not set' : parts.join(', ');
  }

  String get rhythmSummary {
    final time = writingTime == null ? null : writingTimeLabel(writingTime!);
    final freq = frequency == null ? null : frequencyLabel(frequency!);
    final parts = <String>[?time, ?freq];
    return parts.isEmpty ? 'Not set' : parts.join(' \u00B7 ');
  }

  String get goalsSummary => goals.isEmpty ? 'Not set' : goals.join(', ');

  String get topicsSummary => topics.isEmpty ? 'Not set' : topics.join(', ');

  OnboardingData copyWith({
    String? nickname,
    String? birthDay,
    String? birthMonth,
    String? birthYear,
    bool? birthYearOnly,
    String? country,
    String? city,
    String? timeZone,
    Set<String>? goals,
    Object? writingTime = _sentinel,
    Object? frequency = _sentinel,
    bool? remindGently,
    Object? reminderTime = _sentinel,
    Set<String>? topics,
  }) {
    return OnboardingData(
      nickname: nickname ?? this.nickname,
      birthDay: birthDay ?? this.birthDay,
      birthMonth: birthMonth ?? this.birthMonth,
      birthYear: birthYear ?? this.birthYear,
      birthYearOnly: birthYearOnly ?? this.birthYearOnly,
      country: country ?? this.country,
      city: city ?? this.city,
      timeZone: timeZone ?? this.timeZone,
      goals: goals ?? this.goals,
      writingTime: writingTime == _sentinel
          ? this.writingTime
          : writingTime as WritingTime?,
      frequency: frequency == _sentinel
          ? this.frequency
          : frequency as WritingFrequency?,
      remindGently: remindGently ?? this.remindGently,
      reminderTime: reminderTime == _sentinel
          ? this.reminderTime
          : reminderTime as String?,
      topics: topics ?? this.topics,
    );
  }

  static String writingTimeLabel(WritingTime value) {
    switch (value) {
      case WritingTime.morning:
        return 'Morning';
      case WritingTime.afternoon:
        return 'Afternoon';
      case WritingTime.evening:
        return 'Evening';
      case WritingTime.beforeBed:
        return 'Before bed';
      case WritingTime.noSetTime:
        return 'No set time';
    }
  }

  static String frequencyLabel(WritingFrequency value) {
    switch (value) {
      case WritingFrequency.everyDay:
        return 'Daily';
      case WritingFrequency.fewTimesAWeek:
        return 'Few / week';
      case WritingFrequency.whenIFeelLikeIt:
        return 'Whenever';
    }
  }

  static int? _monthNumber(String month) {
    const months = <String, int>{
      'january': 1,
      'february': 2,
      'march': 3,
      'april': 4,
      'may': 5,
      'june': 6,
      'july': 7,
      'august': 8,
      'september': 9,
      'october': 10,
      'november': 11,
      'december': 12,
    };
    return months[month.toLowerCase()] ?? int.tryParse(month);
  }
}

const Object _sentinel = Object();
