part of 'favorites_cubit.dart';

@immutable
sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {}

class FavoritesError extends FavoritesState {
  final String error;
  FavoritesError(this.error);
}
