# Rails app to study Stripe

[Stripe](https://stripe.com/jp)の調査のためのRailsアプリ。

次のことができる。

- 決済（/charges/new）
- 決済一覧の表示（/charges）
- 決済の払い戻し
- カスタマ一覧/詳細の表示(/customers)
- カスタマへのカード番号に追加/削除

ユーザ認証もなく決済やカスタマーの一覧を表示したりしている。
また、CustomerやSource、ChargeなどのStripeの永続的リソースのIDをURLの一部に使ったり
HTMLソースを見れば分かる形で実装しているが、それらはプロダクションレベルではNGだと思う。

このアプリケーションはあくまで、StripeのAPIの使い方を確認するための習作なのでそういうことでよろしく。

## 立ち上げ方

Stripeの`PUBLISHABLE_KEY`と`SECRET_KEY`を用意してください。<br>
Railsの起動時に環境変数で`PUBLISHABLE_KEY`と`SECRET_KEY`を与えてください。

次の例では直接変数を指定していますが、[direnv](https://github.com/direnv/direnv)などを使うと便利だと思います。

```bash
$ git clone https://github.com/morishita-ai/study-stripe.git
$ cd study-stripe
$ bundle install
$ PUBLISHABLE_KEY=XXXXX SECRET_KEY=XXXXX bundle exec rails c
```



立ち上がったら https://localhost:3000/charges/new にアクセスしてください。
