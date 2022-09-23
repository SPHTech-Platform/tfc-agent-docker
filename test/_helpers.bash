setup() {
  export AWS_TOKEN_FILE="${BATS_TEST_TMPDIR}/.aws-workload/token-file"
  export GCP_WORKLOAD_BASE="${BATS_TEST_TMPDIR}/.gcp-workload"
  export HOME="${BATS_TEST_TMPDIR}/home"
  export TFC_WORKLOAD_IDENTITY_TOKEN="foobar"
  export TFC_RUN_ID="run-12345"
  export TFC_GCP_PROJECT_NUMBER=12345
  export TFC_GCP_WORKLOAD_POOL_ID="swim.with.google"
  export TFC_GCP_WORKLOAD_PROVIDER_ID="tfc"

  mkdir -p "${HOME}"
  mkdir -p "${BATS_TEST_TMPDIR}/.aws-workload"
  mkdir -p "${GCP_WORKLOAD_BASE}"

  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )" >/dev/null 2>&1 && pwd )"
  # make executables in src/ visible to PATH
  PATH="${DIR}/../hooks:$PATH"

  load 'test_helper/bats-support/load' # this is required by bats-assert!
  load 'test_helper/bats-assert/load'
}
