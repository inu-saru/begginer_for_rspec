# 環境構築
```
$ docker-compose build
$ docker-compose up
$ docker-compose run web rake db:create
```
http://localhost:3000/
でアクセス可能

# 概要
rspecを初めて触る人向けの資料として作成しています。</br>
テストを作成するために、基礎的なスキル習得を目指しています。

## テストのコーディングについて
テストコードと実装コードは、どういったコーディングあ良いかとう考え方に違いがあります。

テストコードにおいての、意識するべきところ、意識しなくて良いところをまとめます。

## テストにおいて意識すべきところ
- テストは信頼できるものであること
- テストは簡単に書けること
- テストは簡単に理解できること（今日も将来も）

## テストにおいて意識しなくてよいところ
- テスト自体の実行スピードは重視しない
- テストの中では過度にDRYなコードを目指さない。なぜならテストにおいてはDRYでないコードは必ずしも悪とは限らないからです

## Rspecに置ける記述方法のベストプラクティス
Rspecに置けるコーディングのベストプラクティスをまとめる

- 期待する結果をまとめて記述（describe)。対象がモデルなら、どんなモデルなのか、そしてどんな振る舞いをするのかということを説明する。
- example（ it で始まる1行）一つにつき、結果を一つだけ期待する。失敗した時に特定しやすくするため。
- どのexampleも明示的である。
- 各exampleの説明は動詞で始まっている。shouldではない。User is invalid without a first name （名がなければユーザーは無効な状態である）、 User is invalid without a last name （姓がなければユーザーは無効な状態である）

# モデルのテスト
モデルでテストする点をまとめると下記の３点です。

- 有効な属性で初期化された場合は、モデルの状態が有効（valid）になっていること
- バリデーションを失敗させるデータであれば、モデルの状態が有効になっていないこと
- クラスメソッドとインスタンスメソッドが期待通りに動作すること

## commit]
下記のコミットIDから初めてみてください。
```
$ git reset --hard cc7bf6fd79b3c8f9344642ff1247a12ef170087d
```
## Userモデルについて
今回は、Userモデルのテストを行います。
Userモデルの構成は下記の通りです。

|name|名前|type|valid|default|desc|
|--|--|--|--|--|--|
|first_name|名前|string|presence: true|||
|first_name|苗字|string|presence: true|||
|email|メール|string|unique: true|''||

### Userモデルのテストファイルについて
モデルのテストファイルは下記のディレクトリです。

./spec/models/user_spec.rb

## validationのテスト
モデルのテストでやることは、validationとパブリックメッソドのテストです。</br>
ここではvalidationのテストを行います。

commit:

### 有効な属性で初期化された場合は、モデルの状態が有効（valid）になっていること
Userのインスタンスを立てて、validになっているかを確認してください。
テストして行うのは、下記の感じです。

1. 正しい属性値でUserインスタンスを立てる
1. 立てたインスタンスのvalidをチェックする

```
user1 = User.new(
  first_name: 'Taro',
  last_name: 'Yamada',
  email: 'tester@example.com'
)
expect(user1).to be_valid
```

### バリデーションを失敗させるデータであれば、モデルの状態が有効になっていないこと
Userのインスタンスを立てて、invalidになっているかを確認してください。
テストして行うのは、下記の感じです。

1. 不正な属性値でUserインスタンスを立てる
1. 立てたインスタンスのvalidをチェックする
1. エラーメッセージをチェックする

```
user1 = User.new(
  first_name: nil,
  last_name: 'Yamada',
  email: 'tester@example.com'
)
user1.valid?
expect(user1.errors[:first_name]).to include("can't be blank")
```

* expect(...).not_to ~~: not_toにすることで期待値が反転するところに注意してください。
* エラーメッセージはvalidの確認をしたタイミングでセットされます。user1.valid?みたいなことやれば入る感じです。

#### 重複などの前提条件が必要な場合
emailのようにuniqueの状態をしたい場合は、expectする前にfixtureとしてデータを整えればいいです。

1. user1としてレコードに保存する
1. user1と同じ属性値でインスタンスをたてる
1. 立てたインスタンスのinvalidをチェックする

```
user1 = User.new(
  first_name: 'Taro',
  last_name: 'Yamada',
  email: 'tester@example.com'
)
user1.save
user2 = User.new(
  first_name: 'Jiro',
  last_name: 'Sato',
  email: 'tester@example.com'
)
user2.valid?
expect(user2.errors[:email]).to include('has already been taken')
```

## 練習問題
Userモデルにおけるpendding状態のテストを完成させてください。

```
$ rspec ./spec/models/user_spec.rb
```

正解は下記コミットです。
commit: a49ce282ac3b4d652ab963f159c7f4cfff6d2604

# モデルのテストのリファクタリング
