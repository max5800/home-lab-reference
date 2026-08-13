#!/usr/bin/env bash
set -euo pipefail

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$repo_root"

fail() {
  printf 'privacy: FAIL: %s\n' "$1" >&2
  exit 1
}

if find . -path './.git' -prune -o -type l -print | grep -q .; then
  fail "symbolic links are not allowed"
fi

while IFS= read -r file_path; do
  mime_type="$(file -b --mime-type "$file_path")"
  case "$mime_type" in
    text/*|application/json|application/xml|application/x-empty|image/svg+xml) ;;
    *) fail "unexpected non-text file: ${file_path#./} (${mime_type})" ;;
  esac
done < <(find . -path './.git' -prune -o -type f -print | LC_ALL=C sort)

key_header='BEGIN [A-Z0-9 ]*PRIVATE'' KEY'

ruby -e '
allowed_domains = %w[
  cert-manager.io
  example.com
  external-secrets.io
  github.com
  k8s.io
  kubernetes.io
  w3.org
]
allowed_repositories = %w[max5800/home-lab-reference]
allowed_personal_paths = %w[/home/example]

files = Dir.glob("**/*", File::FNM_DOTMATCH).sort.select do |path|
  File.file?(path) && !path.start_with?(".git/")
end

files.each do |path|
  text = File.binread(path)

  text.scan(/(?<![A-Za-z0-9.-])(?:[A-Za-z0-9-]+\.)+(?:com|dev|io|net|org)(?![A-Za-z0-9.-])/i) do |match|
    domain = match.downcase
    allowed = allowed_domains.any? { |candidate| domain == candidate || domain.end_with?(".#{candidate}") }
    abort("privacy: FAIL: non-allowlisted domain in #{path}") unless allowed
  end

  text.scan(%r{github\.com/([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)}i) do |match|
    repository = match.first.delete_suffix(".git")
    abort("privacy: FAIL: non-allowlisted repository in #{path}") unless allowed_repositories.include?(repository)
  end

  text.scan(%r{/(?:Users|home)/[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*}) do |personal_path|
    allowed = allowed_personal_paths.any? do |candidate|
      personal_path == candidate || personal_path.start_with?("#{candidate}/")
    end
    abort("privacy: FAIL: non-allowlisted personal path in #{path}") unless allowed
  end
end
'

if rg -nI --hidden --glob '!.git/**' --pcre2 "$key_header|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{30,}|xox[baprs]-[A-Za-z0-9-]{20,}" . >/dev/null; then
  fail "credential-like material detected"
fi

if rg -nI --hidden --glob '!.git/**' --pcre2 "(?i)(password|api[_-]?key|access[_-]?token|client[_-]?secret)\\s*[:=]\\s*[\"']?[A-Za-z0-9+/_.-]{8,}" . >/dev/null; then
  fail "credential assignment detected"
fi

if rg -nI --hidden --glob '!.git/**' --pcre2 '(?i)(?:[0-9a-f]{2}:){5}[0-9a-f]{2}' . >/dev/null; then
  fail "MAC-like device identifier detected"
fi

ruby -ripaddr -e '
allowed = [IPAddr.new("192.0.2.0/24"), IPAddr.new("198.51.100.0/24"), IPAddr.new("203.0.113.0/24")]
Dir.glob("**/*", File::FNM_DOTMATCH).sort.each do |path|
  next unless File.file?(path)
  next if path.start_with?(".git/")
  File.binread(path).scan(/(?<![0-9])(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?![0-9])/) do |text|
    begin
      ip = IPAddr.new(text)
    rescue IPAddr::InvalidAddressError
      next
    end
    abort("privacy: FAIL: non-documentation IPv4 address in #{path}") unless allowed.any? { |range| range.include?(ip) }
  end
end
'

if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --no-banner --redact --no-git --source . >/dev/null
  printf 'privacy: gitleaks worktree scan passed\n'
else
  printf 'privacy: gitleaks unavailable; custom high-signal scan passed\n'
fi

printf 'privacy: PASS\n'
