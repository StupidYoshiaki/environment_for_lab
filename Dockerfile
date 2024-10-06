FROM nvidia/cuda:11.7.1-runtime-centos7

# DNS設定の修正 (GoogleのパブリックDNSを使用)
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf

# CentOS 7リポジトリの設定を更新
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
    yum -y update && yum clean all

# 必要なパッケージと依存ライブラリのインストール
RUN yum -y install \
    libffi-devel \
    zlib-devel \
    bzip2-devel \
    readline-devel \
    sqlite-devel \
    wget \
    curl \
    perl \
    make \
    gcc \
    gcc-c++ \
    git \
    vim \
    zsh \
    sudo \
    pkgconfig \
    xz-devel && \
    yum clean all

# OpenSSLをソースからインストール
RUN wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz && \
    tar -xzf openssl-1.1.1w.tar.gz && \
    cd openssl-1.1.1w && \
    ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib && \
    make && make install

# Pythonビルドに必要な環境変数を設定
ENV LDFLAGS="-L/usr/local/openssl/lib" \
    CPPFLAGS="-I/usr/local/openssl/include" \
    LD_LIBRARY_PATH="/usr/local/openssl/lib" \
    PKG_CONFIG_PATH="/usr/local/openssl/lib/pkgconfig" \
    PYTHON_CONFIGURE_OPTS="--with-openssl=/usr/local/openssl"

# 作業ディレクトリを設定
WORKDIR /workspace

# タイムゾーンの設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# asdfのインストールとPython 3.11.5の設定
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3 && \
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc && \
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# SHELLコマンドを使ってbashを一時的に切り替え、asdfを利用可能にする
SHELL ["/bin/bash", "-c"]
RUN source ~/.bashrc && \
    asdf plugin-add python && \
    asdf install python 3.11.5 && \
    asdf global python 3.11.5

# デフォルトシェルをbashに設定
CMD ["/bin/bash"]

# 実行するコマンド: docker run -it --name "コンテナの名前" -v $(pwd):/workspace "イメージの名前" /bin/bash
# 例: docker run -it --name inference_gemma_container -v $(pwd):/workspace inference_gemma_image /bin/bash