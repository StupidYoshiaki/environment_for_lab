# Docker環境構築
## イメージのビルド
```bash
$ docker build -t "イメージの名前" .
```
## コンテナの立ち上げ
```bash
$ docker run --gpus all -it --name "コンテナの名前" -v $(pwd):/workspace "イメージの名前" /bin/bash
```



# uvでPython環境構築
Docker環境でuvを使ってPythonの開発環境を構築する。  
とりあえずコンテナに入ってプロジェクトを作成する方針です。

## uvのインストール
```bash
$ curl -LsSf https://astral.sh/uv/install.sh | sh
$ echo 'source $HOME/.cargo/env' >> ~/.bashrc
$ source ~/.bashrc
```

## uvでプロジェクトの新規作成
```bash
$ uv init --app
```

## Pytorchの入れ方
まず、pyproject.tomlに以下の記述を追加する。
```toml
[tool.uv]
extra-index-url = ["https://download.pytorch.org/whl/cu117"]
```
その後、以下のコマンドを実行する。
```bash
$ uv add "torch==2.0.1+cu117"
```

[参考サイト](https://zenn.dev/turing_motors/articles/594fbef42a36ee)