# homebrew-prboom

Homebrew tap for [prboom](https://github.com/bborn/prboom).

```
brew install bborn/prboom/prboom
prboom --link-skill
```

The second line is separate because a formula must not write to your home
directory, and the `pr-walk` skill only does anything inside a Claude config
directory.
