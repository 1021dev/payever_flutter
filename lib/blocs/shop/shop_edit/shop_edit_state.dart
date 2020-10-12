
class ShopEditScreenState {
  final bool isLoading;
  final bool isUpdating;


  ShopEditScreenState({
    this.isLoading = false,
    this.isUpdating = false,

  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,

  ];

  ShopEditScreenState copyWith({
    bool isLoading,
    bool isUpdating,

  }) {
    return ShopEditScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,

    );
  }
}

