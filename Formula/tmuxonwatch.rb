class Tmuxonwatch < Formula
  desc "macOS server installer and launcher for tmux on watch"
  homepage "https://tmuxonwatch.com"
  url "https://github.com/beneaug/TerminalPulse/archive/refs/tags/tmuxonwatch-2026.02.28.5.tar.gz"
  sha256 "bfbd6d550c64816bc624fe9e8f7ce475f9f8161db7a8d4ee8505e7f1b34e7410"
  license "Apache-2.0"

  depends_on "python@3.12"
  depends_on "tmux"

  def install
    libexec.install "install.sh"

    (libexec/"server").install "server/main.py"
    (libexec/"server").install "server/tmux_bridge.py"
    (libexec/"server").install "server/ansi_parser.py"
    (libexec/"server").install "server/requirements.txt"
    (libexec/"server").install "server/notify_event.py"

    (bin/"tmuxonwatch-install").write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail

      SOURCE_ROOT="#{libexec}"
      STAGING_ROOT="${TMUXONWATCH_STAGING_ROOT:-$HOME/tmuxonwatch/TerminalPulse}"
      SERVER_DIR="$STAGING_ROOT/server"

      mkdir -p "$SERVER_DIR"

      cp "$SOURCE_ROOT/install.sh" "$STAGING_ROOT/install.sh"
      cp "$SOURCE_ROOT/server/main.py" "$SERVER_DIR/main.py"
      cp "$SOURCE_ROOT/server/tmux_bridge.py" "$SERVER_DIR/tmux_bridge.py"
      cp "$SOURCE_ROOT/server/ansi_parser.py" "$SERVER_DIR/ansi_parser.py"
      cp "$SOURCE_ROOT/server/requirements.txt" "$SERVER_DIR/requirements.txt"
      cp "$SOURCE_ROOT/server/notify_event.py" "$SERVER_DIR/notify_event.py"
      chmod +x "$STAGING_ROOT/install.sh"

      exec bash "$STAGING_ROOT/install.sh" "$@"
    BASH
  end

  def caveats
    <<~EOS
      Next step:
        tmuxonwatch-install

      This command stages installer files under:
        ~/tmuxonwatch/TerminalPulse
    EOS
  end

  test do
    assert_path_exists libexec/"install.sh"
    assert_path_exists libexec/"server/main.py"
    assert_path_exists libexec/"server/notify_event.py"
    assert_path_exists bin/"tmuxonwatch-install"
  end
end
