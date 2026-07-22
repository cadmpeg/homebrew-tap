class CadmpegCodecFreecad < Formula
  desc "Read and write FreeCAD FCStd document archives."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-codec-freecad-aarch64-apple-darwin.tar.xz"
      sha256 "0209b813293729b9c9b4b8af53bf0e79a84e833bd9a9c6aa4fd3ccb49ee6959a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-codec-freecad-x86_64-apple-darwin.tar.xz"
      sha256 "a1f1b08ea8d71e8beae5a5f282008b45b30bffd72b1d8ec6398ffd5fa683a020"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-codec-freecad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15a58b5ebc04f81696b8e0b6575765464cccda70a76bdee6f27ff0dbf2a3462b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-codec-freecad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "144a8fa63f9a624f71f0386e6bc5feed86d5edc961be693665719301d5299696"
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
    bin.install "fcstd-profile" if OS.mac? && Hardware::CPU.arm?
    bin.install "fcstd-profile" if OS.mac? && Hardware::CPU.intel?
    bin.install "fcstd-profile" if OS.linux? && Hardware::CPU.arm?
    bin.install "fcstd-profile" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
