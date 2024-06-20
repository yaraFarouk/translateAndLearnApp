part of 'proof_cubit.dart';

@immutable
abstract class ProofState {}

class ProofInitial extends ProofState {}

class ProofGenerated extends ProofState {
  final String proof;

  ProofGenerated(this.proof);
}

class ProofError extends ProofState {
  final String message;

  ProofError(this.message);
}
