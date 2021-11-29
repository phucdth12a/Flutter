class TypePsi {
  final double psi;
  final int temp;
  final bool isLowPressure;

  TypePsi({required this.psi, required this.temp, required this.isLowPressure});
}

final List<TypePsi> demoPsiList = [
  TypePsi(psi: 23.6, temp: 56, isLowPressure: true),
  TypePsi(psi: 35.0, temp: 41, isLowPressure: false),
  TypePsi(psi: 34.6, temp: 41, isLowPressure: false),
  TypePsi(psi: 34.8, temp: 42, isLowPressure: false),
];