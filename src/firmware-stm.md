# ファームウェアの書き込み方（STM32搭載キーボード用）

## 対象キーボード

MCUにSTM32を採用した下記のキーボードが対象です。

- [Neige](./neige.html)

##

ファームウェアの初期化や更新は下記の手順で行えます。



2. [QMK Toolbox](https://qmk.fm/toolbox)をインストールします。
3. QMK Toolboxを起動します。
4. NeigeからUSBケーブルを取り外し、コンピュータと接続されていない状態にします。
5. Neigeの一番左上のキーを**押しながら**USBケーブルでNeigeとコンピュータを接続、もしくはNeige基板裏面のBOOTボタンを**押しながら**USBケーブルでNeigeとコンピュータを接続します。
6. QMK Toolboxに`STM32 DFU device connected (WinUSB): STMicroelectronics STM32  BOOTLOADER `と表示されたことを確認します。これが表示されていない場合は手順4をやり直してください。
7. QMK Toolboxの`Open`ボタンを押して、書き込むファームウェアのファイルを選択してください。
8. QMK Toolboxの`Flash`ボタンを押してください。ファームウェアの書き込みが始まるのでメッセージ表示が止まるまで待ってください。
9. QMK Toolboxに`Flash complete`と表示されればファームウェアの書き込みは成功です。