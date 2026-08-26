class Cadmpeg < Formula
  desc "Convert and inspect native CAD files."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.5/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "9a593d35e525d2affd1b647ef64693fd1acb620c81a76dca2281287043d03572"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.5/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "b98444a2b22f07113be6a4ed1cccdd7fbfb4f57d7d9d4e9779164c8203faa533"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.5/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1eafb41d006f0d29d9f0d176e7fe58a50174609bfb0915dcfb2ca77545088304"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.5/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0490992d12447392eacf861b59987bef0114adbcc5499e6a733e364deb436524"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cadmpeg"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cadmpeg"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cadmpeg"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cadmpeg"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
