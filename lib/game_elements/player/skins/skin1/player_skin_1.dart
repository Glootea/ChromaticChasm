part of player_skin;

class PlayerSkin1 implements PlayerSkin {
  @override
  List<Drawable2D> getDrawables(TilePositionable startPivot) => [
        PlayerSkin1Left(startPivot),
        PlayerSkin1Center(startPivot),
        PlayerSkin1Right(startPivot),
      ];
}
