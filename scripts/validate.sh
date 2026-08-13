#!/usr/bin/env bash
set -euo pipefail

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$repo_root"

printf 'validate: shell syntax\n'
while IFS= read -r script; do
  bash -n "$script"
done < <(find scripts -type f -name '*.sh' -print | LC_ALL=C sort)

printf 'validate: YAML parse\n'
ruby -ryaml -e '
Dir.glob("{.github,configuration,kubernetes}/**/*.{yml,yaml}", File::FNM_DOTMATCH).sort.each do |path|
  YAML.parse_stream(File.read(path))
end
'

printf 'validate: reviewer correction contract\n'
ruby -ryaml -e '
deployment = YAML.safe_load(File.read("kubernetes/bundles/example-app/deployment.yaml"))
container = deployment.dig("spec", "template", "spec", "containers").find { |item| item["name"] == "web" }
abort("example-app readiness probe must use /readyz") unless container.dig("readinessProbe", "httpGet", "path") == "/readyz"

tasks = YAML.safe_load(File.read("configuration/roles/base/tasks/main.yml"))
journal_directory_index = tasks.index { |task| task.dig("ansible.builtin.file", "path") == "/etc/systemd/journald.conf.d" }
journal_copy_index = tasks.index { |task| task.dig("ansible.builtin.copy", "dest") == "/etc/systemd/journald.conf.d/20-example-retention.conf" }
journal_directory = tasks[journal_directory_index] if journal_directory_index
expected = {"path" => "/etc/systemd/journald.conf.d", "state" => "directory", "owner" => "root", "group" => "root", "mode" => "0755"}
directory_contract = journal_directory && expected.all? { |key, value| journal_directory["ansible.builtin.file"][key] == value }
abort("journald configuration directory contract is incomplete or unordered") unless directory_contract && journal_copy_index && journal_directory_index < journal_copy_index

configuration_readme = File.read("configuration/README.md")
abort("configuration prerequisite must state Debian/Ubuntu with systemd") unless configuration_readme.include?("Debian/Ubuntu") && configuration_readme.include?("systemd")
'

printf 'validate: SVG/XML parse\n'
ruby -rrexml/document -e 'REXML::Document.new(File.read("docs/architecture.svg"))'

printf 'validate: relative Markdown links\n'
ruby -e '
Dir.glob("**/*.md").sort.each do |path|
  File.read(path).scan(/\[[^\]]*\]\(([^)]+)\)/).flatten.each do |target|
    next if target.start_with?("http://", "https://", "#")
    clean = target.split("#", 2).first
    next if clean.empty?
    resolved = File.expand_path(clean, File.dirname(path))
    abort("missing link target #{target} in #{path}") unless File.exist?(resolved)
  end
end
'

printf 'validate: workflow safety contract\n'
ruby -e '
path = ".github/workflows/validate.yml"
workflow = File.read(path)
forbidden = ["self-hosted", "workflow_dispatch", "id-token:", "secrets.", "permissions: write", "contents: write", "pull-requests: write"]
forbidden.each { |text| abort("unsafe workflow token: #{text}") if workflow.include?(text) }
abort("workflow must use a GitHub-hosted runner") unless workflow.match?(/runs-on:\s+ubuntu-/)
abort("workflow must declare contents read") unless workflow.match?(/contents:\s+read/)
checkout = workflow.match(/uses:\s+actions\/checkout@[^\n]+\n(?<settings>(?:\s+[^\n]*\n)*)/)
abort("workflow must pin actions/checkout") unless checkout
abort("checkout must disable credential persistence") unless checkout[:settings].match?(/persist-credentials:\s+false/)
'

if command -v tofu >/dev/null 2>&1; then
  printf 'validate: OpenTofu formatting\n'
  tofu fmt -check -recursive infrastructure
else
  printf 'validate: OpenTofu unavailable; formatting check skipped\n'
fi

if command -v terragrunt >/dev/null 2>&1; then
  printf 'validate: Terragrunt HCL formatting\n'
  while IFS= read -r hcl; do terragrunt hcl format --check --file "$hcl"; done < <(find infrastructure -name '*.hcl' -print | LC_ALL=C sort)
else
  printf 'validate: Terragrunt unavailable; HCL check skipped\n'
fi

if command -v ansible-playbook >/dev/null 2>&1; then
  printf 'validate: Ansible syntax\n'
  (cd configuration && ansible-playbook playbooks/site.yml --syntax-check)
else
  printf 'validate: Ansible unavailable; syntax check skipped\n'
fi

./scripts/privacy-scan.sh
printf 'validate: PASS\n'
