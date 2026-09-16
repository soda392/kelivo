// ============================================================================
//  cute_bubbles.dart
//  把「Cute Bubbles」的 21 张点九气泡皮肤接进 Kelivo
//
//  用法（3 步）：
//   1. 把 PNG 放进 Kelivo 的 assets/cute_bubbles/  （见文件末尾说明）
//   2. 在 pubspec.yaml 里声明这个目录
//   3. 用 CuteBubble 组件替换 chat_surface.dart 里的气泡容器
//
//  原理：
//   - 点九「跟着文字长」= Flutter 的 DecorationImage.centerSlice
//   - capInsets    → centerSlice
//   - contentInsets→ Padding（文字该落在哪）
//   - 对方那一侧   → 只把"背景"水平镜像，文字镜像回来
// ============================================================================

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// 1. 数据模型
// ---------------------------------------------------------------------------

@immutable
class CuteBubbleSkin {
  const CuteBubbleSkin({
    required this.id,
    required this.name,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.capTop,
    required this.capLeft,
    required this.capBottom,
    required this.capRight,
    required this.contentTop,
    required this.contentLeft,
    required this.contentBottom,
    required this.contentRight,
  });

  final String id; // 文件名（不含 .png）
  final String name; // 中文名

  // 原始 @3x 图片的像素尺寸
  final double pixelWidth;
  final double pixelHeight;

  // 点九保护区（单位 pt；原图是 @3x）
  final double capTop, capLeft, capBottom, capRight;

  // 文字内边距（单位 pt）
  final double contentTop, contentLeft, contentBottom, contentRight;

  String get assetPath => 'assets/cute_bubbles/$id.png';

  /// 未镜像时的文字内边距
  EdgeInsets get contentInsets =>
      EdgeInsets.fromLTRB(contentLeft, contentTop, contentRight, contentBottom);

  /// 镜像时左右对调
  EdgeInsets get contentInsetsMirrored =>
      EdgeInsets.fromLTRB(contentRight, contentTop, contentLeft, contentBottom);

  /// ★ 关键：点九切片。
  ///
  /// 【前提】assets 里放的是**缩到 1x 的图**（px = 原图 / 3），
  /// 所以解码后的逻辑尺寸 = pixelWidth/3 × pixelHeight/3，
  /// centerSlice 的坐标就用 pt 值即可。
  ///
  /// 如果你直接把 @3x 原图丢进 assets（1x），
  /// 请把下面 *3 打开、并去掉 /3，见注释。
  Rect get centerSlice => Rect.fromLTRB(
        capLeft,
        capTop,
        pixelWidth / 3 - capRight,
        pixelHeight / 3 - capBottom,
      );
  // —— 用 @3x 原图时改成：
  // Rect get centerSlice => Rect.fromLTRB(
  //       capLeft * 3,
  //       capTop * 3,
  //       pixelWidth - capRight * 3,
  //       pixelHeight - capBottom * 3,
  //     );
}

// ---------------------------------------------------------------------------
// 2. 皮肤清单（数据来自仓库 bubbles.json）
// ---------------------------------------------------------------------------

const List<CuteBubbleSkin> cuteBubbleSkins = <CuteBubbleSkin>[
  CuteBubbleSkin(id: 'halo-pink',   name: '光环粉', pixelWidth: 425, pixelHeight: 180, capTop: 32.0, capLeft: 50.3, capBottom: 25.0, capRight: 51.0, contentTop: 14.3, contentLeft: 22.3, contentBottom: 17.0, contentRight: 23.0),
  CuteBubbleSkin(id: 'halo-blue',   name: '光环蓝', pixelWidth: 433, pixelHeight: 180, capTop: 33.3, capLeft: 52.4, capBottom: 23.7, capRight: 50.7, contentTop: 15.3, contentLeft: 23.7, contentBottom: 14.7, contentRight: 22.0),
  CuteBubbleSkin(id: 'halo-gray',   name: '光环灰', pixelWidth: 426, pixelHeight: 180, capTop: 31.3, capLeft: 50.3, capBottom: 25.7, capRight: 51.0, contentTop: 19.0, contentLeft: 22.0, contentBottom: 14.7, contentRight: 22.7),
  CuteBubbleSkin(id: 'halo-silver', name: '光环银', pixelWidth: 426, pixelHeight: 180, capTop: 33.0, capLeft: 50.6, capBottom: 24.0, capRight: 50.6, contentTop: 15.0, contentLeft: 22.3, contentBottom: 15.3, contentRight: 22.3),
  CuteBubbleSkin(id: 'cloud',       name: '云朵',   pixelWidth: 405, pixelHeight: 180, capTop: 35.3, capLeft: 49.7, capBottom: 21.7, capRight: 51.1, contentTop: 22.0, contentLeft: 26.3, contentBottom: 15.0, contentRight: 27.7),
  CuteBubbleSkin(id: 'comic',       name: '漫画框', pixelWidth: 330, pixelHeight: 180, capTop: 25.7, capLeft: 39.0, capBottom: 31.3, capRight: 40.0, contentTop: 14.0, contentLeft: 18.0, contentBottom: 21.7, contentRight: 19.0),
  CuteBubbleSkin(id: 'pixel-cat',   name: '像素猫', pixelWidth: 392, pixelHeight: 180, capTop: 32.0, capLeft: 45.2, capBottom: 25.0, capRight: 51.5, contentTop: 17.7, contentLeft: 22.0, contentBottom: 17.3, contentRight: 28.3),
  CuteBubbleSkin(id: 'pink-cat',    name: '粉猫',   pixelWidth: 419, pixelHeight: 180, capTop: 33.3, capLeft: 60.5, capBottom: 23.7, capRight: 47.1, contentTop: 21.0, contentLeft: 38.7, contentBottom: 16.0, contentRight: 25.3),
  CuteBubbleSkin(id: 'bow-cat',     name: '结猫',   pixelWidth: 394, pixelHeight: 180, capTop: 29.7, capLeft: 47.9, capBottom: 27.3, capRight: 53.9, contentTop: 17.7, contentLeft: 28.0, contentBottom: 21.7, contentRight: 34.0),
  CuteBubbleSkin(id: 'peek-cat',    name: '趴猫',   pixelWidth: 423, pixelHeight: 180, capTop: 32.3, capLeft: 48.3, capBottom: 24.7, capRight: 55.6, contentTop: 20.0, contentLeft: 22.7, contentBottom: 9.0,  contentRight: 30.0),
  CuteBubbleSkin(id: 'rain-bear',   name: '雨熊',   pixelWidth: 469, pixelHeight: 180, capTop: 31.0, capLeft: 56.2, capBottom: 26.0, capRight: 58.6, contentTop: 10.0, contentLeft: 27.3, contentBottom: 13.0, contentRight: 29.7),
  CuteBubbleSkin(id: 'moon-bunny',  name: '月亮',   pixelWidth: 378, pixelHeight: 180, capTop: 16.7, capLeft: 52.1, capBottom: 40.3, capRight: 47.1, contentTop: 15.7, contentLeft: 34.3, contentBottom: 26.0, contentRight: 29.3),
  CuteBubbleSkin(id: 'nurse',       name: '护士',   pixelWidth: 379, pixelHeight: 180, capTop: 29.3, capLeft: 42.1, capBottom: 27.7, capRight: 51.4, contentTop: 15.3, contentLeft: 19.7, contentBottom: 15.3, contentRight: 29.0),
  CuteBubbleSkin(id: 'sailor',      name: '水手',   pixelWidth: 423, pixelHeight: 180, capTop: 27.0, capLeft: 55.2, capBottom: 30.0, capRight: 52.8, contentTop: 11.3, contentLeft: 32.7, contentBottom: 11.3, contentRight: 30.3),
  CuteBubbleSkin(id: 'snow',        name: '雪天',   pixelWidth: 411, pixelHeight: 180, capTop: 34.7, capLeft: 49.8, capBottom: 22.3, capRight: 52.8, contentTop: 22.7, contentLeft: 26.3, contentBottom: 12.0, contentRight: 29.3),
  CuteBubbleSkin(id: 'paw',         name: '肉垫',   pixelWidth: 383, pixelHeight: 180, capTop: 29.3, capLeft: 40.8, capBottom: 27.7, capRight: 53.1, contentTop: 18.0, contentLeft: 17.7, contentBottom: 19.3, contentRight: 30.0),
  CuteBubbleSkin(id: 'bird',        name: '小鸟',   pixelWidth: 331, pixelHeight: 180, capTop: 20.0, capLeft: 41.9, capBottom: 37.0, capRight: 40.6, contentTop: 9.0,  contentLeft: 23.3, contentBottom: 20.3, contentRight: 22.0),
  CuteBubbleSkin(id: 'fish',        name: '小鱼',   pixelWidth: 322, pixelHeight: 180, capTop: 24.7, capLeft: 39.4, capBottom: 32.3, capRight: 39.4, contentTop: 13.3, contentLeft: 20.3, contentBottom: 24.0, contentRight: 20.3),
  CuteBubbleSkin(id: 'rain',        name: '下雨',   pixelWidth: 413, pixelHeight: 180, capTop: 33.3, capLeft: 51.1, capBottom: 23.7, capRight: 55.8, contentTop: 20.0, contentLeft: 30.3, contentBottom: 15.7, contentRight: 35.0),
];

CuteBubbleSkin? cuteBubbleSkinById(String id) {
  for (final s in cuteBubbleSkins) {
    if (s.id == id) return s;
  }
  return null;
}

// ---------------------------------------------------------------------------
// 3. 气泡组件
// ---------------------------------------------------------------------------

/// 一个点九皮肤气泡。
///
/// [mirrored] = true 时用于「对方」那一侧：
///   - 背景图水平镜像
///   - 左右内边距对调
///   - 文字本身不镜像
class CuteBubble extends StatelessWidget {
  const CuteBubble({
    super.key,
    required this.skin,
    required this.child,
    this.mirrored = false,
    this.maxWidth,
  });

  final CuteBubbleSkin skin;
  final Widget child;
  final bool mirrored;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets insets =
        mirrored ? skin.contentInsetsMirrored : skin.contentInsets;

    final BoxDecoration decoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage(skin.assetPath),
        centerSlice: skin.centerSlice, // ★ 点九：四角钉死，中间拉伸
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    );

    Widget background = DecoratedBox(
      decoration: decoration,
      child: const SizedBox.expand(),
    );

    if (mirrored) {
      background = Transform.flip(flipX: true, child: background);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: background),
          Padding(padding: insets, child: child),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. 怎么接进 Kelivo（照着抄就行）
// ---------------------------------------------------------------------------
//
// ▶ 第一步：资源
//   把 PNG 放到  Kelivo/assets/cute_bubbles/
//   ★ 注意：代码里的 centerSlice 假设放的是【1x 图】，
//     也就是把原图（@3x）缩到 1/3 再放进去。
//     如果你就想用原图，请打开上面被注释的那份 centerSlice。
//
//   然后在 pubspec.yaml 的 flutter: 下面加：
//
//     flutter:
//       assets:
//         - assets/cute_bubbles/
//
// ▶ 第二步：在 chat_surface.dart 里加一个分支
//
//   现在 buildSharedChatSurface() 只画纯色/毛玻璃。
//   把「图片皮肤」当成第 4 种样式加进去：
//
//     final skin = cuteBubbleSkinById(overrides.skinId);   // 你新增的字段
//     if (skin != null) {
//       return CuteBubble(
//         skin: skin,
//         mirrored: !isUser,          // 对方那侧镜像
//         maxWidth: ...,              // 交给外层约束
//         child: Padding(padding: padding, child: child),
//       );
//     }
//     // ... 下面保留原来的 frosted / solid / default 分支
//
//   ⚠️ 注意：CuteBubble 自己会加 contentInsets 的 padding，
//      所以外面那层 padding 记得换成 EdgeInsets.zero，
//      否则文字会离边框太远。
//
// ▶ 第三步：选项存进设置
//   在 ChatBubbleStyleOverrides 里加一个字段，比如：
//
//     final String? skinId;   // null = 不用皮肤，走原来的纯色逻辑
//
//   照着现有的 toJson / fromJson / copyWith / == 补一遍即可
//   （这个文件写得很规整，加字段不难）。
//
// ---------------------------------------------------------------------------
// ⚠️ 许可提醒
//   Cute Bubbles 是「保留所有权利」，不是开源许可证：
//     个人自用 ✅   发布 / 分发 / 商用 ❌（须先取得作者书面许可）
//   自己用没问题；一旦要发出去，请先去仓库开 issue 问授权，
//   或者用 tools/measure.py 给你的【原创】气泡图量点九。
// ---------------------------------------------------------------------------
