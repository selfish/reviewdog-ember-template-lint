#!/bin/sh

set -o pipefail

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

if [ ! -f "$(npm bin)/ember-template-lint" ]; then
  npm install --legacy-peer-deps
fi

"$(npm bin)"/ember-template-lint --version

DISABLE_GITHUB_ACTIONS_ANNOTATIONS=true "$(npm bin)"/ember-template-lint --json ${INPUT_TEMPLATE_LINT_FLAGS:-'.'} | \
node /formatter.js | \

reviewdog -f=rdjson \
  -name="${INPUT_TOOL_NAME}" \
  -reporter="${INPUT_REPORTER:-github-pr-review}" \
  -filter-mode="${INPUT_FILTER_MODE}" \
  -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
  -level="${INPUT_LEVEL}" >> output.json

cat "==========="
cat "==========="
cat "==========="
cat "==========="
cat output.json
cat "==========="
cat "==========="
cat "==========="
cat "==========="
