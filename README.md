# environment_for_lab
研究室で使う環境を構築するためのリポジトリ。Docker -> uvの順で環境を構築する。

## Docker
### イメージのビルド
```bash
$ docker build -t "イメージの名前" .
```
### コンテナの立ち上げ
```bash
$ docker run --gpus all -it --name "コンテナの名前" -v $(pwd):/workspace "イメージの名前" /bin/bash
```

## uv
uvでPythonの開発環境を構築する。Dockerコンテナに入ってからプロジェクトを作成する方針。

### uvのインストール
```bash
$ curl -LsSf https://astral.sh/uv/install.sh | sh
$ echo 'source $HOME/.cargo/env' >> ~/.bashrc
$ source ~/.bashrc
```

### uvでプロジェクトの新規作成
```bash
$ uv init --app
```

### Pytorchの入れ方
これは、CUDAのバージョンによるのでそこはよしなに変更する。
ここでは、CUDA 11.7を使う場合の例を示す。
詳しくは、[参考サイト](https://zenn.dev/turing_motors/articles/594fbef42a36ee)を参照。  

まず、pyproject.tomlに以下の記述を追加する。
```toml
[tool.uv]
extra-index-url = ["https://download.pytorch.org/whl/cu117"]
```
その後、以下のコマンドを実行する。
```bash
$ uv add "torch==2.0.1+cu117"
```
