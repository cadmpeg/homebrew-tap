class Cadmpeg < Formula
  desc "Inspect, decode, validate, compare, and convert CAD models."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "03a179b7643ab22bd17a73b469d10f6146df89cadadb30dac19660d72c96c2f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "241d3fbbc97f5225a9927d5303fcfe5c61770f43fc5b9d041ef58527a9d2bda2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d8fd1a2246e94ca3aeb4cd0482f1975ce1e18746799286d5f1575bcaaf06d35c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "be391c626a05f1f02b986be2e0b1152d3ec4b61eefb9942f3bf663ffe0b48387"
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
    bin.install "cadmpeg" if OS.mac? && Hardware::CPU.arm?
    bin.install "cadmpeg" if OS.mac? && Hardware::CPU.intel?
    bin.install "cadmpeg" if OS.linux? && Hardware::CPU.arm?
    bin.install "cadmpeg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
