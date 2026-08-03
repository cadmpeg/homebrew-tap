class Cadmpeg < Formula
  desc "Inspect, decode, validate, compare, and convert CAD models."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "ea7a03ac4738c110e2cdac655416a7dc19840e41ecc547a8a0d886ce52bdba98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "d1ebaaa4cd721cdf0066f6136a2ab6b399faab2e8517d1828323e6f118501a54"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84488bf051e83a01ae5219b2fbc4075a3a61a0609d3cdfcd46f1a9f77d1f4cf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51ac59c11376279536a33288f00654777e627e96e2d1e52213ed20a2d0daedb3"
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
