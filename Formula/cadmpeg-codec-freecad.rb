class CadmpegCodecFreecad < Formula
  desc "Read and write FreeCAD FCStd document archives."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-freecad-aarch64-apple-darwin.tar.xz"
      sha256 "d4ba82b1ebaa9dd523983038cd73c18d5ab3272ae4cabb46d4f59775dcbd37fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-freecad-x86_64-apple-darwin.tar.xz"
      sha256 "6ef77a2a1556400a6226613f2a23f1c444fe59497312b3784ddf3f4d8783513d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-freecad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efaa99ff0a72d0f248f9abf1125fce235591714ea2aef48b2c11ab1c4f4dad26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-freecad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d20eda4b9bcf78c33c77cbc8bbcac31f1fd7f620c3d2dfbe077e7037fd75f55"
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
