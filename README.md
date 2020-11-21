# Rails app to study Stripe

[Stripe](https://stripe.com/jp)の調査のための Rails アプリ。

次のことができる。

- 決済（/charges/new）
- 決済一覧の表示（/charges）
- 決済の払い戻し
- カスタマ一覧/詳細の表示(/customers)
- カスタマへのカード番号に追加/削除
- サブスクリプションの登録/解約
- Webhook の受信

また、本アプリケーションの実装に見られる以下の項目はプロダクションレベルでは NG だと思うので真似しないように。

- ユーザ認証もなく決済やカスタマーの一覧を表示したりしている。
- Customer や Source、Charge などの Stripe の永続的リソースの ID を URL の一部に利用している
- Customer や Source、Charge などの Stripe の永続的リソースの ID が HTML ソースに露出している

このアプリケーションはあくまで、Stripe の API の使い方を確認するための習作なのでそういうことでよろしく。

## 立ち上げ方

Stripe の `PUBLISHABLE_KEY` と `SECRET_KEY` を用意してください。<br>
Rails の起動時に環境変数で `PUBLISHABLE_KEY` と `SECRET_KEY`を与えてください。

次の例では直接変数を指定していますが、[direnv](https://github.com/direnv/direnv)などを使うと便利だと思います。

```bash
$ git clone https://github.com/morishita-ai/study-stripe.git
$ cd study-stripe
$ bundle install
$ PUBLISHABLE_KEY=pk_test_XXXXX SECRET_KEY=sk_test_XXXXX bundle exec rails c
```

立ち上がったら https://localhost:3000 にアクセスしてください。

## Webhook受信を利用する場合の起動方法

まず、事前準備として[Stripe CLI](https://stripe.com/docs/stripe-cli)をインストールして、ログインしてください。

ログインしたら次のコマンドを実行してください。

```bash
$ stripe listen --forward-to localhost:3000/webhook
A newer version of the Stripe CLI is available, please update to: v1.5.5
> Ready! Your webhook signing secret is whsec_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX (^C to quit)
```
signing secret (文字列 `whsec_XXXXXXX` がそれ) が表示されます。
その値を次の様に環境変数 `STRIPE_WEBHOOK_ENDPOINT_SECRET` にセットして Rails を起動してください。

```bash
$ PUBLISHABLE_KEY=pk_test_XXXXX SECRET_KEY=sk_test_XXXXX STRIPE_WEBHOOK_ENDPOINT_SECRET=whsec_XXXXXXXX bundle exec rails c
```

起動したら http://localhost:3000/webhook にアクセスしてください。
Stripe CLI を使ってイベントを発生させると、受信した Stripe Event をページに表示します。

```bash
> stripe trigger payment_intent.created
```
