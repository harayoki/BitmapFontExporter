BitmapFontExporter
==================

Flashのタイムライン上にならべた自由なデザインの文字をビットマップフォントに変換するツールです。
書き出したデータは(Glyph Designer互換なので)、cocos2D系、Unity(NGUI)、Flash/AIR(Starlng)など
さまざまなゲームライブラリ/フレームワークから利用する事ができます。

メジャーなビットマップフォント書き出しツールであるGlyph DesignerやBMFontなどはフォントファイルを読み込んで、
デザインをツール上で調整してビットマップフォントに変換します。長所としては一括して大量の文字を変換できる、
フォントとして細かい調整を行える、プレビューがしっかりしている、等があります。
短所としては、有料であったり、実行プラットフォーム(win/mac)を選んだり、デザインのカスタマイズ製に限界がある、などです。

BitmapFontExporterは機能的にはそれらのツールにだいぶ劣りますが、文字の見た目はFlash上で編集できるため、
テキストに自由なフィルタをかけたり、文字ごとに色を変更したり、はたまたパスで１から文字を書き起こしたり、オリジナルな絵文字を作って配置する事もできます。
(もちろん、デザイン素材としては、IllustratorやPhotoshopのデータを取り込む事もできます。)

文字の種類は、数字/英数字だけしかつかわないけれど、装飾を豪華にしたフォントを書き出したいような場面で使う事が想定されています。

ツール ダウンロード
==================

以下(このリポジトリ内です)から入手できます。

https://github.com/harayoki/BitmapFontExporter/raw/master/Exporter.air


できる事
=========

* Glyph Designer互換データの書き出し (fntファイル(xml or text) + pngファイル)
* 文字コード指定 (英数字以外のひらがなカタカナ漢字を扱う事もできます、量があると大変ですが)
* 倍率を指定したデータ書き出し
* 等幅でないフォント書き出し
* 文字詰めの簡単な指定
* png書き出し簡易プレビュー

![フォント適用例](https://raw2.github.com/harayoki/BitmapFontExporter/master/html/cap3.png)

多色でデザインされた文字は、幅がそれぞれ調整され(等幅フォントではない)、文字同士は若干重ねて表示させられています。

<実際の動作デモ>

http://harayoki.github.io/BitmapFontExporter/html/WebSample.html

できない事
=========

* フォントファイル読み込み (デザイン素材は手動での配置となります)
* フォントプレビュー
* 書き出しpngサイズ自動計算
* フォント画像の賢いパッキング

※書き出したデータはまだFlash以外での環境で動作検証されていません。

今後対応？
=========

以下、要望があれば
* MaxRects法での画像パッキング
* 書き出しpngプレビューの充実
* フォントプレビュー
* サンプルフォントファイル(fla)の追加


簡単な使い方
=========

1.swf作成

![flash上画面](https://raw2.github.com/harayoki/BitmapFontExporter/master/html/cap2.jpg)

* flash上に一つMovieClipを作成し、フォント画像(パスでもテキストフィールドでもビットマップでも可能)を各フレームに配置します。
  レイヤーが複数にまたがっていても良いです。（上記の画像の例では、テキストにマスクを施して、帯状のカラーデザインを表現しています。)
* ラベルとして、Unicodeキャラクターコードを指定(0xをつけた16進数、または10進数)します。連番となる場合は省略が可能です。
* borderというインスタンス名で表示時の文字詰めに利用される矩形をしていするMovieClipを座標0,0に配置します。
  (各フレームで違う大きさにしてもしなくても良いですが、１つは配置してください。)
* clipというインスタンス名のMovieCLipで画像として書き出されるクリッピング領域の矩形をborderと同様に指定します。
  こちらの配置は任意なので、なければborderがclipでもあるとして使われます。
* swfをパブリッシュします。

2.ツール上作業

![ツール画面](https://raw2.github.com/harayoki/BitmapFontExporter/master/html/cap1.png)

* ツールを立ち上げあげ、作成したswfをドロップします。
* ツール上でフォントの縦幅、倍率、書き出しフォーマット等を指定します。
* 同様に書き出し画像サイズを調整します。(現在自動で調整されません。)プレビューボタンを押して画像の治まり具合を確認します。
* エクスポートボタンを押して、データを書き出すフォルダを指定します。

以上の作業で、fntファイルとpng画像を得る事ができます。

Enjoy!


