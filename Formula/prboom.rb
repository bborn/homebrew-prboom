class Prboom < Formula
  desc "Pick a pull request and walk it one finding at a time"
  homepage "https://github.com/bborn/prboom"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bborn/prboom/releases/download/v0.1.1/prboom-darwin-arm64.tar.gz"
      sha256 "bdcc2623b37e21dd39fb069eeb5606ee307780ce4c5d1b59a847424117a5af44"
    end
    on_intel do
      url "https://github.com/bborn/prboom/releases/download/v0.1.1/prboom-darwin-amd64.tar.gz"
      sha256 "fb42007ccf23f79303036bbbadd7f648533f95616fefd2b7ca79ba78931a8601"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bborn/prboom/releases/download/v0.1.1/prboom-linux-arm64.tar.gz"
      sha256 "47677744aee12bad4c65ba2a0c8994a625656c4c840507a2a9e7fc72db4be717"
    end
    on_intel do
      url "https://github.com/bborn/prboom/releases/download/v0.1.1/prboom-linux-amd64.tar.gz"
      sha256 "a5a6bed3f56289174529a2d9c15d918ba8a6d28ddc5e896c368e7129085c814a"
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
