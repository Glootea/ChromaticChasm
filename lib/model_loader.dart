import 'dart:convert';
import 'dart:typed_data';

import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
import 'package:lzstring/lzstring.dart';

class ModelLoader {
  static Drawable getDrawable(Positionable pivot, String name) {
    if (_constructed[name] != null) return _constructed[name]!;
    String? sourceString = _source[name];
    if (sourceString == null) throw ArgumentError("Source $name not found");
    String? decodedString = LZString.decompressFromBase64Sync(sourceString);
    if (decodedString == null) throw ArgumentError("Failed to decode source $name");
    final Map<String, dynamic>? sourceMap = jsonDecode(decodedString);
    final verticesList = (sourceMap!['vertices'] as List).map((e) => Float32List.fromList(e.cast<double>()));
    final edgesRaw = Uint8List.fromList((sourceMap['edges'] as List).cast<int>());
    final edges = List.generate(edgesRaw.length ~/ 2, (index) => [edgesRaw[index * 2], edgesRaw[index * 2 + 1]]);
    final temp = Drawable2D(pivot, verticesList.map((e) => Positionable(e[0], e[1], e[2])).toList(), edges);
    _constructed[name] = temp;
    return temp;
  }

  static final Map<String, Drawable> _constructed = {};
  static final Map<String, String> _source = {
    'a':
        'N4IgbgpgTgLglgYwgZxALgAQG0sAYB0ALAOwA0GBu5lAuuXvgMyHX5UVt3YHOu5kdcXBo0Z8AbH2E8xggKxT6Mvi0HSmsyps5KmfRd3wAmABz61ugIxnBBhrgCcEvnPWXJgy3YKnzlV1aqlF4WhpYhWt74lgochB7+6o7OoQzufBFsAYb8fE6plAIE4VHWrEZFWUmVltpCurkcvPLVrOkFbDU2tLqifHXZ9t3R+T1hQcYJVQ2jxpn1YdrNiVblRlGEmYSxK2GshOstVtpGOzqGjIc8lbiDxRNGUwv2N7O3blOPpcMVUaflLnUy2MNzca0BvQmjDOz2UTSeQKWoN6VyYyIu+1KE1w8zubFmRlxQIeELCw2xbjOjHRImxpLSSwpDUqwNhRBu9Mos02pX2qLZJTiTLCqO2pW0Yo6MX2CN0JFYjCeeKMJKOYS22Lxiv2NJ4DxuWvJssME3ipXmA3UPLiMMRCqVVtN/LtTQNbmG7F2DHl8NKophyu0ljeWtVYwYRlRwc5+P2RN0/w4zqsnwdvTqmvUKoBHT6gjThiMQberQ4gq9PijJd6mLVLzaloTmXa4cow2jdeK5Jj2ribrlTpjUbqbglAazbWTheb8yzM6iwOhQ+bf351YuAyH2N1TG3Q5hO8ThQXRqHNx3jWKBYjbx3dR7fB3tXK4968w9lIV/ZNMp7a4XQYAW0s7Mm0HqhpOfzNtePgNkOkGdnMwHLshiGEm0Q7/mhe5oQe+6PmeBFobeD6CN+Ijvn+eQ9oBiF5sU8YXBMlj8q4XAgBAAAmADmKDoNw5AhCY7CXOQDgCNKGDiKoxAeA4qiWMkGAmAIDgiSEDixMQITELILE2Cx+SKTpISqLEknyeQjD5OIsgmIcRjsD64g2bIxASYKLGHKJUkKSEz4YOEemHIpqgmMFHgsQIcjRQZva1AIhA2NaCWCYwcVxUZRhGYw7DEFlMkKQI+XkCYmWCYQ7CWIlHk2Iw/k+bUsjZeQkbkMQyX5I55DiB4cghbgclGbgnrkHIsSWVJsQmB4ZVjbN7ADZFsTiP5iYsZFrVjT15ApZJHjrdZgndYFAUSV1ITZhgXyBUut0HXVImxNSu2HIQsjiDYxBOaokq1OZLFiW9NhyOwcgNVVuCyHIINGWNIW5WlDUNYcxCHJpaV6c0AU+sQK3efkJj+YNpUTXJdWRTY60BeEl12fkDh6bcgmNOEIWWDJckCOFrXmUp4RU1ZPXDa13Ps89si9ipu1GSlV0seZvyBb4GAY1JqPFSLGDxdjd3NCYNmRTiYmRYmjOCdVx3o4cJh8wplUVSEcjQ6oDhrWZZl9TZVWSUrDtSR44gCJ9SMs1pqPPb9E3Q+w4iHON7U2ETMtWfkciqG1yn5GaytVehGC6VZCmo67PvE5D7PRZdadMxJuAg7E/XUO1AMCC1ytrZLu07QX7Wlf3quCZTgkGRdrXNc1GcPVZImS5Lz0COlVnJVVCkeP7By7bIhBR7t699WDTvQ31wexyEq09StK0SXpMl5TbQlhWFckaeTYnDUzfMGYprU2z7fmRXaOEIyHYWJ5zct/H2A0Bp2RsG7MSFsaAAF8gA===',
    'в':
        'N4IgbgpgTgLglgYwgZxALgAQG0sAYB0ALADQYEDMAjKQbgKwC6peR1Z+l5N+uT2FATm6EATN3p8W5Me0IA2cY2YFCbWkPa9l+KsIDsiyRQOySmpfx0baCzUauLx98tZ2Ht5M7TU9nM704etip07pa6moGWXjoxEtq4JrRRLIn6KQQirtJhLFnpdh4+hEm+Hv5EwWXhobK1tM5VhPXVUqWEcc6uohlE3C69+ew+8ZZDBJQjFnlNU/YiABziS+bz7bkq/S1a0VsbfeyeveQrmRWjLDHkXIVj2aUXm4cja8L7A4fHI++lIg/Ov3+2iurke+HGHG200yDyqYMW/VB0PB5yh81OPAxYKO7BE23sVxutGREOu7yqIk62hEs3eGJE53m2ThyPIgP2MUZHhazQ53C5d36WORqm4lCB4VBLKZ/Sp0R84v2pLhMsOEry2SxXUcq2pGI+DT1iMGGLleXWt3Nb0tmVpNvB2TiJLthrGLp4zuELwSDyVrko0upOuJ8y9g356pUIyR8wpWo8cTmwP5fNxSv1Mep2QFeVNfv6RNamX9hZ2lwVpZJ/vxWbFKqNw0j4JaOcyWIeJJbSoeHdj4kDYyhSsrSpT9tR4dxvZ9BRDteGlecnLR1In47Durd/OF8xH4+607GGMVm7yQ/t5ApTtDadPtv7g1hj/ETYRmlfWPjR+Wg39x3OSaCsM3rhOyqx8CAEAACYAOYoOg2ALLgpCTLY5DIRgJykEMhArJMNwLLUlB4RoIhsAypB6CsegmDcdArDcIgYXIthyLRMiUGYCw3JQaQYLUNx6GwegyDS2EmHotR0GwtgiARtiUH8KEyLYegaLxKwCBhJ4ntJpB0IJJhcWYkzqfQpByCsCysRoCy2RZDEyBEGkoZQtQLGwJT6QpQx0AJtgaHQCm4DxuAcXJylmAIeG4NpGHWdhKwGaQHSkEhpACGw6EoWYdDMdhKFEaxNxyERpEYRRGARVVZh4spnm1HIGh6BhOILAxKxvm5lHqQGGUmAsJhyFFxk0BlrnacRynhSVMhGeFGiEBhakWUNZnhRhhC9ZNMgLLtSUmAItQCD5tS4WlbC8bY51VddJiTORKU3JeFnaZSynHQFA2LcFrlpVZRn3bgJm4KREn3YpKVEbgWXPQJtFmRDoVsAIvUcXxvGLSDeHXYFMh0PjZhUWlc1SbUeiCSZU2YaNGByDI8gZZdlC2SjGECHNc08WJGCKUlGHMSNrnM1TVMSapMWTepZHTRlMXHYdKxyPF6kpWrGD3UMkzxShk0oTxPFFShnUVeRjFU8FrWwxZjVofDpAfKKGBOz0vPdfxusgzcrtbU9DsyKj2GBblJh0KHgUaHIMmXSTaV0Xhc3LcJROyQJMk3BzcdpURnAoZrRlxdDwUKZMGUZznmtvURPMCNzVnHbwAC+QA',
    '4':
        'N4IgbgpgTgLglgYwgZxALgAQG0sAYB0ArAMwA0GBATOQbgLrl74AsAbDftRfvYwWx1yCG2AsTLchkkU3EcutGbXbcFPJTxVUA7ML7453Lev0Cje0S2OVd0/SXm3F+wzouyJBQmt6WAjJ6cTiaWDqqChBpmVBFRxlK0kS6BCTxJlq6csfq41tmWuY75Hhzx6UzR+GVxRZLlXoE2xWKNwbj1BoHezfgBtYl0IiAQACYA5ijoouR+M+RclAsSlLMYi/OE8yqbGCoqtrYAHOTHGACcG/O2fip+19enfszzzxh+q35cfo8Xa8uv7xmyykKxeMxB5AkTxmOz8v0oUgkrykfhRsJUrx2v1R5HhUNsyxmKgR5G2M3hty+q0oO1BGFs6wwj1OANhNBmryab2IdAAvkA==',
  };
}
