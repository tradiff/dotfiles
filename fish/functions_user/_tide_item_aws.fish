# Overrides the tide default. Shows only the profile name (not region)

function _tide_item_aws
    # AWS_PROFILE overrides AWS_DEFAULT_PROFILE
    set -q AWS_PROFILE && set -l AWS_DEFAULT_PROFILE $AWS_PROFILE

    if test -n "$AWS_DEFAULT_PROFILE"
        _tide_print_item aws $tide_aws_icon' ' "$AWS_DEFAULT_PROFILE"
    end
end
