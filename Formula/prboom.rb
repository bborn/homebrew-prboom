class Prboom < Formula
  desc "Pick a pull request and walk it one finding at a time"
  homepage "https://github.com/bborn/prboom"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bborn/prboom/releases/download/v0.1.2/prboom-darwin-arm64.tar.gz"
      sha256 "d19837afa1e782d34551ddf3e7633c33478d5cff96f4b4bbad598f5e48f0aa2c"
    end
    on_intel do
      url "https://github.com/bborn/prboom/releases/download/v0.1.2/prboom-darwin-amd64.tar.gz"
      sha256 "f6840e09386b44c5bc4a57db504225e14d8ce9f8c084151ddb57283e3b26dda5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bborn/prboom/releases/download/v0.1.2/prboom-linux-arm64.tar.gz"
      sha256 "6bebc7812a976748ca8bf2a575c777771ec8ce4359fbebd43e5df6d22aa04549"
    end
    on_intel do
      url "https://github.com/bborn/prboom/releases/download/v0.1.2/prboom-linux-amd64.tar.gz"
      sha256 "a7967b7bf3060eebd1d6aac1be041f75aa98e8a100404eb742704cae3dc44cb5"
    end
  end

  depends_on "gh"
  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  # Optional, for syntax highlighting. Without them pr-show falls back to
  # git diff --color and nl.
  depends_on "bat" => :recommended
  depends_on "git-delta" => :recommended

  def install
    # The whole tree goes to libexec, because the scripts find the skill by
    # walking up from their own resolved path. Only the commands are exposed.
    libexec.install Dir["bin", "skills"]
    Dir["#{libexec}/bin/*"].each do |f|
      next if File.basename(f) == "prboom-env" # sourced, never run

      bin.install_symlink f
    end
  end

  def caveats
    <<~EOS
      The pr-walk skill only does anything inside a Claude config directory,
      and a formula must not write to your home directory. Link it yourself:

        prboom --link-skill
    EOS
  end

  test do
    assert_match "prboom", shell_output("#{bin}/prboom -h 2>&1", 2)
  end
end
