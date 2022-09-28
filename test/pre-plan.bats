#!/usr/bin/env bats

load _helpers

@test "plan does not error without any inputs" {
    run terraform-pre-plan
    assert_line 'Skipping AWS Auth'
    assert_line 'Skipping GCP Auth'
}

@test "plan uses the right IAM Role" {
    TFC_AWS_RUN_ROLE_ARN="arn:foobar" \
        run terraform-pre-plan

    assert_line "IAM Role: arn:foobar"
    assert_line 'Skipping GCP Auth'

    TFC_AWS_RUN_ROLE_ARN="arn:foobar"
    TFC_AWS_PLAN_ROLE_ARN="arn:planner" \
        run terraform-pre-plan

    assert_line "IAM Role: arn:planner"
    assert_line 'Skipping GCP Auth'
}

@test "plan uses the right GCP Service Account" {
    TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL="email@gcp.com" \
        run terraform-pre-plan

    assert_line 'Skipping AWS Auth'
    assert_line 'GCP Service Account Email: email@gcp.com'

    TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL="email@gcp.com" \
    TFC_GCP_PLAN_SERVICE_ACCOUNT_EMAIL="planner@gcp.com" \
        run terraform-pre-plan

    assert_line 'Skipping AWS Auth'
    assert_line 'GCP Service Account Email: planner@gcp.com'
}

@test "plan uses the right VAULT role" {
    TFC_VAULT_RUN_ROLE="tfc-vault-role" \
        run terraform-pre-plan

    assert_line 'Skipping AWS Auth'
    assert_line 'Skipping GCP Auth'
    assert_line 'VAULT Role: tfc-vault-role'

    TFC_VAULT_RUN_ROLE="tfc-vault-role" \
    TFC_VAULT_PLAN_ROLE="tfc-vault-plan-role" \
        run terraform-pre-plan

    assert_line 'Skipping AWS Auth'
    assert_line 'Skipping GCP Auth'
    assert_line 'VAULT Role: tfc-vault-plan-role'
}
