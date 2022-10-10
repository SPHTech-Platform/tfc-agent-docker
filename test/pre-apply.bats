#!/usr/bin/env bats

load _helpers

@test "apply does not error without any inputs" {
    run terraform-pre-apply
    assert_line 'Skipping AWS Auth'
    assert_line 'Skipping GCP Auth'
    assert_line 'Skipping VAULT Auth'
}

@test "apply uses the right IAM Role" {
    TFC_AWS_RUN_ROLE_ARN="arn:foobar" \
        run terraform-pre-apply

    assert_line "IAM Role: arn:foobar"
    assert_line 'Skipping GCP Auth'
    assert_line 'Skipping VAULT Auth'

    TFC_AWS_RUN_ROLE_ARN="arn:foobar"
    TFC_AWS_APPLY_ROLE_ARN="arn:applier" \
        run terraform-pre-apply

    assert_line "IAM Role: arn:applier"
    assert_line 'Skipping GCP Auth'
    assert_line 'Skipping VAULT Auth'
}

@test "apply uses the right GCP Service Account" {
    TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL="email@gcp.com" \
        run terraform-pre-apply

    assert_line 'Skipping AWS Auth'
    assert_line 'GCP Service Account Email: email@gcp.com'
    assert_line 'Skipping VAULT Auth'

    TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL="email@gcp.com" \
    TFC_GCP_APPLY_SERVICE_ACCOUNT_EMAIL="applier@gcp.com" \
        run terraform-pre-apply

    assert_line 'Skipping AWS Auth'
    assert_line 'GCP Service Account Email: applier@gcp.com'
    assert_line 'Skipping VAULT Auth'
}

@test "apply uses the vault provider" {
    TFC_WORKLOAD_IDENTITY_AUDIENCE="tfc.sph" \
        run terraform-pre-apply

    assert_line 'Skipping AWS Auth'
    assert_line 'Skipping GCP Auth'
    assert_line 'VAULT provider auth prepared'
}
