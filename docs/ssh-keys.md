# SSH Keys

This guide covers both the simple single-account setup and the more complex
multi-account setup for Git hosting over SSH.

## Simple Setup

If you only use one GitHub account on the machine, you usually only need one
SSH key.

Generate a key:

```sh
ssh-keygen -t ed25519 -C "you@example.com"
```

This typically creates:

- `~/.ssh/id_ed25519`
- `~/.ssh/id_ed25519.pub`

Add the public key to GitHub:

```sh
pbcopy < ~/.ssh/id_ed25519.pub
```

Then verify the connection:

```sh
ssh -T git@github.com
```

For a single account, you often do not need any custom `~/.ssh/config` entry.

## Multiple Accounts

If you use multiple GitHub accounts on the same machine, use separate keys and
SSH host aliases.

Typical setup:

1. Generate or copy one key per account.
2. Add each public key to the matching Git hosting account.
3. Define SSH host aliases that point at the correct private keys.
4. Use those aliases in Git remotes.
5. Keep machine-specific host aliases and key names in an ignored local config when using dotfiles.

Example SSH config:

```sshconfig
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal

Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
```

Example clone URLs:

```sh
git clone git@github-personal:your-user/your-repo.git
git clone git@github-work:your-company/your-repo.git
```

Verify each account:

```sh
ssh -T git@github-personal
ssh -T git@github-work
```

If you use the companion `macOS-dotfiles` repo, the clean pattern is to keep
machine-specific SSH settings in an ignored local file such as
`~/.ssh/config.local` and load it from your main SSH config.
