require_dependency Rails.root.join('app', 'models', 'setting').to_s

# [code4ro]
# Enable user verification by default
Setting["feature.user.skip_verification"] = false
