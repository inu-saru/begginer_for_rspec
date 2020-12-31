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
user_duplicated_email = User.new(
  first_name: 'Jiro',
  last_name: 'Sato',
  email: 'tester@example.com'
)
user_duplicated_email.valid?
expect(user_duplicated_email.errors[:email]).to include('has already been taken')
```

### 練習問題
Userモデルにおけるpendding状態のテストを完成させてください。

```
$ rspec ./spec/models/user_spec.rb
```

正解は下記コミットです。
commit: a49ce282ac3b4d652ab963f159c7f4cfff6d2604

## インスタンスメソッド・クラスメソッドのテスト
モデルtのメソッドのテストを行います。

### commit
```
85fc6e07d1bb89c99469268c0167b84eea445c0a
```
### インスタンスメソッドのテスト
インスタンスメソッドnameは、first_nameとlast_nameを繋げて指名を返すメソッドです。テストは下記の流れで行います。

- インスタンスを立てる
- インスタンスメソッドを呼び、コンストラクタに渡した属性値と合致しているかを確認する

```
user1 = User.new(
  first_name: 'Taro',
  last_name: 'Yamada',
  email: 'tester@example.com'
)
expect(user1.name).to eq 'Taro Yamada'
```

### クラスメソッドのテスト
クラスメソッドall_namesは全ての氏名を返します。テストは下記の流れで行います。

- 必要に応じてfixutureをセット
- クラスメソッドを呼び出して、戻り値をチェック

```
user1 = User.create(
  first_name: 'Taro',
  last_name: 'Yamada',
  email: 'tester@example.com'
)
user2 = User.create(
  first_name: 'Jiro',
  last_name: 'Sato',
  email: 'tester2@example.com'
)
expect(User.all_names).to include 'Taro Yamada'
expect(User.all_names).to include 'Jiro Sato'
```

### 練習問題
Userモデルにおけるpendding状態のテストを完成させてください。

```
$ rspec ./spec/models/user_spec.rb
```

# モデルのテストのリファクタリング
ここでは、Userモデルのテストをリファクタリングしていくことで、下記のことを学びます

- describe, contextでのグルーピング
- let関数
- beforeでのfixtureの設置

## commit
下記のコミットIDから初めてください。
```
$ git reset --hard 3587f63c74a6372b22b976a5e28b8ce59a2704fe
```

## describe, contextでのグルーピング
現在のテストファイルは、１階層で表現されているため、テスト全体として可読性が劣っています。

これをグルーピングしていくとで、可読性・メンテナンス性を高めます。

### describe
現在の問題の１つは、validationテストやメソッドのテストが一緒くたに記述されていることです。

describeは、これらのテスト対象を区別するために使用します。

### context
現在のテストでは「~~の場合、...であること」のようになっているexampleがあります。

contextは、「~~の場合」のような場合分けしている部分を区切るために使用します。

*現時点ではexampleが少ないので問題ないように見えますが、「~~場合」の部分は将来的に重複していくので最初からcontextを使用しといたほうが無難だと考えてます。

### 練習問題
1. describe を利用して下記３点のグルーピングしてください。
    - validation
    - name
    - all_names

1. context を利用して場合訳をしてください。

*回答コミット

1. b140f1754ff34a43f5de2bed5ff5a54b39394763
1. 2b492970938f86db2cae445d395a465f91f76da8

## let関数
現在のテストは、user1のようなコードの重複が多く見られます。テストにおいて過度にDRYを意識する必要はないですが、あるていどdryにすることで、可読性をあげることができます。

let関数は、テストで利用できるインスタンス変数的な動きをします。

*letとlet!で動きが違いあります。letはテストコード内で呼び出されたタイミングで実行され、let!はテスト実行時と同じタイミングで実行されます。

before
```
it '無効な状態であること' do
  user1 = User.new(
    first_name: 'Taro',
    last_name: 'Yamada',
    email: 'tester@example.com'
  )
  user1.save
  user_duplicated_email = User.new(
    first_name: 'Jiro',
    last_name: 'Sato',
    email: 'tester@example.com'
  )
  user_duplicated_email.valid?
  expect(user_duplicated_email.errors[:email]).to include('has already been taken')
end
```

after
```
it '無効な状態であること' do
  user1.save
  user_duplicated_email = User.new(
    first_name: 'Jiro',
    last_name: 'Sato',
    email: user1.email
  )
  user_duplicated_email.valid?
  expect(user_duplicated_email.errors[:email]).to include('has already been taken')
end
```

letを使うことでDRYになる以外にも、user1.emailみたいに使うことで、同じemailを利用していることが明確になります。

ただし、過度にDRYにすることでuser1の内容を確認しくくなることがあります。user1を見るためにめっちゃスクロールせなあかんみたいになら、可読性が落ちているので、あえて重複させとくのはありです。そこらへんはいい塩梅でやってください。

### commit
```
a19afcc70f392d30c7646809c68d84742e3cdb83
```

### 練習問題
1. user1をletを利用して重複コードをなくしてください。
1. user_first_name_nil, user_last_name_nil, user_duplicated_email, user2についてもletにしてください。

*解答コミット
1. 4c52f3b2a51aac600e76a03e8bdce9231cf05399
1. e06b4e989f8095a2f2153cc334aa984ab2fb5f33

## beforeでのfixtureの設置
beforeはdescribe内、context内に設置できます。
設置した階層が開始されるタイミングで実行されます。

前提条件として作成するレコードの処理などを、beforeで実行することでテストで確認すべきところが明確になります。

before
```
context 'Userレコードがある場合' do
  it '全ての指名リストが返ること' do
    user1.save
    user2.save
    expect(User.all_names).to include 'Taro Yamada'
    expect(User.all_names).to include 'Jiro Sato'
  end
end
```

after
```
context 'Userレコードがある場合' do
  before do
    user1.save
    user2.save
  end

  it '全ての指名リストが返ること' do
    expect(User.all_names).to include 'Taro Yamada'
    expect(User.all_names).to include 'Jiro Sato'
  end
end
```

it内がすっきりするほか、各contextごとの違いが明確になる。

### 練習問題
saveしているところをbefore内に移してください。

正解コミット: c48f1c31c4daf84d275e03af75fd49997d9db24c

# モデルのテストのリファクタリング2
ここではfactory gemを利用してさらにリファクタリングをしていく。

## commit
```
c48f1c31c4daf84d275e03af75fd49997d9db24c
```

## factory
現在、テストコード内でUserの属性値をベタ書きしてnewしているが、Factoryを利用して、名前の属性値や、emailを自動で作ってもらう感じにするのが狙いです。

*今は数が少ないので気にならないかもですが、大量のfixtureをセットすることになるので、最初からfactoryを利用するのが良いと思います。

### factoryファイルの作成
./spec/factories/users.rb
```
FactoryBot.define do
  factory :user do
    first_name { 'Taro' }
    last_name { 'Yamada' }
    email { 'tester@example.com' }
  end
end
```

上記のように属性値を記述することで下記のコマンドでインスタンスを立てたり、createすることができます。

```
$ FactoryBot.build(:user)
=> #<User:0x0000564615c47578 id: nil, first_name: "Taro", last_name: "Yamada", email: "tester@example.com", created_at: nil, updated_at: nil>
```

ただしこのままだと、毎回同じ内容のインスタンスが立つので意味がないです。

FFaker gemを利用して、呼び出し毎に属性値がランダムで生成されるようにしていきます。

./spec/factories/users.rb
```
FactoryBot.define do
  factory :user do
    first_name { FFaker::NameJA.first_name }
    last_name { FFaker::NameJA.last_name }
    email { FFaker::Internet.email }
  end
end
```

これで呼び出し毎に属性値がランダムで生成されるようになります。

```
$ FactoryBot.build(:user)
=> #<User:0x00005634877a9678 id: nil, first_name: "昭", last_name: "小野", email: "lynnette_borer@roobwehner.info", created_at: nil, updated_at: nil>

$ FactoryBot.build(:user)
=> #<User:0x000056348a87b198 id: nil, first_name: "颯太", last_name: "山下", email: "doretta@baileyrenner.name", created_at: nil, updated_at: nil>
```

## 練習問題
1. Userのfactoryを作成してください。
1. テストコードをfacotryメソッドを利用してリファクタリングしてください。

解答コミット
1. 5f63f2ff563155cc8d2c56af9131b414e72cae68
1. c81a2aa25251fbb01eb63f5ffc13697ada8383ab

# APIのテスト
ここではAPIを通して、コントローラーのテストを行います。
コントローラーのテストで行うのは下記の３点です。

- pathが通ること
- responseの内容を確認する
- DBに影響を与える場合は、その変化を確認する

## branch
05/setup

## GETのテスト
GETのテストは下記の流れで行ってます。

- httpリクエスト
- response.statusの確認
- response.bodyの確認

```
it 'success/200' do
  get api_v1_user_path(user1.id)

  expect(response).to be_successful
  expect(response.status).to eq 200

  json = JSON.parse(response.body)
  expect(json['name']).to eq user1.name
  expect(json['email']).to eq user1.email
end
```

## POSTのテスト
POSTのテストは下記の流れで行ってます。

- httpリクエスト
- tableの変化を確認
- responseの確認

```
it '正しくレコードが作成されること' do
  expect do
    post api_v1_users_path, params: params1
  end.to change(User, :count).by(1)

  json = JSON.parse(response.body)
  expect(json['name']).to eq "#{params1[:user][:first_name]} #{params1[:user][:last_name]}"
  expect(json['email']).to eq params1[:user][:email]
end
```

## 練習問題
下記のpenndingを実装してください。
```
$ rspec ./spec/requests/api/v1/users_spec.rb
```

解答branch: 05/api