import 'package:flutter/foundation.dart';

class TravelItemType {
  static const flight = 'flight';
  static const hotel = 'hotel';
  static const transfer = 'transfer';
  static const car = 'car';
  static const ticket = 'ticket';
  static const insurance = 'insurance';
}

abstract class TravelItemModel {
  final String id;
  final String type;
  final String title;
  final DateTime? date;
  final String? location;
  final String? notes;

  const TravelItemModel({
    required this.id,
    required this.type,
    required this.title,
    this.date,
    this.location,
    this.notes,
  });

  Map<String, dynamic> toMap();

  factory TravelItemModel.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String? ?? TravelItemType.flight;

    switch (type) {
      case TravelItemType.hotel:
        return HotelTravelItem.fromMap(map);
      case TravelItemType.transfer:
        return TransferTravelItem.fromMap(map);
      case TravelItemType.car:
        return CarTravelItem.fromMap(map);
      case TravelItemType.ticket:
        return TicketTravelItem.fromMap(map);
      case TravelItemType.insurance:
        return InsuranceTravelItem.fromMap(map);
      case TravelItemType.flight:
      default:
        return FlightTravelItem.fromMap(map);
    }
  }
}

class FlightTravelItem extends TravelItemModel {
  final String? airline;
  final String? flightNumber;

  const FlightTravelItem({
    required super.id,
    required super.title,
    super.date,
    super.location,
    super.notes,
    this.airline,
    this.flightNumber,
  }) : super(type: TravelItemType.flight);

  factory FlightTravelItem.fromMap(Map<String, dynamic> map) {
    return FlightTravelItem(
      id: map['id'] as String? ?? UniqueKey().toString(),
      title: map['title'] as String? ?? 'Voo',
      date: map['date'] is String ? DateTime.tryParse(map['date']) : map['date'] as DateTime?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      airline: map['airline'] as String?,
      flightNumber: map['flightNumber'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'date': date?.toIso8601String(),
        'location': location,
        'notes': notes,
        'airline': airline,
        'flightNumber': flightNumber,
      };
}

class HotelTravelItem extends TravelItemModel {
  final String? hotelName;
  final int? nights;

  const HotelTravelItem({
    required super.id,
    required super.title,
    super.date,
    super.location,
    super.notes,
    this.hotelName,
    this.nights,
  }) : super(type: TravelItemType.hotel);

  factory HotelTravelItem.fromMap(Map<String, dynamic> map) {
    return HotelTravelItem(
      id: map['id'] as String? ?? UniqueKey().toString(),
      title: map['title'] as String? ?? 'Hotel',
      date: map['date'] is String ? DateTime.tryParse(map['date']) : map['date'] as DateTime?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      hotelName: map['hotelName'] as String?,
      nights: map['nights'] as int?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'date': date?.toIso8601String(),
        'location': location,
        'notes': notes,
        'hotelName': hotelName,
        'nights': nights,
      };
}

class TransferTravelItem extends TravelItemModel {
  final String? provider;

  const TransferTravelItem({
    required super.id,
    required super.title,
    super.date,
    super.location,
    super.notes,
    this.provider,
  }) : super(type: TravelItemType.transfer);

  factory TransferTravelItem.fromMap(Map<String, dynamic> map) {
    return TransferTravelItem(
      id: map['id'] as String? ?? UniqueKey().toString(),
      title: map['title'] as String? ?? 'Transfer',
      date: map['date'] is String ? DateTime.tryParse(map['date']) : map['date'] as DateTime?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      provider: map['provider'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'date': date?.toIso8601String(),
        'location': location,
        'notes': notes,
        'provider': provider,
      };
}

class CarTravelItem extends TravelItemModel {
  final String? rentalCompany;

  const CarTravelItem({
    required super.id,
    required super.title,
    super.date,
    super.location,
    super.notes,
    this.rentalCompany,
  }) : super(type: TravelItemType.car);

  factory CarTravelItem.fromMap(Map<String, dynamic> map) {
    return CarTravelItem(
      id: map['id'] as String? ?? UniqueKey().toString(),
      title: map['title'] as String? ?? 'Carro',
      date: map['date'] is String ? DateTime.tryParse(map['date']) : map['date'] as DateTime?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      rentalCompany: map['rentalCompany'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'date': date?.toIso8601String(),
        'location': location,
        'notes': notes,
        'rentalCompany': rentalCompany,
      };
}

class TicketTravelItem extends TravelItemModel {
  final String? venue;

  const TicketTravelItem({
    required super.id,
    required super.title,
    super.date,
    super.location,
    super.notes,
    this.venue,
  }) : super(type: TravelItemType.ticket);

  factory TicketTravelItem.fromMap(Map<String, dynamic> map) {
    return TicketTravelItem(
      id: map['id'] as String? ?? UniqueKey().toString(),
      title: map['title'] as String? ?? 'Ingresso',
      date: map['date'] is String ? DateTime.tryParse(map['date']) : map['date'] as DateTime?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      venue: map['venue'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'date': date?.toIso8601String(),
        'location': location,
        'notes': notes,
        'venue': venue,
      };
}

class InsuranceTravelItem extends TravelItemModel {
  final String? insurer;

  const InsuranceTravelItem({
    required super.id,
    required super.title,
    super.date,
    super.location,
    super.notes,
    this.insurer,
  }) : super(type: TravelItemType.insurance);

  factory InsuranceTravelItem.fromMap(Map<String, dynamic> map) {
    return InsuranceTravelItem(
      id: map['id'] as String? ?? UniqueKey().toString(),
      title: map['title'] as String? ?? 'Seguro',
      date: map['date'] is String ? DateTime.tryParse(map['date']) : map['date'] as DateTime?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      insurer: map['insurer'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'date': date?.toIso8601String(),
        'location': location,
        'notes': notes,
        'insurer': insurer,
      };
}
