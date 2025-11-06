## 0.3.3

- Upgrade to latest rails.
- Drop ruby < 3.2 support.

## 0.3.2

- Move patches to RailsPatch Module.
- Introduce `#apply_rails_patch!`

## 0.3.1

- Automate CI release

## 0.3.0

- Rename Extension to Patch and move to Init Module.
- Update various gems.
- Rails 7.1 support check.

## 0.2.5

- Remove `attributes` keyword.
- Development dependency gems upgrade.

## 0.2.4

- Avoid `symbolize_keys' for nil:NilClass error.

## 0.2.3

- Moving to ArgumentError for better semantics.

## 0.2.1

- Better rails monkey path apply. Rails extension classes without namespace.

## 0.2.0

- New gem version with better code organization.

## 0.1.2

- Move config struct option definition from `#method_missing` to `#define_singleton_method`

## 0.1.1

- Remove Rails dependency.

## 0.1.0

- Default behaviour.
- Option `recursive` to `#load_struct`.
- Option `allow_nil` to `#load_struct`.
- Specs.
- Documentation and examples.
